select
    case when INTran.Acct = '11332011' then 'Ventas a Division Comercial' 
	     when INTran.Acct = '51100004' then 'Ventas a Terceros' 
		 end as tipo,
    batch.BatNbr,
    INTran.RefNbr,
    INTran.SiteID,
    TranDesc,
    Qty,
    TranAmt,
    INTran.Acct,
    INTran.Sub,
    Dpedidos.Pesoneto,
	INTran.TranDate,
	LoteCxc,
	ARDoc.OrigDocAmt,	
	 case when Batch.Status = 'V' then 'Cancelado' 
	      when Batch.Status = 'H' then 'Retenido'
		  when Batch.Status = 'B' then 'Balanceado' 
		  when Batch.Status = 'S' then 'Parcialm Liberado' 
		  when Batch.Status = 'I' then 'Parcialm Cancelado'
		  when Batch.Status = 'C' then 'Completo' 
		  when Batch.Status = 'U' then 'No Asentado' 
		  when Batch.Status = 'P' then 'Asentado'   
 end as StatusBatch	
from
    INTran (nolock)
    inner join batch (nolock) 
	on INTran.BatNbr = batch.BatNbr
    inner join NuvtPOVVtaHdr Hpedidos (nolock)
	on Hpedidos.S4Future01 = INTran.BatNbr
    inner join NuVtPOVVtaDet Dpedidos (nolock)	 
	on Dpedidos.pedido = Hpedidos.pedido 	
	left outer join ARDoc (nolock) 
	on ARDoc.BatNbr=Hpedidos.LoteCxc
	
where
    TranDesc like 'Pollito%'
    and INTran.Acct in('11332011', '51100004')     
    and TranType = 'II' 	




alter view ventas_pollo_junio as
select 
'Ventas a Division Comercial' as tipo,
    INTran.BatNbr,
    INTran.RefNbr as pedido,
    INTran.SiteID,
    TranDesc,
    Qty,
    TranAmt,
    INTran.Acct,
    INTran.Sub,  
	INTran.TranDate,
	0 as factura,
	0 as importe
	from   INTran (nolock)  
where RefNbr in (select pedido from NuvtPOVVtaHdr)
--and PerPost='202006'
and TranType = 'II' 
and Acct = '11332011'
union
select  
 'Ventas a Terceros' as tipo,
    INTran.BatNbr,
    INTran.RefNbr as pedido,
    INTran.SiteID,
    TranDesc,
    Qty,
    TranAmt,
    INTran.Acct,
    INTran.Sub,  
	INTran.TranDate,
	A.BatNbr as factura,
	A.CuryOrigDocAmt as importe
 from   INTran (nolock)  
 left outer join NuvtPOVVtaHdr P
on P.pedido=INTran.RefNbr
left outer join ARDoc A
on A.BatNbr=P.LoteCxC
where INTran.RefNbr in (select pedido from NuvtPOVVtaHdr)
--and PerPost='202006'
and TranType = 'II' 
and Acct = '51100004'	
union
select  
 'Devolucion' as tipo,
    INTran.BatNbr,
    INTran.RefNbr as pedido,
    INTran.SiteID,
    TranDesc,
    Qty,
    -TranAmt,
    INTran.Acct,
    INTran.Sub,  
	INTran.TranDate,
	0 as factura,
	0 as importe
from   INTran (nolock)  
where RefNbr in (select pedido from NuvtPOVVtaHdr)
--and PerPost='202006'
and TranType in('RI')
and Acct = '51100004'	





alter view vw_conta_ventas_pollo as
select  G.Acct as Cuenta,G.BatNbr as Poliza ,G.Module as Modulo,CrAmt as Abono,DrAmt as Cargo,G.Crtd_User as Usuario,G.TranDesc as Descripcion,Qty,RefNbr from GLTran  G where G.Sub like 'PE%' and G.PerPost='202007' and G.Acct in('51100004') 
union
select  G.Acct as Cuenta,G.BatNbr as Poliza ,G.Module as Modulo,CrAmt as Abono,DrAmt as Cargo,G.Crtd_User as Usuario,G.TranDesc as Descripcion,Qty,RefNbr  from GLTran  G where G.Sub like 'CO0000%' and G.PerPost='202006' and G.Acct in('11332011') 


select * from vw_conta_ventas_pollo VC 
left outer join ventas_pollo_junio VI 
on VI.BatNbr=VC.Poliza and  VI.Qty =VC.Qty and VI.Pedido=VC.RefNbr 
order by VC.Cuenta,VI.tipo















select G.BatNbr as Poliza ,G.Module as Modulo,CrAmt as Abono,DrAmt as Cargo,G.Crtd_User as Usuario,G.TranDesc as Descripcion,V.*,A.BatNbr,A.CuryOrigDocAmt 
from GLTran  G 
left outer join ventas_pollo_junio V 
on V.BatNbr=G.BatNbr
left outer join NuvtPOVVtaHdr P
on P.pedido=V.pedido
left outer join ARDoc A
on A.BatNbr=P.LoteCxC
where G.Sub like 'PE%' and G.PerPost='202006' and G.Acct in('51100004')
order by tipo







select G.BatNbr as Poliza ,G.Module as Modulo,sum(CrAmt) as Abono,sum(DrAmt) as Cargo,Crtd_User,G.TranDesc,V.tipo,V.BatNbr,V.pedido,V.SiteID,'',V.Cantidad,V.suma,V.Acct,V.Sub,V.TranDate--,A.BatNbr,A.CuryOrigDocAmt 
from GLTran  G (nolock)
left outer join vw_lotes_ventas V (nolock)
on V.BatNbr=G.BatNbr
--left outer join NuvtPOVVtaHdr P
--on P.pedido=V.pedido
--left outer join ARDoc A
--on A.BatNbr=P.LoteCxC
where G.Sub like 'CO0000%' and G.PerPost='202006' and G.Acct in('11332011')
and G.BatNbr in(
'0000072013',
'0000072099',
'0000072202',
'0000072280',
'0000072399',
'0000072425',
'0000072444',
'0000072523',
'0000072528',
'0000072544',
'0000072573',
'0000072878',
'0000072957',
'0000072004',
'0000072095',
'0000072156',
'0000072191',
'0000072231',
'0000072239',
'0000072342',
'0000072561',
'0000072610',
'0000072666',
'0000072683',
'0000072798',
'0000072960'
)
group by  G.BatNbr,G.Module,G.Crtd_User,G.TranDesc,V.tipo,V.BatNbr,V.pedido,V.SiteID,V.Cantidad,V.suma,V.Acct,V.Sub,V.TranDate
order by tipo



select SiteID from INTran  where BatNbr= '0002685496'

select * from nupeContCasDet where NumIDCaseta='324' and Fecha='2020-07-08 00:00:00'


select * from NuReporteFinalMV where Semana='1020'