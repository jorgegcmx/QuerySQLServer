update  nurqReqHdrgas set Status='U' , Manejo='N'
update  nurqreqdetgas set StatusPartida='U' 




alter proc sp_creaOrdenGas @Loterequi varchar(10) as

DECLARE @LoteOrden varchar(10)
DECLARE @user varchar(10)
DECLARE @Granja varchar(10)

set @LoteOrden=(Select right('0000000000'+(cast((Cast(user1 as integer)+1)as varchar(10))),10) from POSetup)

set @user=(Select PersonaSol from nurqReqHdrgas where BatNbr=@Loterequi)

set @Granja=(Select AreaSolic from nurqReqHdrgas where BatNbr=@Loterequi)

/*Agregamos el Header a la Orden*/
insert into nuPeOCGHdr (LotOCG,FOC,Status,StatusRep,Crtd_User,Com,User1,S4Future02) values (@LoteOrden,getdate(),'P','N',@user,'AGQ', @Loterequi,@Granja)
/*Agregamos el detalle*/
insert into nuPeOCGDet (LotOCG,TipoComp,StatusRep,CveArt,DesrArt ,DestGas,GranjaD,ModuloD,CasetaD,CveAlm,TanqueD,CantOrd,RegistroID,NoReq,FReq,UM)
select @LoteOrden,'DL'as TipoComp,'N'as StatusRep ,InvtID,DescrSL,Destino,Granja,Modulo,Caseta,AlmacenDest,LocDest,CantOrdBASE,RegistroID,BatNbr,FecReqDeEnt,UniDeMed 
from nurqreqdetgas where BatNbr=@Loterequi
update POSetup  set user1=@LoteOrden

update D set D.PoNbr=DC.LotOCG
from nurqreqdetgas D 
inner join nuPeOCGDet DC on DC.NoReq=D.BatNbr where DC.LotOCG=@LoteOrden


Text
-----------------PV-------------------------------------------
CREATE procedure pvOrdenesCompra @UseridAux varchar(10), @loOC varchar(10)    
as    
select * from  nuPeOCGHdr where Crtd_User = @UseridAux AND  Status = 'P' and LotOCG like @loOC  order by LotOCG  desc

alter procedure pvOrdenesCompra @UseridAux varchar(10), @loOC varchar(10)    
as    
select * from  nuPeOCGHdr where S4Future02 in (select  GranjaID from NuPEConfUser where UserID = @UseridAux)  AND  Status = 'P' and LotOCG like @loOC  order by LotOCG  desc


--status de ordenes de compra
M;Completada,O;Orden Abierta,P;Orden Compra,Q;Cotización,X;Cancelada


create Proc cantRecibidaGas @orden varchar(10) as
update R set R.CantSurt=D.Cantidad
--select H.S4Future02,D.Cantidad,D.User5 
from nupeRecGASHdr H 
inner join nupeRecGASDet D on D.RecepGasID=H.RecepGasID
inner join nurqreqdetgas R on R.RegistroID=D.User5
where H.LoteEntrada <>'' and H.S4Future02=@orden



select Status,User1,LotOCG,Crtd_User,S4Future02 

                    'P'           'N'
update H set Crtd_User='GSTMARIA01' from nuPeOCGHdr H where User1='0000000018'

select *  from nuPeOCGHdr

