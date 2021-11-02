drop procedure sp_grabar_evento
go

create procedure sp_grabar_evento
@i_evento	int = 0, 
@i_nombre varchar(255),
@i_fecha date,
@i_usuario int,
@i_usuario_alta int = 0,  
@o_error_msg varchar(255) = '' output
as

declare 
@f_secuencia smallint,                
@f_error smallint,                
@f_rowcount smallint,
@f_fecha_proceso date = getdate()
               
----------------------------------------------------------------------------------------------
-- iniciar
----------------------------------------------------------------------------------------------							
if @@nestlevel = 1 and @@trancount > 0
			rollback tran

if @@nestlevel = 1
			begin tran

------------------------------------------------------------------------------------------------------------------
-- actualizar 
------------------------------------------------------------------------------------------------------------------
set @f_secuencia = 1 
     
if @i_evento > 0
begin						
			update eventos						
			set indicador = case when fecha_proceso = @f_fecha_proceso
																								then 'N' 
																								else 'A' end,
			fecha_proceso_hasta = case when fecha_proceso = @f_fecha_proceso 
																														then @f_fecha_proceso  
																														else dateadd(day,-1,@f_fecha_proceso) end,          
			@f_secuencia = case when fecha_proceso = @f_fecha_proceso 
																							then secuencia + 1  
																							else 1 end,
			usuario_baja = @i_usuario_alta,																																				      
			fecha_baja = getdate()
			where evento = @i_evento  
			and indicador = 'A' and fecha_proceso_hasta = '31/12/9999' 
									
			if @@error <> 0
			begin
						set @o_error_msg = 'error al actualizar eventos'
						goto error
			end   
end			
					 
	---------------------------------------------------------------------------------------------------------------
	-- insertar
	---------------------------------------------------------------------------------------------------------------     
insert into eventos
select evento = @i_evento, 
							fecha_proceso = @f_fecha_proceso, 
							fecha_proceso_hasta = '31/12/9999',
							secuencia = @f_secuencia, 
							indicador = 'A', 					
							nombre = @i_nombre,
							fecha = @i_fecha, 
							usuario = @i_usuario,
							usuario_alta = @i_usuario_alta, 
							fecha_alta = getdate(), 
							usuario_baja = null, 
							fecha_baja = null 
			
select @f_error = @@error, @f_rowcount = @@rowcount

if @f_error <> 0 or @f_rowcount = 0
begin
			set @o_error_msg = 'error al insertar eventos'
			goto error
end    
	
----------------------------------------------------------------------------------------------
-- salir
----------------------------------------------------------------------------------------------	
if @@nestlevel = 1
   commit tran				
return 0

----------------------------------------------------------------------------------------------
-- error
----------------------------------------------------------------------------------------------
error:
   set @o_error_msg = 'sp_grabar_evento = ' + @o_error_msg

   if @@nestlevel = 1 
			   rollback tran 

   return -1
go