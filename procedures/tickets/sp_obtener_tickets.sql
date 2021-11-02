drop procedure sp_obtener_tickets
go

create procedure sp_obtener_tickets
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
select ticket,
							numero,
							nombre,
							telefono
from tickets
where evento = @i_evento
and indicador = 'A' and @f_fecha_proceso between fecha_proceso and fecha_proceso_hasta
order by fecha_alta desc

select @f_error = @@error, @f_rowcount = @@rowcount

if @f_error <> 0 
begin
			set @o_error_msg = 'error al seleccionar tickets'
			goto error
end

if @f_rowcount = 0 
begin
			set @o_error_msg = 'el evento no tiene tickets'
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
			set @o_error_msg = 'sp_obtener_tickets = ' + @o_error_msg
			
			if @@nestlevel = 1 
			   raiserror(@o_error_msg,16,-1)

			return -1
go
