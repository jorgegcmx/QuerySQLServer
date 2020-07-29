

CREATE procedure Reporte_Flujo2Bien @LoteFlujo varchar(10),@SemanaPagoTeso varchar(4)
as
--------------------------------------------
--Insertamos Datos de Lote de Flujo
--------------------------------------------			

insert into nuReportCuentas (LoteFacturaDyA,Referencia,OrdenCompra,FechaFactura,fechaRecepcion,fechaRecepTesoreria,NombreProveedor,ClaveProveedor,FacturaProveedor,Importe,Semana,Tipo,CuryPmtAmt,CuryDiscAmt,Cuenta, CtaDecripcion, LoteFlujo)
SELECT   Lote_PASIVO,Referencia_PASIVO,ORDEN,getdate(),getdate(),getdate(),NombreProveedor,CLAVEPROV,NoFactProv,importe_Pasivo,Semana ,MotivoRet,APCheckDet.CuryPmtAmt,0,CuentaPago,NombreCta,@LoteFlujo
FROM NuReporteFinalMV inner join APCheckDet on APCheckDet.RefNbr=NuReporteFinalMV.Referencia_PASIVO
where CLAVEPROV<>'' and APCheckDet.BatNbr=@LoteFlujo
group by Lote_PASIVO,Referencia_PASIVO,ORDEN,NombreProveedor,CLAVEPROV,NoFactProv,importe_Pasivo,Semana ,MotivoRet,APCheckDet.CuryPmtAmt,CuentaPago,NombreCta

UPDATE RC SET RC.Cuenta=Acct  from APCheck AP 
                          inner join  nuReportCuentas RC
                          on RC.LoteFlujo=AP.BatNbr

update RC set  RC.CtaDecripcion=A.Descr  
From nuReportCuentas RC						
                left outer join Account  A
				on A.Acct=RC.Cuenta 

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
select * from tablatempomv order by Semana,NombreProveedor
delete from tablatempomv

--select *  from nuReportCuentas

