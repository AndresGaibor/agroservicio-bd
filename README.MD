# Pasos para ejecutar la base de datos en docker

Descargar docker para windows en el siguiente enlace [docker-desktop](https://docs.docker.com/docker-for-windows/install/)

En powershell ejecutar el siguiente comando para crear la imagen de la base de datos

```bash
docker run -e ‘ACCEPT_EULA=Y’ -e ‘MSSQL_SA_PASSWORD=Apl1c@cionesInformat1c@’ -p 1444:1433 --name sql1 --hostname sql1 -d mcr.microsoft.com/mssql/server:2022-latest
```
Si no funciona intentar la siguiente imagen
    
```bash
docker run -e "ACCEPT_EULA=1" -e "MSSQL_SA_PASSWORD=Apl1c@cionesInformat1c@" -e "MSSQL_PID=Developer" --hostname sql1 -e "MSSQL_USER=SA" -p 1444:1433 -d --name=sql1 mcr.microsoft.com/azure-sql-edge
```


Para parar el contenedor ejecutar el siguiente comando

```bash
docker stop sql1
```

Para eliminar el contenedor ejecutar el siguiente comando

```bash
docker rm sql1
```

## Conectarse a la base de datos desde Visual Studio Code
Instalar las extensiones SQL Server (mssql)

En la barra ir SQL Server > Agragar conexión (+)

Pegar el siguiente string de conexión

```bash
Server=localhost,1444;Database=master;User Id=sa;Password=Apl1c@cionesInformat1c@;
```

Poner un nombre al perfil ej "docker-agro"

Aceptar "Enable trust server certificate"

Ejecutar el archivo creacion.sql