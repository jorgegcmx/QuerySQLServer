DECLARE @proyecto VARCHAR(20)
DECLARE @almacen VARCHAR(20)
DECLARE @inicio smalldatetime
DECLARE @fin smalldatetime
DECLARE cursor_costos CURSOR FOR 

SELECT DISTINCT ProyectoVigente, AlmacenCASETA, Crtd_DateTime, FechaCierreCAS
FROM NuPeContCasHdr (NOLOCK)
where Status = 'CC'
    AND FechaCierreCAS BETWEEN '20200201' AND '20200229'
    AND Crtd_DateTime<>'1900-01-01 00:00:00'
    AND FechaCierreCAS <>'1900-01-01 00:00:00'


OPEN cursor_costos
FETCH NEXT FROM cursor_costos
INTO  @proyecto,@almacen,@inicio,@fin

WHILE @@FETCH_STATUS = 0  
BEGIN
   
    exec dbo.sp_agristast_caseta_cerradas_mes @inicio, @fin, @almacen

    FETCH NEXT FROM cursor_costos
INTO @proyecto,@almacen,@inicio,@fin
END
CLOSE cursor_costos;
DEALLOCATE cursor_costos;

select Codigo, AlmacenCASETA, Ano, Ciclo, Sexo, Articulo, Concepto, Cantidad, Importe, Edad
from RepAGRISTATS
order by AlmacenCASETA
/*select a la tabla*/
select *
from RepAGRISTATS 

