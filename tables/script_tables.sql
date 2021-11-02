
--create database tickets


----------------------------------------------------------------------------------------------------------------------------
-- usuarios
----------------------------------------------------------------------------------------------------------------------------
--drop table usuarios
--go
--create table usuarios (
--usuario int not null,

--fecha_proceso date not null,
--fecha_proceso_hasta date not null,
--secuencia smallint not null,
--indicador char(1) not null,

--nombre_usuario varchar(255),
--correo varchar(255),
--clave varchar(255),

--usuario_alta int,
--fecha_alta datetime,
--usuario_baja int,
--fecha_baja datetime,

--constraint pk_usuarios primary key (usuario, fecha_proceso, fecha_proceso_hasta, secuencia, indicador)
--)

----------------------------------------------------------------------------------------------------------------------------
-- eventos
----------------------------------------------------------------------------------------------------------------------------
--drop table eventos
--go
--create table eventos (
--evento int not null,

--fecha_proceso date not null,
--fecha_proceso_hasta date not null,
--secuencia smallint not null,
--indicador char(1) not null,

--nombre varchar(255),
--fecha date,
--usuario int,

--usuario_alta int,
--fecha_alta datetime,
--usuario_baja int,
--fecha_baja datetime,

--constraint pk_eventos primary key (evento, fecha_proceso, fecha_proceso_hasta, secuencia, indicador)
--)

----------------------------------------------------------------------------------------------------------------------------
-- premios de los eventos
----------------------------------------------------------------------------------------------------------------------------
--drop table premios_eventos
--go
--create table premios_eventos (
--evento int not null,
--orden smallint not null,

--fecha_proceso date not null,
--fecha_proceso_hasta date not null,
--secuencia smallint not null,
--indicador char(1) not null,

--nombre varchar(255),

--usuario_alta int,
--fecha_alta datetime,
--usuario_baja int,
--fecha_baja datetime,

--constraint pk_premios_eventos primary key (evento, orden, fecha_proceso, fecha_proceso_hasta, secuencia, indicador)
--)

----------------------------------------------------------------------------------------------------------------------------
-- tickets
----------------------------------------------------------------------------------------------------------------------------
--drop table tickets
--go
--create table tickets (
--ticket int not null,

--fecha_proceso date not null,
--fecha_proceso_hasta date not null,
--secuencia smallint not null,
--indicador char(1) not null,

--numero int,
--nombre varchar(255),
--telefono varchar(255),
--evento int,

--usuario_alta int,
--fecha_alta datetime,
--usuario_baja int,
--fecha_baja datetime,

--constraint pk_tickets primary key (ticket, fecha_proceso, fecha_proceso_hasta, secuencia, indicador)
--)




