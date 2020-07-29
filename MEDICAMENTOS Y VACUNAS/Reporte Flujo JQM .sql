
CREATE PROCEDURE FlujoMVBien @semana1 varchar(4)
as

--exec SP_MVFinal @semana1
Delete from nuflujoMV

insert into nuflujoMV( Semana, Proveedor,  NombreProveedor,  OrdenCompra,  ImporteEnorden, tipo, REC_APRefNo, ImporteFacturas,  FacturaProv,    Monto,  LoteCheque, MontoFueraFlujo,  Cuenta,  Descrp,  FechaConsi,  SemanaPago, Descuento,Saldo)
SELECT   Semana,CLAVEPROV,NombreProveedor,ORDEN,ImpoteDOC,MotivoRet,Referencia_PASIVO,importe_Pasivo,NoFactProv,ImportePago,Lote_cheque,0,CuentaPago,NombreCta,Fecha,SemanaPago,ImpoteCXP,SaldoEnPasivo
FROM NuReporteFinalMV where CLAVEPROV<>'' AND Semana= @semana1
group by Semana,CLAVEPROV,NombreProveedor,ORDEN,ImpoteDOC,MotivoRet,Referencia_PASIVO,importe_Pasivo,NoFactProv,ImportePago,Lote_cheque,CuentaPago,NombreCta,Fecha,SemanaPago,ImpoteCXP,SaldoEnPasivo

/*declare @repetido  float

set @repetido =(SELECT top 1 ImporteEnorden FROM nuflujoMV where OrdenCompra 
in(SELECT OrdenCompra FROM nuflujoMV 
     GROUP BY OrdenCompra
     HAVING COUNT(*)>1))*/



/*	 SELECT count(OrdenCompra) FROM nuflujoMV 
     GROUP BY OrdenCompra
     HAVING COUNT(*)>1*/
/*
create view soloOrdenesdistintas as
select OrdenCompra,R.ImporteTotalAuto,R.ImporteEnorden,R.Semana,R.tipo 
       from nuflujoMV R 
       group by OrdenCompra,R.ImporteTotalAuto,R.ImporteEnorden,R.Semana,R.tipo 
	   */

--Vista para organizar los totales por tipo y semanas
/*create View ImportesTotalesBien as
select SUM(R.ImporteTotalAuto)as ImporteAuto, SUM(R.ImporteEnorden) as ImporteOrden,R.Semana,R.tipo 
       from soloOrdenesdistintas R 
       group by tipo,R.Semana*/

update R set R.TotalOrdenado   =I.ImporteOrden -- @repetido
             from nuflujoMV R join ImportesTotalesBien I on R.Semana=I.Semana and R.tipo=I.tipo

update R set R.TotalAutorizado =I.TotalAutorizado
--select R.TotalAutorizado,I.TotalAutorizado  
from nuflujoMV R join totalesAutoMV I on R.Semana=I.Semana 
where tipo='PRPE'

update R set R.TotalAutorizado =I.TotalExtra
--select R.TotalAutorizado,I.TotalAutorizado  
from nuflujoMV R join totalesAutoMV I on R.Semana=I.Semana 
where tipo='EXPE'

update R set R.TotalAutorizado =I.TotalProve
--select R.TotalAutorizado,I.TotalAutorizado  
from nuflujoMV R join totalesAutoMV I on R.Semana=I.Semana 
where tipo='MSPE'

update R set R.TotalAutorizado =I.TotalReorden
--select R.TotalAutorizado,I.TotalAutorizado  
from nuflujoMV R join totalesAutoMV I on R.Semana=I.Semana 
where tipo='REORDEN'



--------------------------------------------------------------------------------------------------------
--SACAMOS EL CALCULO DE LOS DESCUENTOS DE LOS PROVEEDORES PARA COMPARAR CON EL SALDO--------------------
--------------------------------------------------------------------------------------------------------
UPDATE R SET 
            PorcenDescuento=( case when V.s4future03<>0 
            then V.s4future03 
			else  REPLACE(SUBSTRING(V.s4future02,1,CHARINDEX('%', V.s4future02, 1)),'%','' ) 
			end) ,
			tipodescuento=( case when V.s4future03<>0 
            then 1 
			else 0 
			end),
			R.Moneda= V.curyid				    
            from  nuflujoMV R inner join vendor  V on R.Proveedor=V.vendid


-------------------------------------------------------------------------------------------------------------------
-------------------------RESUMEN PARA REPORTE----------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------
/*alter view ResumenImportefacturas as
select distinct  Semana,
                 TotalAutorizado,
				 TotalOrdenado,
				 ImporteFacturas,
				 Saldo,
				 tipo,
				 REC_APRefNo,
				 Monto,
				 MontoFueraFlujo,
				 Cuenta,
				 Descrp,
				 SemanaPago,
				 FechaConsi,
				 TotalGeneralAuto,
				 TotalGeneralOrd,
				 TotalGeneralMXN,
				 Descuento
                 FROM nuflujoMV */

