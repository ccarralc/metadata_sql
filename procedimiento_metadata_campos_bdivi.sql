DELIMITER //
CREATE PROCEDURE ACTUALIZAR_METADATOS_CAMPOS() BEGIN

    -- Se actualizan campos que corresponden 1 a 1 con el esquema y que aparte tenían una fecha de baja.
    -- Esto quiere decir que ya se habían borrado perviamente pero se volvieron a dar de alta.
    UPDATE campo INNER JOIN 
        (SELECT idTabla, nombreTabla , Columna AS nombreCampo 
            FROM vesquema INNER JOIN tabla 
            ON vesquema.Tabla = tabla.nombreTabla) AS join_tablas_esquema
        ON campo.nombreCampo = join_tablas_esquema.nombreCampo AND 
        campo.idTabla = join_tablas_esquema.idTabla

    SET campo.fechaAlta = NOW(), campo.fechaBaja = NULL
    WHERE campo.fechaBaja IS NOT NULL;

    -- Actualizar campos que están registrados pero que no les corresponde una campo en el esquema.
    -- Esto quiere decir que son campos recientemente borrados.
    -- campo.numbreCampo     |   join_tablas_esquema.nombreCampo (LEFT JOIN)
    -- idAcervoBiblioGrafico ->   idAcervoBibliografico 
    -- idDocente             ->   NULL
    UPDATE campo LEFT JOIN 
        (SELECT idTabla, nombreTabla , Columna AS nombreCampo 
            FROM vesquema INNER JOIN tabla 
            ON vesquema.Tabla = tabla.nombreTabla) AS join_tablas_esquema
        ON campo.nombreCampo = join_tablas_esquema.nombreCampo AND 
        campo.idTabla = join_tablas_esquema.idTabla

    SET campo.fechaBaja = NOW()
    WHERE join_tablas_esquema.nombreCampo IS NULL;

    -- Agregar campos que están en el esquema pero NO en campo.
    INSERT INTO campo (idTabla, nombreCampo, descripcion)
        SELECT join_tablas_esquema.idTabla,
               join_tablas_esquema.nombreCampo,
               join_tablas_esquema.Descripcion
        FROM 
        (SELECT idTabla, Columna AS nombreCampo, vesquema.Descripcion as Descripcion
            FROM vesquema INNER JOIN tabla 
            ON vesquema.Tabla = tabla.nombreTabla) AS join_tablas_esquema
        LEFT JOIN campo 
        ON campo.nombreCampo = join_tablas_esquema.nombreCampo AND 
        campo.idTabla = join_tablas_esquema.idTabla
        WHERE campo.nombreCampo IS NULL;

END //
DELIMITER ;