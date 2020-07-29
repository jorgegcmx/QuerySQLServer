 delete from nupeReporteMasterHeader  where  ProyectID in('PE202003HA0101')


 delete  from nupeCostCasCerr  where  Proyecto  in('PE202003HA0101') 





select BatNbr,RefNbr,TranDate,Crtd_User ,Crtd_DateTime
--update I set TranDate='20200609'
from intran I
where Crtd_DateTime between '2020-06-10 17:00:00' and '2020-06-10 23:00:00' and TranType='AJ' and InvtID like'PLO%' 
order by TranDate desc







