CREATE DATABASE BD_SHARING_FOOD;

CREATE TABLE Empresa (
	Emp_Id INTEGER AUTO_INCREMENT,
    Emp_Nombre NVARCHAR(20) NOT NULL,
    Emp_Password NVARCHAR(10) NOT NULL,
    Emp_Telefono NVARCHAR(15) NOT NULL,
    Emp_PaginaWeb NVARCHAR(30) NOT NULL,
    Emp_Direccion NVARCHAR(40) NOT NULL,
    CONSTRAINT PK_EMPRESA PRIMARY KEY (Emp_Id),
    CONSTRAINT Emp_Nombre_Emp_PaginaWeb_uq UNIQUE (Emp_Nombre, Emp_PaginaWeb),
    CONSTRAINT Emp_Nombre_Emp_Telefono_uq UNIQUE (Emp_Nombre, Emp_Telefono),    
    CONSTRAINT Emp_Nombre_Emp_Direccion_uq UNIQUE (Emp_Nombre, Emp_Direccion)   
)ENGINE = InnoDB;

CREATE TABLE Publicacion (
	Pub_Id INTEGER AUTO_INCREMENT,
    Pub_Plato NVARCHAR(20) NOT NULL,
    Pub_PrecioOferta FLOAT NOT NULL,
    Pub_PrecioProduccion FLOAT NOT NULL,
    Pub_UnidadesOfertadas INTEGER NOT NULL,
    Pub_UnidadesConsumidas INTEGER NOT NULL DEFAULT 0,
    Emp_Id INTEGER NOT NULL,
    CONSTRAINT PK_PUBLICACION PRIMARY KEY (Pub_Id),
    CONSTRAINT Pub_PrecioOferta_ck CHECK (Pub_PrecioOferta >= 0),
    CONSTRAINT Pub_PrecioProduccion_ck CHECK (Pub_PrecioProduccion >= 0),
    CONSTRAINT Pub_UnidadesOfertadas_ck CHECK (Pub_UnidadesOfertadas > 0),
    CONSTRAINT Pub_Unidades_ck CHECK (Pub_UnidadesConsumidas <= Pub_UnidadesOfertadas),
    CONSTRAINT Pub_FK_Emp FOREIGN KEY (Emp_Id) REFERENCES Empresa (Emp_Id) ON DELETE CASCADE
)ENGINE = InnoDB;
