drop procedure sp_obtener_evento
go

create procedure sp_obtener_evento
@i_evento int = 0,  
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
-- validar el evento
----------------------------------------------------------------------------------------------   
if not exists(select 1
														from eventos
														where evento = @i_evento
														and indicador = 'A' and @f_fecha_proceso between fecha_proceso and fecha_proceso_hasta)
begin
			set @o_error_msg = 'no existe el evento' 
			goto error 
end

----------------------------------------------------------------------------------------------
-- mostrar datos
----------------------------------------------------------------------------------------------
select e.evento,
							e.nombre,
							e.fecha,
							u.nombre_usuario
from eventos e
inner join usuarios u on u.usuario = e.usuario
where e.evento = @i_evento
and e.indicador = 'A' and @f_fecha_proceso between e.fecha_proceso and e.fecha_proceso_hasta
and u.indicador = 'A' and @f_fecha_proceso between u.fecha_proceso and u.fecha_proceso_hasta

if @@error <> 0 
begin
			set @o_error_msg = 'error al seleccionar evento'
			goto error
end

select orden,
							nombre
from premios_eventos p
where p.evento = @i_evento
and p.indicador = 'A' and @f_fecha_proceso between p.fecha_proceso and p.fecha_proceso_hasta

if @@error <> 0 
begin
			set @o_error_msg = 'error al seleccionar premios'
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
			set @o_error_msg = 'sp_obtener_evento = ' + @o_error_msg
			
			if @@nestlevel = 1 
			   raiserror(@o_error_msg,16,-1)

			return -1
go
