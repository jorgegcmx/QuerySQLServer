--insert into NuReporteFinalMV (Semana,FechaRQ,BatNbr,AreaSolic,PersonaSol,DivSolic,USer2, StatusRequi,StatusPartida,InvtID,UnitCostR,CostExtR,DescrAbierta,DescrSL,UniDeMed,CantOrdBASE,DescrUser,Proyecto,FecReqDeEnt,FechaProm,VendorId,PoNbr,CantSurt,RegistroID,User7,MotivoRet,RegistroIDR,ORDEN,CLAVEPROV,NOMBRE,InvtOC,DescOC,CantOC,UniCostOC,extCostOC,ImpoteDOC,Referencia_PASIVO)

select distinct Semana,FechaRQ,NuReporteFinalMV.BatNbr,AreaSolic,PersonaSol,DivSolic,NuReporteFinalMV.User2, StatusRequi,
       StatusPartida,InvtID,0,0,DescrAbierta,DescrSL,UniDeMed,
	   0,DescrUser,Proyecto,FecReqDeEnt,FechaProm,VendorId,'PARCIAL',
	   CantSurt,0,NuReporteFinalMV.User7,MotivoRet,0 ,ORDEN,CLAVEPROV,
	   NOMBRE,InvtOC,DescOC,CantOC,UniCostOC,extCostOC,ImpoteDOC,'PASIVO NO REGISTRADO' 
      from NuReporteFinalMV 
	  inner join  APDoc on  APDoc.PONbr=NuReporteFinalMV.ORDEN 	  
	  where  APDoc.RefNbr not in (select distinct Referencia_PASIVO from NuReporteFinalMV)	

	  /*DATOS DEL PASIVO*/
update R set 
         R.Referencia_PASIVO=A.RefNbr,
		 R.Lote_PASIVO =A.BatNbr,
		 R.NoFactProv=A.invcnbr,
		 R.importe_Pasivo=A.OrigDocAmt,
		 R.ClaveProvedor=A.vendid,
		 R.NombreProveedor=A.user2,
		 R.InvtPV=AP.InvtID,		
		 R.CantPV=AP.qty,
		 R.UniCostPV=Ap.unitprice,
		 R.extCostPV=tranamt
--select A.*
from NuReporteFinalMV R (nolock)
inner join APDoc A (nolock)
on A.PONbr=R.ORDEN
inner join batch B (nolock)
on A.BatNbr=B.BatNbr 
inner join aptran AP (nolock)
 on AP.BatNbr=A.BatNbr 
and R.InvtOC=AP.InvtID	
where R.ORDEN IS NOT NULL AND R.PoNbr ='PARCIAL' 
--and  A.Status='P'
and R.Referencia_PASIVO in ('0000206176')
and B.Module='AP' and A.DocType='VO'

