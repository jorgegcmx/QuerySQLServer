
select Referencia_PASIVO,Semana 
select * from NuReporteFinalMV where Referencia_PASIVO='0000202146'
group by Referencia_PASIVO,Semana 


alter procedure sp_observaciones @semana varchar(4) as
delete from nuMVReporte
insert into nuMVReporte  (Semana,Proveedor,NombreProveedor,Articulo,Art,Descripcion,CantAutorizada,CostoUnitAutorizado,ImporteTotalAutorizado,CantEnOrdenCompra,CostoEnOrden,ImporteEnorden,CantRecibida,tipo)

select Semana,CLAVEPROV,NOMBRE,ORDEN,InvtID,DescrSL,sum(CantOrdBASE),UnitCostR,(sum(CantOrdBASE)*UnitCostR),CantOC,UniCostOC,extCostOC,extCostOC,MotivoRet  
from NuReporteFinalMV where Semana=@semana --and StatusPartida <> 'N' 
group by Semana,CLAVEPROV,NOMBRE,ORDEN,InvtID,DescrSL,UnitCostR,CantOC,UniCostOC,extCostOC,MotivoRet

update R set R.NombreProveedor=Name
from nuMVReporte R inner join vendor on vendid=R.Proveedor




