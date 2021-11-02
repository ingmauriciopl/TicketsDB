drop procedure sp_grabar_premios_eventos
go

create procedure sp_grabar_premios_eventos 
@i_evento int = 0,
@i_premios as type_premios readonly,
@i_usuario_alta int,              
@o_error_msg varchar(255) = '' output
as

declare 
@f_error_exec smallint,
@f_secuencia smallint = 1 ,   												
@f_orden	smallint = 1,
@f_nombre varchar(255) = '',
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
if @i_evento <> 0
begin
			update premios_eventos
			set indicador = case when fecha_proceso = @f_fecha_proceso 
																								then 'N'
																								else 'A' end,
							fecha_proceso_hasta = case when fecha_proceso = @f_fecha_proceso 
																																		then fecha_proceso 
																																		else dateadd(day,-1,@f_fecha_proceso) end,    
							@f_secuencia = case when fecha_proceso = @f_fecha_proceso 
																											then secuencia + 1 
																											else 1	end,
							usuario_baja = @i_usuario_alta,
							fecha_baja = getdate()
			where evento = @i_evento 	
			and indicador = 'A' and fecha_proceso_hasta = '31/12/9999'
									
			if @@error <> 0 
			begin
						set @o_error_msg = 'error al actualizar premios_eventos'
						goto error
			end														
end

---------------------------------------------------------------------------------------------------------------
-- insertar
---------------------------------------------------------------------------------------------------------------   
declare cursor_premios cursor fast_forward for     	
select nombre
from @i_premios		
open cursor_premios
fetch next from cursor_premios into @f_nombre
while @@fetch_status = 0
begin						
			insert into premios_eventos
			select evento = @i_evento, 
										orden = @f_orden, 
																	
										fecha_proceso = @f_fecha_proceso, 
										fecha_proceso_hasta = '31/12/9999', 															
										secuencia = @f_secuencia, 
										indicador = 'A', 
																	
										nombre = @f_nombre, 
																	
										usuario = @i_usuario_alta,
										fecha_alta = getdate(), 
										usuario_baja = null,
										fecha_baja = null
																	
			if @@error <> 0 
			begin
						set @o_error_msg = 'error al actualizar premios_eventos'
						goto error
			end

			set @f_orden = @f_orden + 1
				         									     															
			fetch next from cursor_premios into @f_nombre
end
close cursor_premios
deallocate cursor_premios
  
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
   set @o_error_msg = 'sp_grabar_premios_eventos = ' + @o_error_msg

   if @@nestlevel = 1 
			   rollback tran 

			select @o_error_msg
   return -1
go