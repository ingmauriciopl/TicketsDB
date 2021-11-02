drop procedure sp_obtener_eventos
go

create procedure sp_obtener_eventos
@i_usuario int = 0,  
@o_error_msg varchar(255)	= '' output 
as

declare   
@f_error smallint = 0,
@f_rowcount smallint = 0,
@f_fecha_proceso date	= getdate()				

----------------------------------------------------------------------------------------------
-- iniciar
----------------------------------------------------------------------------------------------									
set nocount on
   
----------------------------------------------------------------------------------------------
-- validar el usuario
----------------------------------------------------------------------------------------------   
if not exists(select 1
														from usuarios
														where usuario = @i_usuario
														and indicador = 'A' and @f_fecha_proceso between fecha_proceso and fecha_proceso_hasta)
begin
			set @o_error_msg = 'no existe el usuario' 
			goto error 
end

----------------------------------------------------------------------------------------------
-- mostrar datos
----------------------------------------------------------------------------------------------
select evento,
							nombre,
							fecha
from eventos
where usuario = @i_usuario
and indicador = 'A' and @f_fecha_proceso between fecha_proceso and fecha_proceso_hasta
order by fecha_alta desc

select @f_error = @@error, @f_rowcount = @@rowcount

if @f_error <> 0 
begin
			set @o_error_msg = 'error al seleccionar eventos'
			goto error
end

if @f_rowcount = 0 
begin
			set @o_error_msg = 'el usuario no tiene eventos'
			goto error
end

----------------------------------------------------------------------------------------------
-- salir
----------------------------------------------------------------------------------------------	
return 0
	
----------------------------------------------------------------------------------------------
-- error
----------------------------------------------------------------------------------------------
error:
			set @o_error_msg = 'sp_obtener_eventos = ' + @o_error_msg
			
			if @@nestlevel = 1 
			   raiserror(@o_error_msg,16,-1)

			return -1
go
