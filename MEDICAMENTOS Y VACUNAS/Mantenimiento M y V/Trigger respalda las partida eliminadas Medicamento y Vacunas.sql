

CREATE  TRIGGER TRG_PartidasRQHistoryMV
ON [nurqReqDet]
AFTER DELETE AS
BEGIN
INSERT INTO nuHistoryPartRequisMV (BatNbr,DescrAbierta,InvtID,VendorId,DescrUser,DescrSL,UniDeMed,PrecioUnitario,Precio,FecReqDeEnt,FechaProm,CantOrd,CantSurt,CantEnt,
       Observaciones,Entidad,Status,TrsnfrDocNbr,RefNbr,PoNbr,NAlmacen,MinimoRecepcion,StatusPartida,CantEnOC,S4Future01,S4Future11,CantOrdBase)

SELECT BatNbr,DescrAbierta,InvtID,VendorId,DescrUser,DescrSL,UniDeMed,PrecioUnitario,Precio,FecReqDeEnt,FechaProm,CantOrd,CantSurt,CantEnt,
       Observaciones,Entidad,Status,TrsnfrDocNbr,RefNbr,PoNbr,NAlmacen,MinimoRecepcion,StatusPartida,CantEnOC,S4Future01,S4Future11,CantOrdBase
	   FROM DELETED where S4Future11<>''
END

select *  from nuHistoryPartRequisMV


USE AGQSLAPP;  
GO  
IF OBJECT_ID ('TRG_PartidasRQHistoryMV', 'TR') IS NOT NULL  
   DROP TRIGGER TRG_PartidasRQHistoryMV;  
