CREATE procedure sp_FactMensuales
    @fechainico varchar(10),
    @fechafin varchar(10)
as
DECLARE @Semana VARCHAR(4)
SET  @Semana =(select SemAno
from SemanasXAno
where FechaInicial=@fechainico and FechaFinal=@fechafin)

/* FUERA DE FLUJO*/
Delete from nuFacturasMensuales

insert into nuFacturasMensuales
    (LoteFacturaDyA,Referencia,OrdenCompra,FechaFactura,fechaRecepcion,fechaRecepTesoreria,NombreProveedor,ClaveProveedor,FacturaProveedor,Importe,Semana,Tipo,CuryPmtAmt,CuryDiscAmt,Cuenta, CtaDecripcion, LoteFlujo)
SELECT Lote_PASIVO, Referencia_PASIVO, ORDEN, Fecha, getdate(), getdate(), NombreProveedor, CLAVEPROV, NoFactProv, importe_Pasivo, Semana , MotivoRet, ImportePago, 0, CuentaPago, NombreCta, @Semana
FROM NuReporteFinalMV
where CLAVEPROV<>'' AND Fecha between @fechainico and @fechafin and CLAVEPROV='PMED0067'
group by Lote_PASIVO,Referencia_PASIVO,ORDEN,Fecha,NombreProveedor,CLAVEPROV,NoFactProv,importe_Pasivo,Semana ,MotivoRet,ImportePago,CuentaPago,NombreCta

update C set 
C.FechaFactura=A.invcdate,
C.fechaRecepcion=A.user7,
C.fechaRecepTesoreria=A.user8
from nuFacturasMensuales C inner join APDoc A
    on A.RefNbr=C.Referencia



UPDATE R SET R.CuryDiscAmt=( case when V.s4future03<>0 then 
                              V.s4future03 
				             else 
				              REPLACE(SUBSTRING(V.s4future02,1,CHARINDEX('%', V.s4future02, 1)),'%','' ) 
				              end),
		                      R.Condicion= ( case when V.s4future03<>0 then 
                              0 
				              else 
				              1
				              end) 
                              from nuFacturasMensuales R inner join vendor  V on R.ClaveProveedor=V.vendid

insert into tablatempomv
select distinct *
from nuFacturasMensuales
delete from nuFacturasMensuales
insert into nuFacturasMensuales
select *
from tablatempomv
order by right(LTRIM(RTRIM(Semana)),2)+left(LTRIM(RTRIM(Semana)),2),NombreProveedor
delete from tablatempomv

--exec  ColocaImporteaPagarenCuenta

select *
from nuFacturasMensuales


exec  sp_FactMensuales '20191210','20200224'

select *
FROM dbo.NuReporteFinalMV
where Semana in ('1120','1220','1320','1420')






