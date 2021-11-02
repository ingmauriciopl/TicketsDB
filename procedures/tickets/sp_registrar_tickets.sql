drop procedure sp_registrar_tickets
go

create procedure sp_registrar_tickets
@i_nombre varchar(255),
@i_telefono varchar(255),
@i_evento int,
@i_cantidad int,
@i_usuario_alta int = 0,   
@o_error_msg varchar(255) = '' output
as

declare	
@f_error_exec smallint,
@f_contador int = 1,
@f_ticket int,
@f_numero	int = 0

----------------------------------------------------------------------------------------------
-- iniciar
----------------------------------------------------------------------------------------------
set nocount on
set xact_abort on
			
if @@nestlevel = 1 and @@trancount > 0
			rollback tran
			
if @@nestlevel = 1
			begin tran  

----------------------------------------------------------------------------------------------
-- generar tickets de acuerdo a la cantidad
----------------------------------------------------------------------------------------------
while @f_contador <= @i_cantidad
begin 
			----------------------------------------------------------------------------------------------
			-- generar ticket
			----------------------------------------------------------------------------------------------
			select @f_ticket = isnull(max(ticket),0) + 1
			from tickets t
			where t.indicador = 'A' and t.fecha_proceso_hasta = '31/12/9999'

			----------------------------------------------------------------------------------------------
			-- generar numero
			----------------------------------------------------------------------------------------------
			select @f_numero = isnull(max(numero),0) + 1
			from tickets t
			where t.evento = @i_evento
			and t.indicador = 'A' and t.fecha_proceso_hasta = '31/12/9999'

			----------------------------------------------------------------------------------------------
			-- grabar ticket
			----------------------------------------------------------------------------------------------
			exec @f_error_exec = sp_grabar_ticket
																								@i_ticket = @f_ticket,				
																								@i_numero = @f_numero,
																								@i_nombre = @i_nombre,
																								@i_telefono = @i_telefono,
																								@i_evento = @i_evento,
																								@i_usuario_alta	= @i_usuario_alta,
																								@o_error_msg = @o_error_msg output
			if @@error <> 0 
			begin
						set @o_error_msg = 'error al ejecutar sp_grabar_ticket'
						goto error
			end
			if @f_error_exec <> 0 goto error  	

   set @f_contador = @f_contador + 1    
end
				
----------------------------------------------------------------------------------------------
-- salir
----------------------------------------------------------------------------------------------
commit tran
return 0

----------------------------------------------------------------------------------------------
-- error
----------------------------------------------------------------------------------------------
error:
   set @o_error_msg = 'sp_registrar_tickets = ' + @o_error_msg
   
			if @@nestlevel = 1
			begin
      rollback tran
						raiserror (@o_error_msg,16,-1)
   end
			
			return -1
go