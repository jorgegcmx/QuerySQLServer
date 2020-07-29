CREATE Procedure REPORTEMAESTROPESINFACTORES_lote @proyecto varchar(20)
AS
SET NOCOUNT ON
BEGIN TRANSACTION 
BEGIN TRY
insert into  nupeCostCasCerr_lote (lote,Granja,Nombre,Ano,Ciclo,Modulo,Caseta,Concepto,Proyecto,Unidades,Importe,Cuenta,Grupo,ConceptDetalle,trandate)
SELECT VE.batnbr,P.GranjaID,'',P.Ano,P.Ciclo,ModuloID,P.CasetaID,VE.Concepto,ProyectoVigente,Cantidad,Importe,VE.Acct,'','',VE.trandate 
    FROM PROYECTOSCERRADOS P (NOLOCK)
                             INNER JOIN VentasTerceros_EnviadosRastro_lote VE (NOLOCK)
							 ON  P.AlmacenCASETA  = VE.SiteID
							 AND P.ProyectoVigente = VE.ProjectID
							 AND VE.trandate   between 	P.Crtd_DateTime and P.FechaCierreCAS						 
							 WHERE ProyectoVigente =@proyecto



insert into  nupeCostCasCerr_lote (lote,Granja,Nombre,Ano,Ciclo,Modulo,Caseta,Concepto,Proyecto,Unidades,Importe,Cuenta,Grupo,ConceptDetalle,trandate)
SELECT M.batnbr,P.GranjaID,'',P.Ano,P.Ciclo,ModuloID,P.CasetaID,M.Concepto,ProyectoVigente,M.Cantidad,M.Importe,M.Acct,'2.MORTALIDAD','',M.tranDate
    FROM PROYECTOSCERRADOS P (NOLOCK)
                             INNER JOIN MORTALIDAD_lote M (NOLOCK)
							 ON   P.AlmacenCASETA  = M.SiteID 
							  AND M.trandate   between 	P.Crtd_DateTime and P.FechaCierreCAS							 
							 WHERE ProyectoVigente =@proyecto


insert into  nupeCostCasCerr_lote (lote,Granja,Nombre,Ano,Ciclo,Modulo,Caseta,Concepto,Proyecto,Unidades,Importe,Cuenta,Grupo,ConceptDetalle,trandate)
SELECT A.batnbr,P.GranjaID,'',P.Ano,P.Ciclo,ModuloID,P.CasetaID,A.Concepto,ProyectoVigente,A.Cantidad,A.Importe,A.Acct,'3.ALIMENTO',A.Descr,A.trandate 
    FROM PROYECTOSCERRADOS P (NOLOCK)
                              INNER JOIN ALIMENTO_lote A (NOLOCK)
							  ON  P.AlmacenCASETA  = A.SiteID
							  AND A.trandate   between 	P.Crtd_DateTime and P.FechaCierreCAS	
							  WHERE ProyectoVigente =@proyecto


insert into  nupeCostCasCerr_lote (lote,Granja,Nombre,Ano,Ciclo,Modulo,Caseta,Concepto,Proyecto,Unidades,Importe,Cuenta,Grupo,ConceptDetalle,trandate)
SELECT G.batnbr,P.GranjaID,'',P.Ano,P.Ciclo,ModuloID,P.CasetaID,G.Concepto,ProyectoVigente,G.Cantidad,G.Importe,G.Acct,'4.CONSUMO DE GAS','',G.trandate 
    FROM PROYECTOSCERRADOS P (NOLOCK)
                             INNER JOIN GAS_lote G (NOLOCK)							
							 ON P.AlmacenGAS = G.SiteID and P.ProyectoVigente=G.ProjectID
							 AND G.trandate   between 	P.Crtd_DateTime and P.FechaCierreCAS
							 WHERE ProyectoVigente =@proyecto


insert into  nupeCostCasCerr_lote (lote,Granja,Nombre,Ano,Ciclo,Modulo,Caseta,Concepto,Proyecto,Unidades,Importe,Cuenta,Grupo,ConceptDetalle,trandate)
SELECT PO1.batnbr,P.GranjaID,'',P.Ano,P.Ciclo,ModuloID,P.CasetaID,PO1.Concepto,ProyectoVigente,PO1.Cantidad,PO1.Importe,PO1.Acct,'5.POLLO DE 1 DIA',PO1.InvtID,PO1.trandate 
    FROM PROYECTOSCERRADOS P (NOLOCK)
                             INNER JOIN POLLITO1DIA_lote PO1 (NOLOCK)
							 ON P.AlmacenCASETA  = PO1.SiteID 						
							 AND PO1.trandate   between 	P.Crtd_DateTime and P.FechaCierreCAS
							 WHERE ProyectoVigente =@proyecto







