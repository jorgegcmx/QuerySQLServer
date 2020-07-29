create view VWdesorden as 
select *  from   NuReporteFinalMV  where BatNbr not in (select )

select * from VWdesorden where ORDEN in (
'0000096851')
order by ORDEN



SELECT ORDEN FROM VWdesorden  
     GROUP BY ORDEN 
     HAVING COUNT(*)>1

