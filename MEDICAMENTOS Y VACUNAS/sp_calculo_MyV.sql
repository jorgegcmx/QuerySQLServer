alter proc SP_MVFinal  as
SET NOCOUNT ON;
insert into dbo.NuReporteFinalMV (Semana,FechaRQ,BatNbr,AreaSolic,PersonaSol,DivSolic,USer2,StatusRequi,StatusPartida,InvtID,DescrAbierta,DescrSL,
            UniDeMed,CantOrdBASE,DescrUser,Proyecto,FecReqDeEnt,FechaProm,VendorId,PoNbr,CantSurt,RegistroID,User7, MotivoRet,RegistroIDR)
Select  H.S4Future02 As Semana , H.Fecha as FechaRQ, H.BatNbr, H.AreaSolic, H.PersonaSol,
        H.DivSolic,    H.USer2,
     Case When H.Status = 'U' Then 'Captura'
     When H.Status = 'A' Then 'Autorizada'
     When H.Status = 'P' Then 'Cerrada' 
	 When H.Status = 'C' Then 'Abierta'  
	 When H.Status = 'R' Then 'Retenida'
	 When H.Status = 'N' Then 'Cancelada' 
	 When H.Status = 'T' Then 'Abierta Parcialmente'  
     End as StatusRequi,
     Case When D.StatusPartida = 'U' Then 'Por Autorizar'
     When D.StatusPartida = 'A' Then 'Autorizada'
     When D.StatusPartida = 'P' Then 'Parcialmente Abierta' 
	 When D.StatusPartida = 'C' Then 'Cerrada'  
	 When D.StatusPartida = 'R' Then 'Rechazada'
	 When D.StatusPartida = 'N' Then 'Cancelada' 
	 When D.StatusPartida = 'S' Then 'Sin Presupuesto'   
	 When D.StatusPartida = 'V' Then 'Presupuestado'      
     End as StatusPartida, 
            D.InvtID,      D.DescrAbierta,   D.DescrSL,         D.UniDeMed, 
			D.CantOrdBASE, D.DescrUser,      D.Proyecto,        D.FecReqDeEnt,    D.FechaProm,
			D.VendorId,    D.PoNbr,          D.CantSurt,        D.RegistroID,     D.User7, 
		    H.MotivoRet, D.RegistroID as RegistroIDR				 
 from nurqReqHdr H (nolock)    
 join nurqReqDet D (nolock) 
 on H.BatNbr = D.BatNbr 
 Where H.S4Future02 <>'' and D.RegistroID not in (select distinct RegistroID from NuReporteFinalMV)
 And H.DivSolic ='PE' And H.User2 in( 'MEDYVAC','QUIMICO','ARTLIMP') 
 And H.MotivoRet IN ('PRPE','MSPE')
 AND D.User45=1

insert into dbo.NuReporteFinalMV (Semana,FechaRQ,BatNbr,AreaSolic,PersonaSol,DivSolic,USer2,StatusRequi,StatusPartida,InvtID,DescrAbierta,DescrSL,
            UniDeMed,CantOrdBASE,DescrUser,Proyecto,FecReqDeEnt,FechaProm,VendorId,PoNbr,CantSurt,RegistroID,User7, MotivoRet,RegistroIDR)
