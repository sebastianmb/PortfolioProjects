
/* 
Identificar valores erroneos o sin información

*/

SELECT *
FROM IGAC2024.dbo.R_ZHG_NAL$
WHERE VALOR_HECT ='0';

SELECT *
FROM IGAC2024.dbo.R_ZHG_NAL$
WHERE VALOR_HECT is Null;

SELECT *
FROM IGAC2024.dbo.R_ZHG_NAL$
WHERE OBJECTID = '48218';


-------------------------------------------------------------------
/* 
Eliminar valores erroneos o sin información

*/

DELETE FROM IGAC2024.dbo.R_ZHG_NAL$
WHERE VALOR_HECT IS NULL;

DELETE FROM IGAC2024.dbo.R_ZHG_NAL$
WHERE VALOR_HECT ='';

SELECT *
FROM IGAC2024.dbo.R_ZHG_NAL$

----------------------------------------------------------------------------------------
/* 
Validar coherencia de información
*/


SELECT 
    MIN(V_ha) AS Minimo,
    MAX(V_ha) AS Maximo,
    AVG(V_ha) AS Promedio
FROM IGAC2024.dbo.R_ZHG_NAL$;


---------------------------------------------------------------------------------
/* 
Corregir nombre de mpio y departamentos con otra base de datos
*/

ALTER TABLE IGAC2024.dbo.R_ZHG_NAL$
DROP COLUMN MpNombre, Depto;

SELECT *
FROM IGAC2024.dbo.R_ZHG_NAL$ as R_ZHG_NAL
	JOIN IGAC2024.dbo.Mpio_Codigo_Nombre$ as Mpio_Codigo_Nombre
		on R_ZHG_NAL.codigo_mun = Mpio_Codigo_Nombre.MpCodigo


-------------------------------------------------------------------------

/* Guardar Tabla*/

USE IGAC2024;
GO

CREATE VIEW R_ZHG_NAL_V1 AS
SELECT OBJECTID, CODIGO, CODIGO_ZON, VIGENCIA,codigo_mun,V_ha,ha, MpNombre, Depto,MpArea
FROM R_ZHG_NAL$ AS R_ZHG_NAL
JOIN Mpio_Codigo_Nombre$ AS Mpio_Codigo_Nombre
    ON R_ZHG_NAL.codigo_mun = Mpio_Codigo_Nombre.MpCodigo;

SELECT * FROM IGAC2024.dbo.R_ZHG_NAL_V1;

