DELIMITER //
CREATE PROCEDURE ACTUALIZAR_METADATOS_TABLAS() BEGIN

    -- Se actualizan tablas que corresponden 1 a 1 con el esquema y que aparte tenían una fecha de baja.
    -- Esto quiere decir que ya se habían borrado perviamente pero se volvieron a dar de alta.
    UPDATE tabla INNER JOIN vtablas ON tabla.nombreTabla = vtablas.table_name SET tabla.fechaAlta = NOW(), tabla.fechaBaja = NULL 
    WHERE tabla.fechaBaja IS NOT NULL;

    -- Actualizar tablas que están registradas pero que no les corresponde una tabla en el esquema.
    -- Esto quiere decir que son tablas recientemente borradas.
    -- tabla.numbreTabla   |   vtablas.table_name   (LEFT JOIN)
    --      alumno        ->   alumno
    --      profesor      ->   NULL
    UPDATE tabla LEFT JOIN vtablas ON tabla.nombreTabla = vtablas.table_name
        SET tabla.fechaBaja = NOW()
    WHERE vtablas.table_name IS NULL;

 

    -- Agregar tablas que están en el esquema pero NO en tabla.
    INSERT INTO tabla  (nombreTabla ,descripcion)
		SELECT vtablas.table_name, vtablas.table_comment
        FROM vtablas  LEFT JOIN tabla
        ON vtablas.table_name = tabla.nombreTabla
        WHERE vtablas.table_comment <> "VIEW"
        AND tabla.nombreTabla IS NULL;
    
    
    -- Actualizar num. de filas para todas las tablas
    UPDATE tabla INNER JOIN INFORMATION_SCHEMA.TABLES tbls ON tabla.nombreTabla = tbls.TABLE_NAME 
        SET tabla.filas = tbls.TABLE_ROWS WHERE TABLE_SCHEMA = 'bdivi';
END//
DELIMITER ;