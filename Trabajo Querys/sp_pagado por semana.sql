


alter procedure Reporte_FlujoMVPagadoBien @fechainico varchar(10),@fechafin varchar(10)
as
DECLARE @Semana VARCHAR(4)  
SET  @Semana =(select SemAno from SemanasXAno where FechaInicial=@fechainico and FechaFinal=@fechafin)   

/* FUERA DE FLUJO*/
delete from nuReportCuentas 

insert into nuReportCuentas (LoteFacturaDyA,Referencia,OrdenCompra,FechaFactura,fechaRecepcion,fechaRecepTesoreria,NombreProveedor,ClaveProveedor,FacturaProveedor,Importe,Semana,Tipo,CuryPmtAmt,CuryDiscAmt,Cuenta, CtaDecripcion, LoteFlujo)
SELECT   Lote_PASIVO,Referencia_PASIVO,ORDEN,Fecha,getdate(),getdate(),NombreProveedor,CLAVEPROV,NoFactProv,importe_Pasivo,Semana ,MotivoRet,ImportePago,0,CuentaPago,NombreCta,@Semana
FROM NuReporteFinalMV where CLAVEPROV<>'' AND Fecha between @fechainico and @fechafin
group by Lote_PASIVO,Referencia_PASIVO,ORDEN,Fecha,NombreProveedor,CLAVEPROV,NoFactProv,importe_Pasivo,Semana ,MotivoRet,ImportePago,CuentaPago,NombreCta



update C set 
C.FechaFactura=A.invcdate,
C.fechaRecepcion=A.user7,
C.fechaRecepTesoreria=A.user8
from nuReportCuentas C inner join APDoc A
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
                              from  nuReportCuentas R inner join vendor  V on R.ClaveProveedor=V.vendid





insert into tablatempomv
select distinct * from nuReportCuentas
delete from nuReportCuentas
insert into nuReportCuentas
select * from tablatempomv order by Cuenta,Semana,NombreProveedor
delete from tablatempomv

exec  ColocaImporteaPagarenCuenta




exec Reporte_FlujoMVPagadoBien '2019-06-16 00:00:00','2019-06-22 00:00:00'

select * from SemanasXAno where ano ='2020'