/*alter view ResumDetalle as
select Semana,
       sum(ImporteFacturas)as ImporteFacturas,	  
	   sum(Monto + MontoFueraFlujo) as PagadoEnFlujo,
	   --sum(MontoFueraFlujo) as PagoFueraDeFlujo,
	   --sum(Saldo) as Saldo,
	   SemanaPago,	   
	   --FechaConsi,
	   TotalGeneralAuto,
	   --TotalGeneralOrd,
	   TotalGeneralMXN,
	   Descrp,
	   sum(Descuento) as Descuento
	   from ResumenImportefacturas
                                  group by 
								  Semana,													 
								  SemanaPago,
								 -- FechaConsi,
								  TotalGeneralAuto,
								 -- TotalGeneralOrd,
								  TotalGeneralMXN,
								  Descrp
								  */

/*alter view DetalleFueraPresupuesto as
select tipo,
       REC_APRefNo,
	   NombreProveedor,
	   FacturaProveedor, 
       ImporteFacturas,
	  (Case  when Descuento is null then 0 else Descuento end ) as Descuento,
	   FechaRecepcion,
	   OrdenCompra
              from nuflujoMV
	                  where tipo in('EXPE','MSPE','REORDEN') and REC_APRefNo   IS NOT NULL */




/*create view ImportesFacturados as
select distinct tipo,REC_APRefNo,ImporteFacturas 
                                 from nuflujoMV 
create view facturados as
select tipo,SUM(ImporteFacturas)as Importes 
                                   from ImportesFacturados 
								   group by tipo*/

update R set R.TotalFacturado=Importes 
from nuflujoMV R inner join facturados f on f.tipo=R.tipo

--vista Pagos y Descuentos--
/*alter view PagosyDescuentosTipo as 
 select distinct tipo,
                 REC_APRefNo,
				 ImporteFacturas,
                ( Monto + MontoFueraFlujo) as Pagado,
				 PorcenDescuento,
				 tipodescuento,
				 Descuento,
				 FechaConsi 
  from nuflujoMV where FechaConsi is not null
create view PagadoyConsiliado as
select tipo,SUM(Pagado) as Pagado from PagosyDescuentosTipo group by tipo */

update R set R.PagadoxTipo=PC.Pagado 
from nuflujoMV R inner join PagadoyConsiliado PC on PC.tipo=R.tipo



/*CREATE VIEW DescuentoTipo as
 select distinct tipo,
                 REC_APRefNo,
				 ImporteFacturas,
                ( Monto + MontoFueraFlujo) as Pagado,
				 PorcenDescuento,
				 tipodescuento,
				 Descuento,
				 FechaConsi 
                 from nuflujoMV where tipodescuento=1 AND FechaConsi is not null
create view DesTipo as
select tipo,SUM(Descuento) as ImporteDescuento from DescuentoTipo group by tipo */

/*alter view DescuentoMSPE
as
select distinct tipo,LineType,REC_APRefNo,(tranamt*-1)as importe
from nuflujoMV R inner join APTran A on A.RefNbr=R.REC_APRefNo 
where LineType='N' and tipo='MSPE' 

create view DesfinalMSPE as
select LineType,tipo,SUM(importe)as descuentoMSPE 
from  DescuentoMSPE group by LineType,tipo*/


update R set R.DescuentoxTipo=D.descuentoMSPE
from nuflujoMV R inner join DesfinalMSPE D on D.tipo=R.tipo


update R set R.DescuentoxTipo=PC.ImporteDescuento 
from nuflujoMV R inner join DesTipo PC on PC.tipo=R.tipo

update R set R.PagadoxTipo=0  
from nuflujoMV R where PagadoxTipo is null 

update R set R.DescuentoxTipo=0 
from nuflujoMV R where  R.DescuentoxTipo is null


update R set R.TotalGeneralAuto =Aut, R.TotalGeneralOrd=Ord
             from nuflujoMV R 
			 inner join sumaGeneral I
			 on R.Semana=I.Semana 

update R set R.TotalGeneralMXN =(select SUM(TotalOrdenado) from sumatolaCompra)
             from nuflujoMV R  

-----------------------------------------------------------------------------------------------------------
----------------------------------------------CALCULO DEL DESCUENTO----------------------------------------
-----------------------------------------------------------------------------------------------------------

--update R set R.Descuento=cast((ImporteFacturas*((PorcenDescuento)/100)) as decimal (18,2))  from  nuflujoMV R
--where ImporteFacturas<>0 AND FechaConsi IS NOT NULL AND tipodescuento=1 






update R set R.DescuentoxTipo=PC.ImporteDescuento 
from nuflujoMV R inner join DesTipo PC on PC.tipo=R.tipo

update R set R.DescuentoxTipo=PC.ImporteDescuento 
from nuflujoMV R inner join DesTipo PC on PC.tipo=R.tipo

update R set R.FechaRecepcion =APDoc.user7
         from nuflujoMV R  inner join APDoc on APDoc.RefNbr=R.REC_APRefNo

update R set R.FacturaProv =APDoc.invcnbr
         from nuflujoMV R  inner join APDoc on APDoc.RefNbr=R.REC_APRefNo


update R set R.iva=PC.Saldo
--select distinct PC.*
from nuflujoMV R inner join SaldoxTipo PC on PC.tipo=R.tipo

--exec HISTORIALSEMANA  @semana1
/*select * from ResumDetalle
select * from DetalleFueraPresupuesto
select * from nuflujoMV */