Select  H.S4Future02 As Semana , H.Fecha as FechaRQ, H.BatNbr, H.AreaSolic, H.PersonaSol,
        H.DivSolic,    H.USer2,
     Case When H.Status = 'U' Then 'Captura'
     When H.Status = 'A' Then 'Autorizada'
     When H.Status = 'P' Then 'Cerrada' 
	 When H.Status = 'C' Then 'Abierta'  
	 When H.Status = 'R' Then 'Retenida'
	 When H.Status = 'N' Then 'Cancelada' 
	 When H.Status = 'T' Then 'Abierta Parcialmente'  
     End as StatusRequi,
     Case When D.StatusPartida = 'U' Then 'Por Autorizar'
     When D.StatusPartida = 'A' Then 'Autorizada'
     When D.StatusPartida = 'P' Then 'Parcialmente Abierta' 
	 When D.StatusPartida = 'C' Then 'Cerrada'  
	 When D.StatusPartida = 'R' Then 'Rechazada'
	 When D.StatusPartida = 'N' Then 'Cancelada' 
	 When D.StatusPartida = 'S' Then 'Sin Presupuesto'   
	 When D.StatusPartida = 'V' Then 'Presupuestado'      
     End as StatusPartida, 
            D.InvtID,      D.DescrAbierta,   D.DescrSL,         D.UniDeMed, 
			D.CantOrdBASE, D.DescrUser,      D.Proyecto,        D.FecReqDeEnt,    D.FechaProm,
			D.VendorId,    D.PoNbr,          D.CantSurt,        D.RegistroID,     D.User7, 
		    H.MotivoRet, D.RegistroID as RegistroIDR				 
 from nurqReqHdr H (nolock)    
 join nurqReqDet D (nolock) 
 on H.BatNbr = D.BatNbr 
 Where H.S4Future02 <>'' and D.RegistroID not in (select distinct RegistroID from NuReporteFinalMV)
 And H.DivSolic ='PE' And H.User2 in( 'MEDYVAC','QUIMICO','ARTLIMP') 
 And H.MotivoRet IN ('EXPE')
 

 
 update	 H set H.S4Future02=S.SemAno, H.MotivoRet='REORDEN' 	 
 from nurqReqHdr H (nolock)    
 join nurqReqDet D (nolock) 
 on H.BatNbr = D.BatNbr
 join SemanasXAno S on H.Fecha between S.FechaInicial and S.FechaFinal 
 Where   D.InvtID in(select CodMedic from NuCatMedic)
 --And H.User2 in( 'MEDYVAC','QUIMICO','ARTLIMP','')  
 AND h.PersonaSol in('AMORQUECHO','REORDEN')
 AND Fecha>'20200201' 
 AND D.RegistroID not in (select distinct RegistroID from NuReporteFinalMV)
 AND H.MotivoRet is null


 insert into dbo.NuReporteFinalMV (Semana,FechaRQ,BatNbr,AreaSolic,PersonaSol,DivSolic,USer2,StatusRequi,StatusPartida,InvtID,DescrAbierta,DescrSL,
            UniDeMed,CantOrdBASE,DescrUser,Proyecto,FecReqDeEnt,FechaProm,VendorId,PoNbr,CantSurt,RegistroID,User7, MotivoRet,RegistroIDR)
 Select  H.S4Future02 As Semana , H.Fecha as FechaRQ, H.BatNbr, H.AreaSolic, H.PersonaSol,
        H.DivSolic,    H.USer2,
     Case When H.Status = 'U' Then 'Captura'
     When H.Status = 'A' Then 'Autorizada'
     When H.Status = 'P' Then 'Cerrada' 
	 When H.Status = 'C' Then 'Abierta'  
	 When H.Status = 'R' Then 'Retenida'
	 When H.Status = 'N' Then 'Cancelada' 
	 When H.Status = 'T' Then 'Abierta Parcialmente'  
     End as StatusRequi,
     Case When D.StatusPartida = 'U' Then 'Por Autorizar'
     When D.StatusPartida = 'A' Then 'Autorizada'
     When D.StatusPartida = 'P' Then 'Parcialmente Abierta' 
	 When D.StatusPartida = 'C' Then 'Cerrada'  
	 When D.StatusPartida = 'R' Then 'Rechazada'
	 When D.StatusPartida = 'N' Then 'Cancelada' 
	 When D.StatusPartida = 'S' Then 'Sin Presupuesto'   
	 When D.StatusPartida = 'V' Then 'Presupuestado'      
     End as StatusPartida, 
            D.InvtID,      D.DescrAbierta,   D.DescrSL,         D.UniDeMed, 
			D.CantOrdBASE, D.DescrUser,      D.Proyecto,        D.FecReqDeEnt,    D.FechaProm,
			D.VendorId,    D.PoNbr,          D.CantSurt,        D.RegistroID,     D.User7, 
		    H.MotivoRet, D.RegistroID as RegistroIDR				 
 from nurqReqHdr H (nolock)    
 join nurqReqDet D (nolock) 
 on H.BatNbr = D.BatNbr 
 Where H.S4Future02 <>'' and D.RegistroID not in (select distinct RegistroID from NuReporteFinalMV) 
 and D.InvtID in(select CodMedic from NuCatMedic)
 And H.MotivoRet IN ('REORDEN')

 
 insert into dbo.NuReporteFinalMV (Semana,FechaRQ,BatNbr,AreaSolic,PersonaSol,DivSolic,USer2,StatusRequi,StatusPartida,InvtID,DescrAbierta,DescrSL,
            UniDeMed,CantOrdBASE,DescrUser,Proyecto,FecReqDeEnt,FechaProm,VendorId,PoNbr,CantSurt,RegistroID,User7, MotivoRet,RegistroIDR)
 Select  S.SemAno As Semana , H.Fecha as FechaRQ, H.BatNbr, H.AreaSolic, H.PersonaSol,
        H.DivSolic,    H.USer2,
     Case When H.Status = 'U' Then 'Captura'
     When H.Status = 'A' Then 'Autorizada'
     When H.Status = 'P' Then 'Cerrada' 
	 When H.Status = 'C' Then 'Abierta'  
	 When H.Status = 'R' Then 'Retenida'
	 When H.Status = 'N' Then 'Cancelada' 
	 When H.Status = 'T' Then 'Abierta Parcialmente'  
     End as StatusRequi,
     Case When D.StatusPartida = 'U' Then 'Por Autorizar'
     When D.StatusPartida = 'A' Then 'Autorizada'
     When D.StatusPartida = 'P' Then 'Parcialmente Abierta' 
	 When D.StatusPartida = 'C' Then 'Cerrada'  
	 When D.StatusPartida = 'R' Then 'Rechazada'
	 When D.StatusPartida = 'N' Then 'Cancelada' 
	 When D.StatusPartida = 'S' Then 'Sin Presupuesto'   
	 When D.StatusPartida = 'V' Then 'Presupuestado'      
     End as StatusPartida, 
            D.InvtID,      D.DescrAbierta,   D.DescrSL,         D.UniDeMed, 
			D.CantOrdBASE, D.DescrUser,      D.Proyecto,        D.FecReqDeEnt,    D.FechaProm,
			D.VendorId,    D.PoNbr,          D.CantSurt,        D.RegistroID,     D.User7, 
		    H.MotivoRet, D.RegistroID as RegistroIDR				 
 from nurqReqHdr H (nolock)    
 join nurqReqDet D (nolock) 
 on H.BatNbr = D.BatNbr
 join SemanasXAno S on H.Fecha between S.FechaInicial and S.FechaFinal 
 Where H.S4Future02 <>'' and D.RegistroID not in (select distinct RegistroID from NuReporteFinalMV) 
 and D.InvtID in(select CodMedic from NuCatMedic)
 And H.User2 IN ('MEDYVAC') AND h.PersonaSol='AMORQUECHO'




 /*SEMANA SI ES QUE CAMBIA*/
 update R set  R.Semana=H.S4Future02 
 from  NuReporteFinalMV R 
 inner join nurqReqHdr H (nolock) 
 on R.BatNbr=H.BatNbr  where  R.Semana<>H.S4Future02  

  /*SI CAMBIA EL MOTIVO DE LA REQUI*/
 update R set  R.MotivoRet=H.MotivoRet  
 from  NuReporteFinalMV R 
 inner join nurqReqHdr H (nolock) 
 on R.BatNbr=H.BatNbr  where  R.MotivoRet<>H.MotivoRet  

 
   /*ESTATUS REQUI HEADER */
 update R set  R.StatusRequi=
     Case When H.Status = 'U' Then 'Captura'
     When H.Status = 'A' Then 'Autorizada'
     When H.Status = 'P' Then 'Cerrada' 
	 When H.Status = 'C' Then 'Abierta'  
	 When H.Status = 'R' Then 'Retenida'
	 When H.Status = 'N' Then 'Cancelada' 
	 When H.Status = 'T' Then 'Abierta Parcialmente'  
     End	  
 from  NuReporteFinalMV R 
 inner join nurqReqHdr H (nolock) 
 on R.BatNbr=H.BatNbr 



    /*ESTATUS REQUI DETALLE*/
 update R set  R.StatusPartida=
     Case When D.StatusPartida = 'U' Then 'Por Autorizar'
     When D.StatusPartida = 'A' Then 'Autorizada'
     When D.StatusPartida = 'P' Then 'Parcialmente Abierta' 
	 When D.StatusPartida = 'C' Then 'Cerrada'  
	 When D.StatusPartida = 'R' Then 'Rechazada'
	 When D.StatusPartida = 'N' Then 'Cancelada' 
	 When D.StatusPartida = 'S' Then 'Sin Presupuesto'   
	 When D.StatusPartida = 'V' Then 'Presupuestado'      
     End  	  
 from  NuReporteFinalMV R 
 inner join nurqReqDet D (nolock) 
 on R.BatNbr=D.BatNbr
  AND D.RegistroID=R.RegistroID


 /*CANTIDAAD DE ARTICULOS*/
 update R set  R.CantOrdBASE=D.CantOrdBASE 
 from  NuReporteFinalMV R 
 inner join nurqReqDet D (nolock) 
 on R.BatNbr=D.BatNbr 
 AND D.RegistroID=R.RegistroID
 WHERE LTRIM(R.Semana+''+R.MotivoRet) NOT IN (select * from nuCantImporte)      

  /*COSTO AUTORIZADO SOLO CUNADO AUN NO SE HA CUADRADO LA SEMANA*/
 update R set  R.UnitCostR=CostoAut,
			   R.CostExtR=(CantOrdBASE * CostoAut) 
 from  NuReporteFinalMV R 
 inner join nuPresAutoDet D (nolock) on 
 D.ClaveArt=R.InvtID and  R.Semana=D.Semana AND LTRIM(R.Semana+''+R.MotivoRet) NOT IN (select * from nuCantImporte)

 
  update R set  R.UnitCostR=CostoAut,
			   R.CostExtR=(CantOrdBASE * CostoAut) 
 from  NuReporteFinalMV R 
 inner join nuPresAutoDet D (nolock) on 
 D.ClaveArt=R.InvtID and  R.Semana=D.Semana WHERE MotivoRet IN ('EXPE','REORDEN') AND UnitCostR is null

