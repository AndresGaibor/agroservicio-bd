-- Eliminar la base de datos si existe

-- use master;
-- GO

-- DROP DATABASE AgroservicioDB;


CREATE DATABASE AgroservicioDB;
GO

use AgroservicioDB;

-- Convencion
-- Para nombre de tablas usar CamelCase
-- Para columnas y variables usar snake_case

--Abreviaciones
--cli=cliente
--prod=producto
--prov=proveedor

CREATE TABLE Cliente(
    id INT IDENTITY(1, 1) PRIMARY KEY,
    ci_cli VARCHAR(10) UNIQUE,
    nombre_cli VARCHAR(50),
    direccion_cli VARCHAR(50),
    telefono_cli VARCHAR(10),
    email_cli VARCHAR(50),
    genero CHAR DEFAULT 'M' CHECK (genero IN ('M', 'F'))
)

-- A esta tabla el usuario no debe poder acceder
CREATE TABLE TiposIva(
    id INT IDENTITY(1, 1) PRIMARY KEY,
    nombre_iva VARCHAR(50),
    valor_iva DECIMAL(10, 2) CHECK (valor_iva >= 0)
)
---------------------
CREATE TABLE Categoria(
    id INT IDENTITY(1, 1) PRIMARY KEY,
    nombre_cat VARCHAR(50) 
);
CREATE TABLE Proveedor(
    id_prov INT IDENTITY(1, 1) PRIMARY KEY,
    ci_prov VARCHAR(10),
    nombre_prov VARCHAR(50),
    direccion_prov VARCHAR(50),
    telefono VARCHAR(10) CHECK (LEN(telefono) = 10 AND telefono NOT LIKE '%[^0-9]%'),
    email VARCHAR(50) CHECK (CHARINDEX('@', email) > 0)
)
CREATE TABLE Producto(
    codigo INT IDENTITY(1, 1) PRIMARY KEY,
    nombre_prod VARCHAR(50) UNIQUE,
    precio DECIMAL(10, 2) DEFAULT 0 CHECK (precio >= 0),
    costo DECIMAL(10, 2) DEFAULT 0 CHECK (costo >= 0),
    stock INT DEFAULT 0 CHECK (stock >= 0),
    imagen_url VARCHAR(100),
    imagen_base64 VARCHAR(MAX),
    id_prov INT FOREIGN KEY REFERENCES Proveedor(id_prov),
    id_categoria INT FOREIGN KEY REFERENCES Categoria(id) DEFAULT 1,
    id_iva INT FOREIGN KEY REFERENCES TiposIva(id) DEFAULT 1,
)

CREATE TABLE FacturaVenta(
    secuencia INT IDENTITY(1, 1) PRIMARY KEY,
    id_cliente INT FOREIGN KEY REFERENCES Cliente(id),
    fecha_emision DATE DEFAULT GETDATE(),
    subtotal DECIMAL(10, 2) CHECK (subtotal >= 0),
    iva DECIMAL(10, 2) CHECK (iva >= 0),
    total DECIMAL(10, 2) CHECK (total >= 0)
)

CREATE TABLE DetalleFacturaVenta(
    codigo_factura INT FOREIGN KEY REFERENCES FacturaVenta(secuencia) ON DELETE CASCADE,
    codigo_producto INT FOREIGN KEY REFERENCES Producto(codigo),
    cantidad INT CHECK (cantidad >= 1),
    precio DECIMAL(10, 2) CHECK (precio >= 0),
    subtotal DECIMAL(10, 2) CHECK (subtotal >= 0),
    iva DECIMAL(10, 2) CHECK (iva >= 0),
    PRIMARY KEY (codigo_factura, codigo_producto)
)



CREATE TABLE FacturaCompra(
    secuencia INT IDENTITY(1, 1) PRIMARY KEY,
    id_proveedor INT FOREIGN KEY REFERENCES Proveedor(id_prov),
    fecha_emision DATE DEFAULT GETDATE(),
    subtotal DECIMAL(10, 2) CHECK (subtotal >= 0),
    iva DECIMAL(10, 2) CHECK (iva >= 0),
    total DECIMAL(10, 2) CHECK (total >= 0)
)

CREATE TABLE DetalleFacturaCompra(
    codigo_factura INT FOREIGN KEY REFERENCES FacturaCompra(secuencia),
    codigo_producto INT FOREIGN KEY REFERENCES Producto(codigo),
    cantidad INT CHECK (cantidad >= 1),
    precio DECIMAL(10, 2) CHECK (precio >= 0),
    subtotal DECIMAL(10, 2) CHECK (subtotal >= 0),
    iva DECIMAL(10, 2) CHECK (iva >= 0),
    PRIMARY KEY (codigo_factura, codigo_producto)
)

CREATE TABLE Usuario (
    id INT IDENTITY(1,1) PRIMARY KEY,
    nombre_usuario VARCHAR(50) NOT NULL UNIQUE,
    clave VARCHAR(20) NOT NULL
)


-- Valores por defecto---------------------------------------------------------------------------------------
INSERT INTO TiposIva (nombre_iva, valor_iva) VALUES ('IVA 12%', 0.12), ('Exento de IVA', 0), ('IVA 14%', 0.14);
INSERT INTO Categoria (nombre_cat) VALUES ('Cereales'), ('Leguminosas'), ('Oleaginosas'), ('Hortalizas'), ('Frutales'), ('Ornamentales'), ('Tubérculos'), ('Medicinales-Aromáticas'), ('Tropicales'), ('Pasto');

