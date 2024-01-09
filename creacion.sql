-- Eliminar la base de datos si existe

--use master;
--GO

--DROP DATABASE AgroservicioDB;


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
    telefono_cli VARCHAR(10) CHECK (LEN(telefono_cli) = 10 AND telefono_cli NOT LIKE '%[^0-9]%'),
    email_cli VARCHAR(50) CHECK (CHARINDEX('@', email_cli) > 0),
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

CREATE TABLE Producto(
    codigo INT IDENTITY(1, 1) PRIMARY KEY,
    nombre_prod VARCHAR(50) UNIQUE,
    precio DECIMAL(10, 2) DEFAULT 0 CHECK (precio >= 0),
    costo DECIMAL(10, 2) DEFAULT 0 CHECK (costo >= 0),
    stock INT DEFAULT 0 CHECK (stock >= 0),
    imagen_url VARCHAR(100),
    imagen_base64 VARCHAR(MAX),
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
    codigo_factura INT FOREIGN KEY REFERENCES FacturaVenta(secuencia),
    codigo_producto INT FOREIGN KEY REFERENCES Producto(codigo),
    cantidad INT CHECK (cantidad >= 1),
    precio DECIMAL(10, 2) CHECK (precio >= 0),
    subtotal DECIMAL(10, 2) CHECK (subtotal >= 0),
    iva DECIMAL(10, 2) CHECK (iva >= 0),
    PRIMARY KEY (codigo_factura, codigo_producto)
)

CREATE TABLE Proveedor(
    id_prov INT IDENTITY(1, 1) PRIMARY KEY,
    ci_prov VARCHAR(10),
    nombre_prov VARCHAR(50),
    direccion_prov VARCHAR(50),
    telefono VARCHAR(10) CHECK (LEN(telefono) = 10 AND telefono NOT LIKE '%[^0-9]%'),
    email VARCHAR(50) CHECK (CHARINDEX('@', email) > 0)
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
INSERT INTO Producto (nombre_prod, costo, precio, stock, id_categoria, imagen_url) 
VALUES 
        ('KILLER LT', 3, 5, 40, 2, 'https://www.afecor.com/wp-content/uploads/2021/06/killer-1-litro.png'),
        ('ATRADEL KG', 6, 7, 100, 2, 'https://delmonteag.com.ec/wp-content/uploads/2021/10/ATRADEL-ENVASE.jpg'),
        ('JISAFOL FOSFITO POTASIO LT', 4, 9, 20, 4, 'https://delmonteag.com.ec/wp-content/uploads/2021/10/JISAFOL-ENVASE.jpg'),
        ('PELION LT', 35, 42, 10, 2, 'https://delmonteag.com.ec/wp-content/uploads/2021/10/PELION-ENVASE.jpg'),
        ('KBH LT', 8, 15, 10, 4, 'https://www.afecor.com/wp-content/uploads/2022/09/KBH50-GRANDE-.png'),
        ('MENOREL ENGROSE KG', 8, 15, 10, 4, 'https://delmonteag.com.ec/wp-content/uploads/2021/10/MENOREL-ENGROSE-ENVASE.jpg'),
        ('HERVAX LT', 4, 5, 50, 2, 'https://delmonteag.com.ec/wp-content/uploads/2021/10/HERVAX-INMONTE-ENVASE.jpg');


INSERT INTO Cliente (ci_cli, nombre_cli, direccion_cli, email_cli) 
	VALUES ('9999999999', 'CONSUMIDOR FINAL', 'NO DEFINIDA', 'nodefinidio@nodefinido.com'),
        ('0650128846', 'ERICK MALAN', 'RIOBAMBA', 'erickmalan@espoch.edu.ec'),
        ('0604152686', 'FRANKLIN NOBOA', 'RIOBAMBA', 'franklin@espoch.edu.ec');

INSERT INTO Usuario(nombre_usuario, clave) 
	VALUES ('admin', 'admin'), ('vendedor', '123'), ('erick', '1234'), ('kevin','1234'), ('josue', '1234'),  ('andres', '1234'), ('franklin', '1234'), ('alex', '1234');