/*INSERTAMOS EL TIPO DE REQUI YA CUADRADO*/
insert into  nuCantImporte
select distinct LTRIM(Semana+''+MotivoRet)as SemanaTipo from NuReporteFinalMV where LTRIM(Semana+''+MotivoRet) not in (select * from nuCantImporte)

--select * from nuCantImporte
/* DATOS DE SIN REQUI PADRE*/

 update R set     ORDEN =D.PONbr,
			      CLAVEPROV=vendid,
			      InvtOC=D.InvtID,			     
			      CantOC=D.QtyOrd,
			      UniCostOC=D.unitcost,
			      extCostOC=D.extcost,
				  ImpoteDOC=H.PoAmt

 from  NuReporteFinalMV R 
 inner join purorddet D (nolock) on 
  D.User1=R.BatNbr 
 inner join purchord H (nolock) on
 H.PONbr=D.PONbr
 and R.RegistroID=D.User3
 and H.Status<>'X'



 /* DATOS DE REQUI PADRE*/
 update R set     ORDEN =D.PONbr,
			      CLAVEPROV=vendid,
			      InvtOC=D.InvtID,			     
			      CantOC=D.QtyOrd,
			      UniCostOC=D.UnitCost,
			      extCostOC=D.ExtCost,
				  ImpoteDOC=H.PoAmt  
                  FROM NuReporteFinalMV R   (NOLOCK)
                                  inner join nurqReqDetOrVsPa ORD (NOLOCK)
								  on convert(int,R.RegistroID) = ORD.RegistroIDOr    
	                              and R.BatNbr= ORD.BatNbrOr
								  inner join purorddet D (nolock) on 
                                  D.User1=ORD.BatNbrPadre 
                                  inner join purchord H (nolock) on
                                  H.PONbr=D.PONbr
                                  and ORD.RegistroIDPadre=D.User3
								  and R.InvtID=D.InvtID
								  where H.Status<>'X'
								 

	
					  