INSERT INTO Cliente (ci_cli, nombre_cli, direccion_cli, email_cli, telefono_cli) 
	VALUES ('9999999999', 'CONSUMIDOR FINAL', 'NO DEFINIDA', 'nodefinidio@nodefinido.com', '0999999999'),
        ('0650128846', 'ERICK MALAN', 'RIOBAMBA', 'erickmalan@espoch.edu.ec', '0999999999'),
        ('0604152686', 'FRANKLIN NOBOA', 'RIOBAMBA', 'franklin@espoch.edu.ec', '0999999999');

INSERT INTO Proveedor (ci_prov, nombre_prov, direccion_prov, telefono, email) 
    VALUES ('9999999999', 'Genérico', 'Ecuador', '0999999999', 'generico@hotmail.com');

INSERT INTO Usuario(nombre_usuario, clave) 
	VALUES ('admin', 'admin'), ('vendedor', '123'), ('erick', '1234'), ('kevin','1234'), ('josue', '1234'),  ('andres', '1234'), ('franklin', '1234'), ('alex', '1234');

GO
--VISTAS

--VISTA DE PRODUCTOS
CREATE VIEW VistaProductos AS
SELECT P.codigo AS Codigo, P.nombre_prod AS Nombre, P.precio AS Precio, P.costo AS Costo, P.stock AS Stock, C.nombre_cat AS Categoria, PR.nombre_prov AS Proveedor, T.nombre_iva AS IVA
FROM Producto P JOIN Categoria C ON P.id_categoria = C.id
JOIN Proveedor PR ON P.id_prov = PR.id_prov
JOIN TiposIva T ON P.id_iva = T.id
GO

--VISTA DE CLIENTES
CREATE VIEW VistaClientes AS 
SELECT id AS Codigo, ci_cli AS Cedula, nombre_cli AS Nombre, direccion_cli AS Direccion, telefono_cli AS Telefono, email_cli AS Email, genero AS Genero
FROM Cliente 
GO

--VISTA DE PROVEEDORES
CREATE VIEW VistaProveedores AS
SELECT id_prov AS Codigo, ci_prov AS Cedula, nombre_prov AS Nombre, direccion_prov AS Direccion, telefono AS Telefono, email AS Email
FROM Proveedor
GO

--VISTA DE FACTURAS DE VENTA
CREATE VIEW VistaFacturasVenta AS
SELECT F.secuencia AS Secuencia, C.nombre_cli AS Cliente, F.fecha_emision AS Fecha, F.subtotal AS Subtotal, F.iva AS IVA, F.total AS Total
FROM FacturaVenta F JOIN Cliente C ON F.id_cliente = C.id
GO

--VISTA DE FACTURAS POR CLIENTE
CREATE VIEW VistaFacturasCliente AS
SELECT F.secuencia AS NumFac, C.nombre_cli AS [Nombre Cliente], F.fecha_emision AS [Fecha Emision], F.subtotal AS Subtotal, F.iva AS IVA, F.total AS Total
FROM FacturaVenta F JOIN Cliente C ON F.id_cliente = C.id
WHERE C.nombre_cli = 'CONSUMIDOR FINAL' --Cambia el nombre del cliente según se necesite
GO

CREATE PROCEDURE sp_ActualizarVistaFacturasPorCliente(@nombreCliente NVARCHAR(255))
AS
BEGIN
    DECLARE @sqlQuery NVARCHAR(MAX)

    SET @sqlQuery = '
        CREATE OR ALTER VIEW VistaFacturasCliente AS
        SELECT F.secuencia AS Secuencia, C.nombre_cli AS Cliente, F.fecha_emision AS Fecha, F.subtotal AS Subtotal, F.iva AS IVA, F.total AS Total
        FROM FacturaVenta F JOIN Cliente C ON F.id_cliente = C.id
        WHERE C.nombre_cli = ''' + @nombreCliente + ''';'

    EXEC sp_executesql @sqlQuery
END;
GO

--Vista Facturas En una Fecha
CREATE VIEW VistaFacturasEnFecha AS
SELECT F.secuencia AS NumFac, C.nombre_cli AS [Nombre Cliente], F.fecha_emision AS [Fecha Emision], F.subtotal AS Subtotal, F.iva AS IVA, F.total AS Total
FROM FacturaVenta F JOIN Cliente C ON F.id_cliente = C.id
WHERE F.fecha_emision = '2024-01-10' --Cambia la fecha según se necesite
GO

CREATE PROCEDURE sp_ActualizarVistaFacturasEnFecha(@fecha DATE)
AS
BEGIN
    DECLARE @sqlQuery NVARCHAR(MAX)

    SET @sqlQuery = '
        CREATE OR ALTER VIEW VistaFacturasEnFecha AS
        SELECT F.secuencia AS NumFac, C.nombre_cli AS [Nombre Cliente], F.fecha_emision AS [Fecha Emision], F.subtotal AS Subtotal, F.iva AS IVA, F.total AS Total
        FROM FacturaVenta F JOIN Cliente C ON F.id_cliente = C.id
        WHERE F.fecha_emision = ''''' + CONVERT(NVARCHAR, @fecha, 120) + ''''''';'

    EXEC sp_executesql @sqlQuery
END;
GO

