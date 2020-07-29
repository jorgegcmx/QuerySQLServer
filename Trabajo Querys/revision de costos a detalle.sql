
alter view vw_existencia_inventario as


alter view vw_ajustes_costo as

select  SiteID,InvtID,TranDate,sum(importeAjuste) as importeAjuste from vw_trans
group by  SiteID,InvtID,TranDate

alter view vw_trans as
select     SiteID,InvtID,sum(TranAmt) as importeAjuste,TranDate
from INTran (nolock)
where  InvtID like 'plo%' and TranType in ('AJ') and RefNbr  IN ('COSTOXGAS','COSTXALIM','COSX2DOALI') 
group by    SiteID,InvtID,TranDate
union
select     SiteID,InvtID,sum(TranAmt) as importeAjuste,TranDate
from INTran (nolock)
where  InvtID like 'plo%' and TranType in ('RI') and RefNbr  like 'SI%' 
group by    SiteID,InvtID,TranDate
union
select     SiteID,InvtID,sum(TranAmt) as importeAjuste,TranDate
from INTran (nolock)
where  InvtID like 'plo%' and TranType in ('AJ') and  (RefNbr  Like 'CGRAL%' or RefNbr  Like 'CGRAN%' Or RefNbr  Like 'CMODU%')
group by    SiteID,InvtID,TranDate
union
select     SiteID,InvtID,sum(TranAmt) as importeAjuste,TranDate
from INTran (nolock)
where  InvtID like 'plo%' and TranType in ('AJ') and  (RefNbr  Like 'CON%')
group by    SiteID,InvtID,TranDate
/*union
select     SiteID,InvtID,sum(TranAmt) as importeAjuste,TranDate
from INTran (nolock)
where  InvtID like 'plo%' and TranType in ('AJ') and  (RefNbr  Like 'IN%') and SiteID in ('CASMGA0205','CASMGA0210','CASMGA0304','CASMGA0302','CASMGA0303')
group by    SiteID,InvtID,TranDate*/


alter view newproject as
select DATEDIFF(day,H.Crtd_DateTime,CONVERT(VARCHAR(10),GETDATE() , 112)) as Dias, H.NumIDCaseta,ex.*,totcost,ProyectoVigente,H.Crtd_DateTime,FechaDeInicio,
case when FechaCierreCAS is null then  null
else FechaCierreCAS end as FechaCierreCAS,
H.Status,
A.importeAjuste,Trandate
from vw_existencia_inventario ex (nolock)
inner join itemsite i (nolock)
on i.SiteID=ex.SiteID and i.InvtID=ex.InvtID
inner join NuPeContCasHdr H (nolock) on H.AlmacenCASETA=i.SiteID
inner join vw_ajustes_costo A (nolock) on A.SiteID=i.SiteID /*and  A.InvtID =ex.InvtID*/ and TranDate between  H.Crtd_DateTime  and  GETDATE() 
where  H.Status in('AB','EP') 
and ex.QtyAvail>=1
and H.Crtd_DateTime >='2020-06-15 00:00:00'
order by  i.SiteID desc


create view vw_comparacion as
select Dias,NumIDCaseta,QtyAvail,InvtID,SiteID,totcost,ProyectoVigente,Crtd_DateTime,FechaDeInicio,FechaCierreCAS,sum(importeAjuste)as transacciones from newproject 
group by Dias,NumIDCaseta,QtyAvail,InvtID,SiteID,totcost,ProyectoVigente,Crtd_DateTime,FechaDeInicio,FechaCierreCAS


select Dias,NumIDCaseta,SiteID,sum(totcost),ProyectoVigente,Crtd_DateTime,FechaDeInicio,FechaCierreCAS,transacciones,(sum(totcost)-transacciones) from vw_comparacion 
group by Dias,NumIDCaseta,SiteID,ProyectoVigente,Crtd_DateTime,FechaDeInicio,FechaCierreCAS,transacciones




select distinct  TranType,BatNbr,refnbr,SiteID,InvtID,ProjectID,TranDate,Crtd_User,LUpd_User,Qty,TranAmt,Crtd_DateTime
from INTran I
where SiteID='CAHUFE0210' and InvtID like 'PLO%' and TranType in ('RI','AJ','II') and TranDate between '2020-05-24 00:00:00' and '2020-07-22 00:00:00'
order by Crtd_DateTime asc




select  AlmacenCASETA,Crtd_DateTime,FechaCierreCAS,S4Future03,Status,ProyectoVigente
--update H set Crtd_DateTime=DATEADD(DAY,1,Crtd_DateTime)
from nupeContCasHdr H where  ProyectoVigente in(
select ProyectoVigente from NuPeContCasHdr where FechaCierreCAS='20200728' and AlmacenCASETA='CAHUFE0210'
)


select distinct intran.BatNbr, INTran.RefNbr,INTran.Crtd_DateTime,TranType,TranDate from Batch (nolock) inner join INTran (nolock) on INTran.BatNbr=Batch.BatNbr 
where Batch.Status='S' and 	 InvtID like 'plo%' and TranType in ('AJ','RI','II') and INTran.Crtd_DateTime > '20200701' 



select I.BatNbr,QtyAvail,Lo.InvtID, L.SiteID,I.ProjectID,I.TranAmt
--Update I set I.InvtID='PLO0001'
from LocTable  L 
inner join 
Location Lo on Lo.SiteID=L.SiteID
inner join 
INTran I on I.SiteID=L.SiteID and Lo.InvtID=I.InvtID
where  Lo.WhseLoc='AVES' and I.BatNbr 
 in('0002806819') and QtyAvail=0
group by I.BatNbr,QtyAvail,Lo.InvtID,L.SiteID,I.ProjectID,I.TranAmt



select  TranType,BatNbr,RefNbr,TranDate,TranDesc,Crtd_User,SiteID,TranAmt,Crtd_DateTime,LUpd_User,Acct,PerPost 
from INTran  I (nolock)
where Crtd_DateTime between '2020-05-19 08:00:00' and '2020-05-19 23:00:00' 
and TranType in ('AJ','RI','II')
and InvtID like 'PLO%'
and Crtd_User='LCERON'
and SiteID like'CACNDL0304'
order by Crtd_DateTime asc


select * from nupeCostCasCerr where Proyecto='PE202003CG0206' and Grupo like'8%' and Importe<>0



select * from NuReporteFinalMV where ORDEN in('0000011822','0000011825','0000011824')