/*CANCELADA*/
update R set   R.ORDEN=null,R.CLAVEPROV=null,R.InvtOC=null,R.CantOC=null,R.UniCostOC=null,R.extCostOC=null,R.ImpoteDOC=null
--SELECT R.ORDEN,R.CLAVEPROV,R.InvtOC,R.CantOC,R.UniCostOC,R.extCostOC,R.ImpoteDOC
From NuReporteFinalMV R		(nolock)				
                inner join PurchOrd  A (nolock)
				on A.PONbr=R.ORDEN	
				WHERE A.Status='X'							 

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
--select A.*,B.Module,A.DocType
from NuReporteFinalMV R (nolock)
inner join APDoc A (nolock)
on A.PONbr=R.ORDEN
inner join batch B (nolock)
on A.BatNbr=B.BatNbr 
inner join aptran AP (nolock)
 on AP.BatNbr=A.BatNbr 
--and R.InvtOC=AP.InvtID	
where R.ORDEN IS NOT NULL AND R.PoNbr <>'PARCIAL' 
--and  A.Status='P'
--and A.RefNbr in ('0000219750')
and B.Module='AP' 
--and A.DocType='VO'


update R set R.NombreProveedor=Name
from NuReporteFinalMV R inner join vendor on vendid=R.ClaveProvedor	
where R.NombreProveedor=''