/*AJUSTES DE USUARIO*/
insert into  nupeCostCasCerr_lote (lote,Granja,Nombre,Ano,Ciclo,Modulo,Caseta,Concepto,Proyecto,Unidades,Importe,Cuenta,Grupo,ConceptDetalle,trandate)
SELECT TMP.batnbr, 
       P.GranjaID,
        '',
       SUBSTRING(P.ProyectoVigente,3,4) AS Anio,
       SUBSTRING(P.ProyectoVigente,7,2) AS Ciclo,
	   SUBSTRING(P.ProyectoVigente,11,2) AS Modulo,
	   SUBSTRING(P.ProyectoVigente,13,2) AS Caseta,
	   'AJUSTE HECHO POR USUARIO' AS Concepto,
	   P.ProyectoVigente,
	   null,	   
	   sum(TMP.TranAmt) as Importe,
	   TMP.Cuenta,
	   '8.AJUSTE HECHO POR USUARIO',
	   'Ajuste Hecho por Usuario',
	    TMP.TranDate                               
										 FROM   VWHechoXUsuario_lote TMP (NOLOCK) 
										 INNER JOIN PROYECTOSCERRADOS  P  
										 ON P.AlmacenCASETA=TMP.SiteID
										 AND TMP.tranDate between P.Crtd_DateTime and P.FechaCierreCAS	                                                                    
                                         WHERE P.ProyectoVigente =@proyecto
         GROUP BY
										 TMP.batnbr,
                                         P.GranjaID, 										 
										 SUBSTRING(P.ProyectoVigente,3,4),
                                         SUBSTRING(P.ProyectoVigente,7,2) ,
	                                     SUBSTRING(P.ProyectoVigente,11,2) ,
	                                     SUBSTRING(P.ProyectoVigente,13,2),									
										 P.ProyectoVigente,
										 TMP.Cuenta,
										 TMP.TranDate 	


/*MATERIALES*/
insert into  nupeCostCasCerr_lote (lote,Granja,Nombre,Ano,Ciclo,Modulo,Caseta,Concepto,Proyecto,Unidades,Importe,Cuenta,Grupo,ConceptDetalle,trandate)
SELECT vw.Batnbr,
       VW.GranjaID,
       '',
       VW.Ano,
       VW.Ciclo,
	   VW.ModuloID,
	   VW.CasetaID,
	   M.Clasedesc as Concepto,
	   VW.ProyectoVigente as Proyecto,
	   null,
	   sum(VW.Importe)as Importe,
	   /*VW.COGSAcct,
	   VW.COGSSub,*/
	   VW.InvtAcct,
	   /*VW.InvtSub,*/
	   '7.CONSUMO DE MATERIALES',
	   M.nombre,
	   VW.trandate	 
       FROM  VW_Union_Carton_Intran VW (nolock)
	                                   inner join VW_Materiales_lote M 
	                                   on M.LoteAplicCosto=VW.Batnbr	
	                                   and  VW.AlmacenCASETA=M.CasetaID 
	                                   and SUBSTRING(VW.RefNbr, 4,7) = M.InvtID
	                                   where ProyectoVigente =@proyecto
										 GROUP BY
                                         VW.Batnbr, 										 
										 VW.GranjaID,
                                         VW.Ano,
                                         VW.Ciclo,
	                                     VW.ModuloID,
	                                     VW.CasetaID,
										 M.Clasedesc,									
										 VW.ProyectoVigente,
										/* VW.COGSAcct,
	                                     VW.COGSSub,*/
	                                     VW.InvtAcct,
	                                    /* VW.InvtSub,*/
										  M.nombre,
										  VW.trandate	 



/*FACTORES*/
insert into  nupeCostCasCerr_lote (lote,Granja,Nombre,Ano,Ciclo,Modulo,Caseta,Concepto,Proyecto,Unidades,Importe,Cuenta,Grupo,ConceptDetalle,trandate)
SELECT VW.BatNbr,
       VW.GranjaID,
       '',
       VW.Ano,
       VW.Ciclo,
	   VW.ModuloID,
	   VW.CasetaID,
	   AJ.User1 as Concepto,
	   VW.ProyectoVigente as Proyecto,
	   null,
	   sum(VW.Importe)as Importe,
	   VW.COGSAcct,
	   /*VW.COGSSub,
	   VW.InvtAcct,
	   VW.InvtSub,*/
	   '6.APLICACION DE FACTORES',	
	   AJ.Descripcion,
	   VW.trandate	 
       FROM   VW_Union_Carton_Intran VW (nolock)
	          inner join VW_Factores AJ (nolock)
	           on  AJ.LoteAjuste = VW.BatNbr and Aj.Referencia=VW.RefNbr and VW.AlmacenCASETA=AJ.SiteID
	                                     where ProyectoVigente = @proyecto
										 GROUP BY 
										 vw.BatNbr,										 
										 VW.GranjaID,
                                         VW.Ano,
                                         VW.Ciclo,
	                                     VW.ModuloID,
	                                     VW.CasetaID,
										 AJ.User1,
										 VW.ProyectoVigente,
										 VW.COGSAcct,
	                                     /*VW.COGSSub,
	                                     VW.InvtAcct,
	                                     VW.InvtSub,*/
										 AJ.Descripcion,
										 VW.trandate	


update R set R.Granja=Carton.GranjaID 
                               from nupeCostCasCerr_lote R (NOLOCK)
                               inner join NuPeContCasHdr Carton (NOLOCK)
							   on Carton.ProyectoVigente=R.Proyecto 							 
							   where R.Granja ='' and R.Proyecto  =  @proyecto


update R set R.Nombre=G.Nombre 
                               from nupeCostCasCerr_lote R (NOLOCK)
                               inner join nuicGranjas G (NOLOCK)
							   on G.Granja= R.Granja and R.Proyecto = @proyecto
							   
update R set R.Grupo='0.'+ R.Concepto
                               from nupeCostCasCerr_lote R (NOLOCK) 
							   where R.Concepto='VENTAS A TERCEROS' and R.Proyecto = @proyecto
update R set R.Grupo='1.'+ R.Concepto
                               from nupeCostCasCerr_lote R (NOLOCK)
							   where R.Concepto='ENVIADOS A RASTRO' and R.Proyecto = @proyecto

COMMIT TRANSACTION 
END TRY
BEGIN CATCH
ROLLBACK TRANSACTION
PRINT 'Ha ocurrido un error!'
END CATCH