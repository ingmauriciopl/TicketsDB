drop procedure sp_grabar_ticket
go

create procedure sp_grabar_ticket
@i_ticket	int = 0, 
@i_numero int,
@i_nombre varchar(255),
@i_telefono varchar(255),
@i_evento int,
@i_usuario_alta int = 0,  
@o_error_msg varchar(255) = '' output
as

declare 
@f_secuencia smallint,                
@f_error smallint,                
@f_rowcount smallint,
@f_fecha_proceso date = getdate()
               
----------------------------------------------------------------------------------------------
-- sentencias fijas
----------------------------------------------------------------------------------------------							
if @@nestlevel = 1 and @@trancount > 0
			rollback tran

if @@nestlevel = 1
			begin tran

------------------------------------------------------------------------------------------------------------------
-- actualizar 
------------------------------------------------------------------------------------------------------------------
set @f_secuencia = 1 
     
if @i_ticket > 0
begin						
			update tickets						
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
			where ticket = @i_ticket  
			and indicador = 'A' and fecha_proceso_hasta = '31/12/9999'  
									
			if @@error <> 0
			begin
						set @o_error_msg = 'error al actualizar tickets'
						goto error
			end   
end			
					 
	---------------------------------------------------------------------------------------------------------------
	-- insertar
	---------------------------------------------------------------------------------------------------------------     
insert into tickets
select evento = @i_ticket, 
							fecha_proceso = @f_fecha_proceso, 
							fecha_proceso_hasta = '31/12/9999',
							secuencia = @f_secuencia, 
							indicador = 'A', 					

							numero = @i_numero,
							nombre = @i_nombre, 
							telefono = @i_telefono,
							evento = @i_evento,

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
   set @o_error_msg = 'sp_grabar_ticket = ' + @o_error_msg

   if @@nestlevel = 1 
			   rollback tran 

   return -1
go