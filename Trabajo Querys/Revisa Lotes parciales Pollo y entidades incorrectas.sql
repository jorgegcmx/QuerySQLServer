
SELECT distinct Batnbr, trandate,SiteID,ProjectID,InvtSub,Sub,ReasonCd  FROM INTran 
WHERE SiteID LIKE 'CA%' AND SUBSTRING(InvtSub,9,4)<> SUBSTRING(Sub,9,4)  
and TranDate>'2020-06-04 00:00:00' 
and TranType='II'
and BatNbr in( select LoteConsAlimGas from nupeContCasDet) order by trandate desc

  