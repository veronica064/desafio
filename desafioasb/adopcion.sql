/*base de datos y las tablas*/

CREATE DATABASE Adopciones;

USE Adopciones;

CREATE TABLE Mascotas (
  id_mascota INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(50),
  especie VARCHAR(30),
  raza VARCHAR(50),
  edad INT,
  estado_salud VARCHAR(50),
  estado_adopcion VARCHAR(20),
  fecha_ingreso DATE
);

CREATE TABLE Adoptantes (
  id_adoptante INT AUTO_INCREMENT PRIMARY KEY,
  nombre_completo VARCHAR(100),
  direccion TEXT,
  telefono VARCHAR(20),
  correo VARCHAR(100)
);

CREATE TABLE Empleados (
  id_empleado INT AUTO_INCREMENT PRIMARY KEY,
  nombre_completo VARCHAR(100),
  cargo VARCHAR(50),
  telefono VARCHAR(20),
  correo VARCHAR(100)
);

CREATE TABLE Adopciones (
  id_adopcion INT AUTO_INCREMENT PRIMARY KEY,
  id_mascota INT,
  id_adoptante INT,
  id_empleado INT,
  fecha_adopcion DATE,
  FOREIGN KEY (id_mascota) REFERENCES Mascotas(id_mascota),
  FOREIGN KEY (id_adoptante) REFERENCES Adoptantes(id_adoptante),
  FOREIGN KEY (id_empleado) REFERENCES Empleados(id_empleado)
);

CREATE TABLE Controles_PostAdopcion (
  id_control INT AUTO_INCREMENT PRIMARY KEY,
  id_adopcion INT,
  fecha_control DATE,
  estado_mascota VARCHAR(100),
  observaciones TEXT,
  seguimiento_exitoso VARCHAR(2),
  FOREIGN KEY (id_adopcion) REFERENCES Adopciones(id_adopcion)
);

INSERT INTO Mascotas (nombre, especie, raza, edad, estado_salud, estado_adopcion, fecha_ingreso)
VALUES 
('Luna', 'Perro', 'Labrador', 3, 'Saludable', 'Disponible', '2024-01-10'),
('Milo', 'Gato', 'Siames', 2, 'Saludable', 'Adoptada', '2024-02-05'),
('Bella', 'Perro', 'Poodle', 4, 'Regular', 'Disponible', '2024-03-15');

/*CONSULTAS SQL*/

SELECT * FROM Mascotas
WHERE estado_adopcion = 'Disponible'
AND especie = 'Perro'
AND edad <= 5
AND estado_salud = 'Saludable';

SELECT A.nombre_completo, M.nombre AS mascota, AD.fecha_adopcion
FROM Adopciones AD
JOIN Adoptantes A ON AD.id_adoptante = A.id_adoptante
JOIN Mascotas M ON AD.id_mascota = M.id_mascota
WHERE A.id_adoptante = 1;

SELECT E.nombre_completo AS empleado, M.nombre AS mascota, C.fecha_control, C.estado_mascota, C.seguimiento_exitoso
FROM Controles_PostAdopcion C
JOIN Adopciones A ON C.id_adopcion = A.id_adopcion
JOIN Empleados E ON A.id_empleado = E.id_empleado
JOIN Mascotas M ON A.id_mascota = M.id_mascota
WHERE E.id_empleado = 1;

/*VISTA DE ADOPCIONES*/

CREATE VIEW Vista_Adopciones AS
SELECT 
  A.nombre_completo AS adoptante,
  M.nombre AS mascota,
  M.especie,
  M.raza,
  M.edad,
  AD.fecha_adopcion
FROM Adopciones AD
JOIN Adoptantes A ON AD.id_adoptante = A.id_adoptante
JOIN Mascotas M ON AD.id_mascota = M.id_mascota;

DELIMITER $$

CREATE PROCEDURE RegistrarAdopcion(
  IN p_id_mascota INT,
  IN p_id_adoptante INT,
  IN p_id_empleado INT,
  IN p_fecha DATE
)
BEGIN
  INSERT INTO Adopciones(id_mascota, id_adoptante, id_empleado, fecha_adopcion)
  VALUES (p_id_mascota, p_id_adoptante, p_id_empleado, p_fecha);

  UPDATE Mascotas
  SET estado_adopcion = 'Adoptada'
  WHERE id_mascota = p_id_mascota;
END $$

DELIMITER ;

