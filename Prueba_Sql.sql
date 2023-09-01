--A.Relacion Peliculas <=> Tags

--1. Revisa el tipo de relación y crea el modelo correspondiente. Respeta las claves
--primarias, foráneas y tipos de datos.
create table Peliculas(
	id		int				primary key,
	nombre	varchar(255),
	anno	int
);

create table Tags(
	id	int			primary key,
	tag	varchar(32)
);
	--tabla de union:
	create table pelicula_Tags (
	id			serial		primary key,
    pelicula_id int,
    tag_id      int,
    foreign key (pelicula_id) references Peliculas(id),
    foreign key (tag_id) references Tags(id)
);

--2.Insertar 5 películas y 5 tags; la primera película debe tener 3 tags asociados, la
--segunda película debe tener 2 tags asociados.

	--peliculas:
	insert into Peliculas (id, nombre, anno)
values
    (1, 'Jhon Wick', 2023),
    (2, 'Son como niños', 2010),
    (3, 'Dunkerque', 2017),
    (4, 'El viaje de Chihiro', 2001),
    (5, 'The dark crystal', 1982);

	--Tags:
	insert into Tags (id, tag)
values
    (1, 'Acción'),
    (2, 'Comedia'),
    (3, 'Belico'),
    (4, 'Aventura'),
    (5, 'Ciencia ficción');

	--tags asignado:
	insert into pelicula_Tags (pelicula_id, tag_id)
values
    (1, 1), (1, 2), (1, 3),
    (2, 2), (2, 3),
    (3, 3), (3, 4),
    (4, 4), (5, 5);


--3.Cuenta la cantidad de tags que tiene cada película. Si una película no tiene tags debe
--mostrar 0.
select P.id as pelicula_id, P.nombre as nombre_pelicula,
coalesce(count(PT.tag_id), 0) as cantidad_tags
from Peliculas P
left join pelicula_Tags PT on P.id = PT.pelicula_id
group by P.id, P.nombre;


	--siguiente modelo, tablas: Preguntas <=> Respuestas <=> Usuarios.

--4.Crea las tablas correspondientes respetando los nombres, tipos, claves primarias y
--foráneas y tipos de datos.
create table Usuarios (
    id 		int			primary key,
    nombre	VARCHAR(255)
);

create table Preguntas (
    id 				int				primary key,
    pregunta_texto	VARCHAR(255)
);

create table Respuestas (
    id 				int 			primary key,
    respuesta_texto varchar(255),
    pregunta_id 	int,
	usuario_id 		int,
    correcta 		BOOLEAN,
    FOREIGN KEY (pregunta_id) REFERENCES Preguntas(id),
    FOREIGN KEY (usuario_id) REFERENCES Usuarios(id)
);

--5.Agrega 5 usuarios y 5 preguntas:
insert into Usuarios (id, nombre)
values
    (1, 'Carlitos'),
    (2, 'Angelia'),
    (3, 'Susie'),
    (4, 'Didi'),
    (5, 'Betty');

	--a. La primera pregunta debe estar respondida correctamente dos veces, por dos
	--usuarios diferentes.
		insert into Preguntas (id, pregunta_texto)
values (1, '¿En que año publico El Hobbit?');

		insert into Respuestas (id, respuesta_texto, pregunta_id, usuario_id, correcta)
	values
    (1, 'En 1937', 1, 1, true),
    (2, 'En 2023', 1, 2, false),
    (3, 'En 1937', 1, 3, true);

	--b. La segunda pregunta debe estar contestada correctamente solo por uno
	--.
	insert into Preguntas (id, pregunta_texto)
values (2, '¿En que año publico Los gatos de Uthar?');

	insert into Respuestas (id, respuesta_texto, pregunta_id, usuario_id, correcta)
	values
    (4, 'En 1920', 2, 4, true),
    (5, 'En 1940', 2, 5, false);

	--c. Las otras tres preguntas deben tener respuestas incorrectas.
	insert into Preguntas (id, pregunta_texto)
values (3, '¿En que año publico Dagon?');

	insert into Preguntas (id, pregunta_texto)
values (4, '¿En que año publico Carrie?');

	insert into Preguntas (id, pregunta_texto)
values (5, '¿En que año publico The stand?');

	insert into Respuestas (id, respuesta_texto, pregunta_id, usuario_id, correcta)
	values
    (6, 'En el año 1955', 3, 1, false),
    (7, 'En el año 1955', 3, 2, false),
    (8, 'En el año 1955', 4, 3, false),
    (9, 'En el año 1955', 4, 4, false),
    (10, 'En el año 1955', 5, 5, false);

--6.Cuenta la cantidad de respuestas correctas totales por usuario (independiente de la
--pregunta).
select u.id as usuario_id, u.nombre as usuario_nombre, count(r.id) as total_respuestas_correctas
from Usuarios u
left join Respuestas r on u.id = r.usuario_id and r.correcta = true
group by u.id, u.nombre
order by u.id;

--7.Por cada pregunta, en la tabla preguntas, cuenta cuántos usuarios respondieron
--correctamente.
select p.id as pregunta_id, p.pregunta_texto, count(r.id) as usuarios_correctos
from Preguntas p
left join Respuestas r on p.id = r.pregunta_id and r.correcta = true
group by p.id, p.pregunta_texto
order by p.id;

--8.Implementa un borrado en cascada de las respuestas al borrar un usuario. Prueba la
--implementación borrando el primer usuario.
alter table Respuestas
add constraint fk_usuario_respuesta
foreign key (usuario_id) references Usuarios(id) on delete cascade;

delete from Respuestas
where usuario_id = 1;

--9.Crea una restricción que impida insertar usuarios menores de 18 años en la base de
--datos.
alter table Usuarios
add column edad int;

alter table Usuarios
add constraint ck_edad_minima check (edad >= 18);

--10.Altera la tabla existente de usuarios agregando el campo email. Debe tener la
--restricción de ser único.
alter table Usuarios
add column email VARCHAR(255) unique;

