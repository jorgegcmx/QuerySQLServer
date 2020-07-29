

alter view vw_compramensual as
select DATENAME (MONTH, DATEADD(MONTH, MONTH(SemanasXAno.FechaInicial) - 1, '1900-01-01')) as mes,
       'Año-'+CONVERT(varchar, YEAR(SemanasXAno.FechaInicial), 101) as annio,
	   'Semana-'+NuReporteFinalMV_MSPE.Semana as Semana,
	   InvtID,
	   CantOrdBase,
	   UnitCostR,
	   CostExtR,
	   DescrSL,
	   InvtOC,
	   CantOrdBase as cantOB,
	   UniCostOC,
	   (CantOrdBase*UniCostOC) as ExtCost,
	   DATENAME (MONTH, DATEADD(MONTH, MONTH(SemanasXAno.FechaInicial) - 1, '1900-01-01')) +'-'+'Año-'+CONVERT(varchar, YEAR(SemanasXAno.FechaInicial), 101) as Codigo
from NuReporteFinalMV_MSPE 
inner join SemanasXAno 
on SemanasXAno.SemAno=NuReporteFinalMV_MSPE.Semana



alter view vw_compramensual_ordenes as
--select * from vw_mesoorden 

--create view vw_mesoorden as
select distinct DATENAME (MONTH, DATEADD(MONTH, MONTH(SemanasXAno.FechaInicial) - 1, '1900-01-01')) as mes,
       'Año-'+CONVERT(varchar, YEAR(SemanasXAno.FechaInicial), 101) as annio,
	  NuReporteFinalMV_MSPE.impoteDOC,
	  NuReporteFinalMV_MSPE.ORDEN,
	   DATENAME (MONTH, DATEADD(MONTH, MONTH(SemanasXAno.FechaInicial) - 1, '1900-01-01')) +'-'+'Año-'+CONVERT(varchar, YEAR(SemanasXAno.FechaInicial), 101) as Codigo,
	   R.Semana
	   from NuReporteFinalMV_MSPE 
inner join SemanasXAno 
on SemanasXAno.SemAno=NuReporteFinalMV_MSPE.Semana
inner join NuReporteFinalMV R 
on R.ORDEN=NuReporteFinalMV_MSPE.ORDEN




alter view vw_compramensual_pasivos as
--select * from vwPasivos 

--create view vwPasivos as
select distinct DATENAME (MONTH, DATEADD(MONTH, MONTH(SemanasXAno.FechaInicial) - 1, '1900-01-01')) as mes,
       'Año-'+CONVERT(varchar, YEAR(SemanasXAno.FechaInicial), 101) as annio,
	   ORDEN,
	   Lote_PASIVO,
	   Referencia_PASIVO,NoFactProv,Importe_Pasivo,
	   DATENAME (MONTH, DATEADD(MONTH, MONTH(SemanasXAno.FechaInicial) - 1, '1900-01-01')) +'-'+'Año-'+CONVERT(varchar, YEAR(SemanasXAno.FechaInicial), 101) as Codigo
from NuReporteFinalMV_MSPE 
inner join SemanasXAno 
on SemanasXAno.SemAno=NuReporteFinalMV_MSPE.Semana


create view vw_Pagos_mes as

select distinct DATENAME (MONTH, DATEADD(MONTH, MONTH(SemanasXAno.FechaInicial) - 1, '1900-01-01')) as mes,
       'Año-'+CONVERT(varchar, YEAR(SemanasXAno.FechaInicial), 101) as annio,
	   ORDEN,
	   Lote_PASIVO,
	   Referencia_PASIVO,NoFactProv,Importe_Pasivo,
	   DATENAME (MONTH, DATEADD(MONTH, MONTH(SemanasXAno.FechaInicial) - 1, '1900-01-01')) +'-'+'Año-'+CONVERT(varchar, YEAR(SemanasXAno.FechaInicial), 101) as Codigo,
	   Lote_cheque,
	   Referancia_cheque,
	   ImportePago,
	   ImpoteCXP,
	   SemanaPago,
	   Fecha
from NuReporteFinalMV_MSPE 
inner join SemanasXAno 
on SemanasXAno.SemAno=NuReporteFinalMV_MSPE.Semana




