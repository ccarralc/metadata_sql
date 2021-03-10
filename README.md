# Procedimientos para manejo y actualización de metadatos en las bases de datos del SIVI

Los siguientes procedimientos tienen como objetivo:

* Identificar tablas/campos que habían sido borrados y después añadidos nuevamente.
* Identificar tablas/campos que han sido borrados definitivamente.
* Identificar tablas/campos que han sido añadidos a la BD.


## TODO

* Eliminar los campos que no se pueden determinar a través del procedimiento
    (es decir, que se tienen que actualizar manualmente) o alternativamente, 
    definir los valores por defecto para los siguientes campos:
    * idApartadoAE
    * idUsuarioAlta
    * fechaUltMod
    * idUsuUltMod
* Determinar un método para realizar pruebas unitarias a los procedimientos.
    Framework propuesto: MyTap.