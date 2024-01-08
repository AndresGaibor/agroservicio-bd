-- Eliminar la base de datos si existe

-- use master;
-- DROP DATABASE AgroservicioDB;
-- MICROSOFT SQL SERVER

CREATE DATABASE AgroservicioDB;

use AgroservicioDB;

-- Convencion
-- Para nombre de tablas usar CamelCase
-- Para columnas y variables usar snake_case

CREATE TABLE Cliente(
    id INT IDENTITY(1, 1) PRIMARY KEY,
    ci VARCHAR(10) UNIQUE,
    nombre VARCHAR(50),
    direccion VARCHAR(50),
    telefono VARCHAR(10),
    email VARCHAR(50)
)

-- A esta tabla el usuario no debe poder acceder
CREATE TABLE TiposIva(
    id INT IDENTITY(1, 1) PRIMARY KEY,
    nombre VARCHAR(50),
    valor DECIMAL(10, 2)
)

CREATE TABLE Categoria(
    id INT IDENTITY(1, 1) PRIMARY KEY,
    nombre VARCHAR(50)
);

CREATE TABLE Producto(
    codigo INT IDENTITY(1, 1) PRIMARY KEY,
    nombre VARCHAR(50) UNIQUE,
    precio DECIMAL(10, 2) DEFAULT 0,
    stock INT DEFAULT 0,
    id_categoria INT FOREIGN KEY REFERENCES Categoria(id) DEFAULT 1,
    id_iva INT FOREIGN KEY REFERENCES TiposIva(id) DEFAULT 1,
)

CREATE TABLE FacturaVenta(
    secuencia INT IDENTITY(1, 1) PRIMARY KEY,
    id_cliente INT FOREIGN KEY REFERENCES Cliente(id),
    fecha_emision DATE,
    subtotal DECIMAL(10, 2),
    iva DECIMAL(10, 2),
    total DECIMAL(10, 2)
)

CREATE TABLE DetalleFacturaVenta(
    codigo_factura INT FOREIGN KEY REFERENCES FacturaVenta(secuencia),
    codigo_producto INT FOREIGN KEY REFERENCES Producto(codigo),
    cantidad INT,
    precio DECIMAL(10, 2),
    subtotal DECIMAL(10, 2),
    PRIMARY KEY (codigo_factura, codigo_producto)
)

CREATE TABLE Proveedor(
    id INT IDENTITY(1, 1) PRIMARY KEY,
    ci VARCHAR(10),
    nombre VARCHAR(50),
    direccion VARCHAR(50),
    telefono VARCHAR(10),
    email VARCHAR(50)
)

CREATE TABLE FacturaCompra(
    secuencia INT IDENTITY(1, 1) PRIMARY KEY,
    id_proveedor INT FOREIGN KEY REFERENCES Proveedor(id),
    fecha_emision DATE,
    subtotal DECIMAL(10, 2),
    iva DECIMAL(10, 2),
    total DECIMAL(10, 2)
)

CREATE TABLE DetalleFacturaCompra(
    codigo_factura INT FOREIGN KEY REFERENCES FacturaCompra(secuencia),
    codigo_producto INT FOREIGN KEY REFERENCES Producto(codigo),
    cantidad INT,
    precio DECIMAL(10, 2),
    subtotal DECIMAL(10, 2),
    PRIMARY KEY (codigo_factura, codigo_producto)
)

CREATE TABLE Ingrediente(
    id INT IDENTITY(1, 1) PRIMARY KEY,
    nombre VARCHAR(50),
)

CREATE TABLE ProductoIngrediente(
    codigo_producto INT FOREIGN KEY REFERENCES Producto(codigo),
    id_ingrediente INT FOREIGN KEY REFERENCES Ingrediente(id),
    PRIMARY KEY (codigo_producto, id_ingrediente)
)

CREATE TABLE Cultivo(
    id INT IDENTITY(1, 1) PRIMARY KEY,
    nombre VARCHAR(50)
)

CREATE TABLE Plaga(
    id INT IDENTITY(1, 1) PRIMARY KEY,
    nombre VARCHAR(50)
)

CREATE TABLE CultivoPlaga(
    id_cultivo INT FOREIGN KEY REFERENCES Cultivo(id),
    id_plaga INT FOREIGN KEY REFERENCES Plaga(id),
    PRIMARY KEY (id_cultivo, id_plaga)
)

CREATE TABLE Tratamiento(
    id_plaga INT FOREIGN KEY REFERENCES Plaga(id),
    id_producto INT FOREIGN KEY REFERENCES Producto(codigo),
    PRIMARY KEY (id_plaga, id_producto)
)
-- Valor por defecto
INSERT INTO TiposIva (nombre, valor) VALUES ('IVA 12%', 0.12), ('Exento de IVA', 0);
INSERT INTO Categoria (nombre) VALUES ('GENERAL', 'HERBICIDA', 'FUNGICIDA', 'INSECTICIDA', 'FERTILIZANTE');
INSERT INTO Cliente (ci, nombre, direccion, telefono, email) VALUES ('9999999999', 'CONSUMIDOR FINAL', 'NO DEFINIDA', 'NO DEFINIDA');