/*DATOS DEL CHEQUE PAGO*/
 
 UPDATE R SET 
 Lote_cheque=A.AdjBatNbr,
 Referancia_cheque=A.AdjdRefNbr,
 ImportePago=A.AdjAmt,
 CuentaPago=a.AdjgAcct
 --select A.*
 from NuReporteFinalMV R (nolock)
 inner join APAdjust A (nolock)
 on A.AdjdRefNbr=R.Referencia_PASIVO 
 where  --AdjdRefNbr = '0000204798' and  
 AdjgAcct <>'11104400'

 


 /*DATOS IMPORTE USD */

 UPDATE R SET ImportePago=(A.Monto*A.OtrosImpuestos) 
 --select  Semana,ImportePago,Referencia_PASIVO,(A.Monto*A.OtrosImpuestos) 
 from NuReporteFinalMV R (nolock)
 inner join Nucapagochdet A (nolock)
 on A.RefSol=R.Referencia_PASIVO 
 where  R.CuentaPago ='11104102' 


 /*DATOS IMPORTE CXP DESCUENTOS O OTROS */
 
 UPDATE R SET
 R.ImpoteCXP=A.AdjAmt
 from NuReporteFinalMV R (nolock)
 inner join APAdjust A (nolock)
 on A.AdjdRefNbr=R.Referencia_PASIVO
 inner join APDoc AP on AP.RefNbr=A.AdjgRefNbr
 where  a.AdjgAcct='11104400' and AP.S4Future01='A' 


 
 /*colocamos las cuentas de las transacciones Y SU DESCRIPCION */

