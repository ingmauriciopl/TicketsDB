



----------------------------------------------------------------------------------------------
-- usuarios
------------------------------------------------------------------------------------------------
--exec sp_grabar_usuario
--@i_usuario = 2,
--@i_nombre_usuario = 'marco',
--@i_correo = 'carlos@gmail.com',
--@i_clave = '123456',
--@i_usuario_alta = 1  


select*
from usuarios
where indicador = 'A' and fecha_proceso_hasta = '31/12/9999'
order by fecha_alta desc




exec sp_login
@i_nombre_usuario = 'marco',  
@i_clave = '123456'



----------------------------------------------------------------------------------------------
-- eventos
----------------------------------------------------------------------------------------------

--declare 
--@i_premios as type_premios

--insert into @i_premios
--select 'auto suzuki alto 2030' union
--select 'moto honda navi 2030' union
--select 'bicileta venzo 2030' 


--exec sp_registrar_evento
--@i_evento = 6,
--@i_nombre = 'kermesse por vinchita',
--@i_fecha = '30/09/2021',
--@i_usuario = 1,
--@i_premios = @i_premios,
--@i_usuario_alta = 1  


select*
from eventos
order by fecha_alta desc


select*
from premios_eventos
order by fecha_alta desc


select*
from eventos
where indicador = 'A' and fecha_proceso_hasta = '31/12/9999'
order by fecha_alta desc



exec sp_obtener_eventos
@i_usuario = 1



exec sp_obtener_evento
@i_evento = 6



----------------------------------------------------------------------------------------------
-- tickets
----------------------------------------------------------------------------------------------
--exec sp_registrar_tickets
--@i_nombre = 'carlos peñaranda',
--@i_telefono = '72609832',
--@i_evento = 6,
--@i_cantidad = 9,
--@i_usuario_alta = 1   




select*
from tickets
where indicador = 'A' and fecha_proceso_hasta = '31/12/9999'
order by fecha_alta desc

select*
from tickets
order by fecha_alta desc




select*
from tickets
where evento = 6
and indicador = 'A' and fecha_proceso_hasta = '31/12/9999'
order by fecha_alta desc


exec sp_obtener_tickets
@i_evento = 5



