drop procedure sp_registrar_evento
go

create procedure sp_registrar_evento
@i_evento	int = 0,
@i_nombre varchar(255),
@i_fecha date,
@i_usuario int,
@i_premios as type_premios readonly,
@i_usuario_alta int = 0,   
@o_error_msg varchar(255) = '' output
as

declare	
@f_error_exec smallint

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
-- validaciones
----------------------------------------------------------------------------------------------
if @i_fecha < getdate()
begin
			set @o_error_msg = 'fecha menor a la actual'
			goto error
end

----------------------------------------------------------------------------------------------
-- grabar evento
----------------------------------------------------------------------------------------------
set @i_nombre = upper(@i_nombre)

exec @f_error_exec = sp_grabar_evento
																					@i_evento = @i_evento,				
																					@i_nombre = @i_nombre,
																					@i_fecha = @i_fecha,
																					@i_usuario = @i_usuario,
																					@i_usuario_alta	= @i_usuario_alta,
																					@o_error_msg = @o_error_msg output
if @@error <> 0 
begin
			set @o_error_msg = 'error al ejecutar sp_grabar_evento'
			goto error
end
if @f_error_exec <> 0 goto error  	

----------------------------------------------------------------------------------------------
-- grabar premios
----------------------------------------------------------------------------------------------
if exists (select 1 from  @i_premios)
begin
			exec @f_error_exec = sp_grabar_premios_eventos
																								@i_evento = @i_evento,				
																								@i_premios = @i_premios,
																								@i_usuario_alta	= @i_usuario_alta,
																								@o_error_msg = @o_error_msg output
			if @@error <> 0 
			begin
						set @o_error_msg = 'error al ejecutar sp_grabar_premios_eventos'
						goto error
			end
			if @f_error_exec <> 0 goto error  	
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
   set @o_error_msg = 'sp_registrar_evento = ' + @o_error_msg
   
			if @@nestlevel = 1
			begin
      rollback tran
						raiserror (@o_error_msg,16,-1)
   end
   
			return -1
go