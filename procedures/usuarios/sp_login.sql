drop procedure sp_login
go

create procedure sp_login
@i_nombre_usuario varchar(255) = '',  
@i_clave varchar(255) = '',
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
-- mostrar datos
----------------------------------------------------------------------------------------------
select usuario,
							nombre_usuario,
							correo
from usuarios
where nombre_usuario = @i_nombre_usuario
and clave = @i_clave
and indicador = 'A' and @f_fecha_proceso between fecha_proceso and fecha_proceso_hasta

select @f_rowcount = @@rowcount, @f_error = @@error

if @f_error <> 0 
begin
			set @o_error_msg = 'error al seleccionar usuario'
			goto error
end

if @f_rowcount = 0 
begin
			set @o_error_msg = 'datos invalidos'
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
			set @o_error_msg = 'sp_login = ' + @o_error_msg
			
			if @@nestlevel = 1 
			   raiserror(@o_error_msg,16,-1)

			return -1
go