update R set R.CuentaPago=CA.Acct
from nucaPagoAProvDet D (nolock)
inner join NuReporteFinalMV R (nolock)
on R.Referencia_PASIVO=D.RefSol
inner join batch B (nolock)
on B.batnbr=D.LoteTranEfe
inner join CATran CA (nolock)
on CA.batnbr=B.BatNbr
where B.Module='AP' and CA.DrCr='C' and R.CuentaPago<>CA.Acct 
/*CUENTAS QUE NO ENCUENTRA*/
update R set R.CuentaPago=CA.bankacct
--select R.CuentaPago,CA.bankacct
from nucaPagoAProvDet D (nolock)
inner join NuReporteFinalMV R (nolock)
on R.Lote_cheque=D.LoteCheque
inner join CATran CA (nolock)
on D.LoteTranEfe=CA.BatNbr
where CA.DrCr='C' and R.CuentaPago<>CA.bankacct 


update R set  R.NombreCta=A.Descr  
From NuReporteFinalMV R		(nolock)				
                inner join Account  A (nolock)
				on A.Acct=R.CuentaPago 

/*FECHA EN QUE SE CONCILIO EL PAGO*/
update R set  R.Fecha=A.ClearDate  
From NuReporteFinalMV R		(nolock)				
                inner join APDoc  A		(nolock)
				on A.BatNbr=R.Lote_cheque

update R set  R.semanaPago=A.SemAno 
From NuReporteFinalMV R	(nolock)					
                inner join SemanasXAno  A	(nolock)	
				on R.Fecha between A.FechaInicial and A.FechaFinal


--select * from NuReporteFinalMV 

/*
alter view tipodetransaccion as
 select distinct  R.Semana,R.Lote_PASIVO,R.Referencia_PASIVO, 
     Case When AP.S4Future01 = 'C' Then 'Cheque'
     When AP.S4Future01 = 'T' Then 'Pago a Terceros'
     When AP.S4Future01 = '2' Then 'Pago Interbancario' 
	 When AP.S4Future01 = '1' Then 'Traspaso HSBC'  
	 When AP.S4Future01 = 'D' Then 'Compra de Divisas'
	 When AP.S4Future01 = '3' Then 'SPEI' 
	 When AP.S4Future01 = 'N' Then 'Cancelacion de Pasivo' 
	 When AP.S4Future01 = 'A' Then 'Aplicar Nota de Crédito'  
	 When AP.S4Future01 = 'U' Then 'Conversion de Pasivo USD/MN'
	 When AP.S4Future01 = 'I' Then 'Aplicar Pasivo pagado con Tarjeta de Credito' 
	 When AP.S4Future01 = 'H' Then 'Aplicar Pasivo Pagado con Caja Chica' 
	 When AP.S4Future01 = 'B' Then 'Cargo Bancario' 
	 When AP.S4Future01 = 'O' Then 'Orden de Pago Internacional'  
	 When AP.S4Future01 = 'G' Then 'Gastos por Comprobar'
	 When AP.S4Future01 = 'L' Then 'Pago Credilínea' 
	 When AP.S4Future01 = 'P' Then 'Pago de Impuestos'	 
	 When AP.S4Future01 = 'X' Then 'Gastos Pagados por Agente Aduanal'
	 When AP.S4Future01 = 'S' Then 'Sustitución de Acreedor' 	       
     End as tipo_de_movimiento,
	 R.CuentaPago,R.NombreCta,R.Lote_cheque
 from NuReporteFinalMV R (nolock)
 inner join APAdjust A (nolock)
 on A.AdjdRefNbr=R.Referencia_PASIVO
 inner join APDoc AP on AP.RefNbr=A.AdjgRefNbr
 where  R.CuentaPago='11104400' 

select * from NuReporteFinalMV where Referencia_PASIVO='0000195626'
 --Tengo la referencia del Pasivo
Select * From APDoc Where RefNbr in('0000195626')
--Busco la referencia del pasivo en campo AdjBatRef de APAdjust y tomo el campo 
Select * From APAdjust Where AdjdRefNbr = '0000195626' 
Select * From nucaPagoAProvDet Where LoteCheque in ('0000355344')
Select * From Catran Where BatNbr = '0000271122'
*/