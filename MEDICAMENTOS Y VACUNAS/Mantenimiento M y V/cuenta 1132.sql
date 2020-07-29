alter VIEW view_reporte1132 AS
SELECT    'Diesel' as Concepto,
           Acct, 
           Sub, 
		   ProjectID,
		   TaskID, 
		   SUM(DrAmt) AS Cargos,
		   SUM(CrAmt) AS Abonos,
		   MAX(PerPost) AS Perpost,
		   sum((DrAmt-CrAmt)) as Diferencia
FROM       dbo.GLTran WITH (nolock)  
WHERE     (Sub LIKE 'PEENGR%' or Sub LIKE 'PE0000%') 
AND (Acct IN('11320325','11329005'))
AND (Posted = 'P') 
AND (CpnyID = 'AGQ') 
AND TranDate BETWEEN (select fecha1 from nucuenta1132) AND (select fecha2 from nucuenta1132)
GROUP BY   ProjectID, Sub, Acct, TaskID
union
SELECT     
          'Gasolina'as Concepto,
           Acct, 
           Sub, 
		   ProjectID,
		   TaskID, 
		   SUM(DrAmt) AS Cargos,
		   SUM(CrAmt) AS Abonos,
		   MAX(PerPost) AS Perpost,
		   sum((DrAmt-CrAmt)) as Diferencia
FROM       dbo.GLTran WITH (nolock)  
WHERE     (Sub LIKE 'PEENGR%' or Sub LIKE 'PE0000%') 
AND (Acct IN('11320329','11329004'))
AND (Posted = 'P') 
AND (CpnyID = 'AGQ')
AND TranDate BETWEEN (select fecha1 from nucuenta1132) AND (select fecha2 from nucuenta1132)
GROUP BY   ProjectID, Sub, Acct, TaskID
union
SELECT     
          'Energia electrica'as Concepto,
           Acct, 
           Sub, 
		   ProjectID,
		   TaskID, 
		   SUM(DrAmt) AS Cargos,
		   SUM(CrAmt) AS Abonos,
		   MAX(PerPost) AS Perpost,
		   sum((DrAmt-CrAmt)) as Diferencia
FROM       dbo.GLTran WITH (nolock)  
WHERE    (Sub LIKE 'PEENGR%' or Sub LIKE 'PE0000%') 
AND (Acct IN('11320401','11329002'))
AND (Posted = 'P') 
AND (CpnyID = 'AGQ')
AND TranDate BETWEEN (select fecha1 from nucuenta1132) AND (select fecha2 from nucuenta1132)
GROUP BY   ProjectID, Sub, Acct, TaskID
union
SELECT     
          'Arrendamientos de terrenos Agricolas'as Concepto,
           Acct, 
           Sub, 
		   ProjectID,
		   TaskID, 
		   SUM(DrAmt) AS Cargos,
		   SUM(CrAmt) AS Abonos,
		   MAX(PerPost) AS Perpost,
		   sum((DrAmt-CrAmt)) as Diferencia
FROM       dbo.GLTran WITH (nolock)  
WHERE    (Sub LIKE 'PEENGR%' or Sub LIKE 'PE0000%') 
AND (Acct IN('11320406','11329003'))
AND (Posted = 'P') 
AND (CpnyID = 'AGQ')
AND TranDate BETWEEN (select fecha1 from nucuenta1132) AND (select fecha2 from nucuenta1132)
GROUP BY   ProjectID, Sub, Acct, TaskID
union
SELECT     
          'Depreciacion de activos fijos'as Concepto,
           Acct, 
           Sub, 
		   ProjectID,
		   TaskID, 
		   SUM(DrAmt) AS Cargos,
		   SUM(CrAmt) AS Abonos,
		   MAX(PerPost) AS Perpost,
		   sum((DrAmt-CrAmt)) as Diferencia
FROM       dbo.GLTran WITH (nolock)  
WHERE    (Sub LIKE 'PEENGR%' or Sub LIKE 'PE0000%') 
AND (Acct IN(
'11320701'  ,	
'11320702'	,
'11320709'	,
'11320711'	,
'11320713'	,
'11320715'	,
'11320717'	,
'11320723'	,
'11320724'	,'11329013'))
AND (Posted = 'P') 
AND (CpnyID = 'AGQ')
AND TranDate BETWEEN (select fecha1 from nucuenta1132) AND (select fecha2 from nucuenta1132)
GROUP BY   ProjectID, Sub, Acct, TaskID
union
SELECT     
          'MO-ServAd Personal'as Concepto,
           Acct, 
           Sub, 
		   ProjectID,
		   TaskID, 
		   SUM(DrAmt) AS Cargos,
		   SUM(CrAmt) AS Abonos,
		   MAX(PerPost) AS Perpost,
		   sum((DrAmt-CrAmt)) as Diferencia
FROM       dbo.GLTran WITH (nolock)  
WHERE    (Sub LIKE 'PEENGR%' or Sub LIKE 'PE0000%') 
AND (Acct IN('11320278','11329001','11329008'))
AND (Posted = 'P') 
AND (CpnyID = 'AGQ')
AND TranDate BETWEEN (select fecha1 from nucuenta1132) AND (select fecha2 from nucuenta1132)
GROUP BY   ProjectID, Sub, Acct, TaskID
union
SELECT     
          'Mantenimiento-servicios gja'as Concepto,
           Acct, 
           Sub, 
		   ProjectID,
		   TaskID, 
		   SUM(DrAmt) AS Cargos,
		   SUM(CrAmt) AS Abonos,
		   MAX(PerPost) AS Perpost,
		   sum((DrAmt-CrAmt)) as Diferencia
FROM       dbo.GLTran WITH (nolock)  
WHERE    (Sub LIKE 'PEENGR%' or Sub LIKE 'PE0000%') 
AND (Acct IN(
'11320302'	,
'11320303'	,
'11320304'	,
'11320305'	,
'11320327'	,
'11320335'	,
'11320337'	,
'11320404'	,
'11320426'	,
'11320427'	,
'11320428'	,
'11320429'	,
'11320431'	,
'11320450'	,
'11320512'	,
'11320611'	,
'11320609'	,
'11320607'	,
'11320604'	,
'11320601'	,
'11320602'	,
'11320613'	,
'11320615'	,
'11320617'	,
'11320618'	,
'11320531'	,
'11320529'	,
'11320523'	,
'11320522'	,
'11320521'	,
'11320520'	,
'11320519'	,
'11320518'	,
'11320514'	,
'11320513'	,
'11320510'	,
'11320509'	,
'11320508'	,
'11320505'	,
'11320503'	,
'11320501'	,
'11320405'	,
'11320115'	,
'11320113'	,
'11320112'	,
'11320099',	
'11320004','11329006'))
AND (Posted = 'P') 
AND (CpnyID = 'AGQ')
AND TranDate BETWEEN (select fecha1 from nucuenta1132) AND (select fecha2 from nucuenta1132)
GROUP BY   ProjectID, Sub, Acct, TaskID
union
SELECT     
          'Mantenimiento Eq Transporte'as Concepto,
           Acct, 
           Sub, 
		   ProjectID,
		   TaskID, 
		   SUM(DrAmt) AS Cargos,
		   SUM(CrAmt) AS Abonos,
		   MAX(PerPost) AS Perpost,
		   sum((DrAmt-CrAmt)) as Diferencia
FROM       dbo.GLTran WITH (nolock)  
WHERE    (Sub LIKE 'PEENGR%' or Sub LIKE 'PE0000%') 
AND (Acct IN('11320506','11329009'))
AND (Posted = 'P') 
AND (CpnyID = 'AGQ')
AND TranDate BETWEEN (select fecha1 from nucuenta1132) AND (select fecha2 from nucuenta1132)
GROUP BY   ProjectID, Sub, Acct, TaskID
union
SELECT     
          'Alimento complemento EFC'as Concepto,
           Acct, 
           Sub, 
		   ProjectID,
		   TaskID, 
		   SUM(DrAmt) AS Cargos,
		   SUM(CrAmt) AS Abonos,
		   MAX(PerPost) AS Perpost,
		   sum((DrAmt-CrAmt)) as Diferencia
FROM       dbo.GLTran WITH (nolock)  
WHERE    (Sub LIKE 'PEENGR%' or Sub LIKE 'PE0000%')  
AND (Acct IN('11320807','11329007'))
AND (Posted = 'P') 
AND (CpnyID = 'AGQ')
AND TranDate BETWEEN (select fecha1 from nucuenta1132) AND (select fecha2 from nucuenta1132)
GROUP BY   ProjectID, Sub, Acct, TaskID
union
SELECT     
          'Arrendamiento Eq Transporte'as Concepto,
           Acct, 
           Sub, 
		   ProjectID,
		   TaskID, 
		   SUM(DrAmt) AS Cargos,
		   SUM(CrAmt) AS Abonos,
		   MAX(PerPost) AS Perpost,
		   sum((DrAmt-CrAmt)) as Diferencia
FROM       dbo.GLTran WITH (nolock)  
WHERE     (Sub LIKE 'PEENGR%' or Sub LIKE 'PE0000%') 
AND (Acct IN('11320407','11329010'))
AND (Posted = 'P') 
AND (CpnyID = 'AGQ')
AND TranDate BETWEEN (select fecha1 from nucuenta1132) AND (select fecha2 from nucuenta1132)
GROUP BY   ProjectID, Sub, Acct, TaskID 
union
SELECT     
          'Costo fletes y acarreos intern'as Concepto,
           Acct, 
           Sub, 
		   ProjectID,
		   TaskID, 
		   SUM(DrAmt) AS Cargos,
		   SUM(CrAmt) AS Abonos,
		   MAX(PerPost) AS Perpost,
		   sum((DrAmt-CrAmt)) as Diferencia
FROM       dbo.GLTran WITH (nolock)  
WHERE     (Sub LIKE 'PEENGR%' or Sub LIKE 'PE0000%') 
AND (Acct IN('11320810','11329011'))
AND (Posted = 'P') 
AND (CpnyID = 'AGQ')
AND TranDate BETWEEN (select fecha1 from nucuenta1132) AND (select fecha2 from nucuenta1132)
GROUP BY   ProjectID, Sub, Acct, TaskID
union
SELECT     
          'Servicio telef y otros admtvos'as Concepto,
           Acct, 
           Sub, 
		   ProjectID,
		   TaskID, 
		   SUM(DrAmt) AS Cargos,
		   SUM(CrAmt) AS Abonos,
		   MAX(PerPost) AS Perpost,
		   sum((DrAmt-CrAmt)) as Diferencia
FROM       dbo.GLTran WITH (nolock)  
WHERE     (Sub LIKE 'PEENGR%' or Sub LIKE 'PE0000%') 
AND (Acct IN(
'11320413',	
'11320411',	
'11320402','11329011'))
AND (Posted = 'P') 
AND (CpnyID = 'AGQ')
AND TranDate BETWEEN (select fecha1 from nucuenta1132) AND (select fecha2 from nucuenta1132)
GROUP BY   ProjectID, Sub, Acct, TaskID
union
SELECT     
          'Servicio telef y otros admtvos'as Concepto,
           Acct, 
           Sub, 
		   ProjectID,
		   TaskID, 
		   SUM(DrAmt) AS Cargos,
		   SUM(CrAmt) AS Abonos,
		   MAX(PerPost) AS Perpost,
		   sum((DrAmt-CrAmt)) as Diferencia
FROM       dbo.GLTran WITH (nolock)  
WHERE    (Sub LIKE 'PEENGR%' or Sub LIKE 'PE0000%') 
AND (Acct IN(
'11320413',	
'11320411',	
'11320402','11329012'))
AND (Posted = 'P') 
AND (CpnyID = 'AGQ')
AND TranDate BETWEEN (select fecha1 from nucuenta1132) AND (select fecha2 from nucuenta1132)
GROUP BY   ProjectID, Sub, Acct, TaskID
union
SELECT     
          'Amortizacion gastos diferidos'as Concepto,
           Acct, 
           Sub, 
		   ProjectID,
		   TaskID, 
		   SUM(DrAmt) AS Cargos,
		   SUM(CrAmt) AS Abonos,
		   MAX(PerPost) AS Perpost,
		   sum((DrAmt-CrAmt)) as Diferencia
FROM       dbo.GLTran WITH (nolock)  
WHERE     (Sub LIKE 'PEENGR%' or Sub LIKE 'PE0000%') 
AND (Acct IN(
'11320437',	
'11320435','11329014'))
AND (Posted = 'P') 
AND (CpnyID = 'AGQ')
AND TranDate BETWEEN (select fecha1 from nucuenta1132) AND (select fecha2 from nucuenta1132)
GROUP BY   ProjectID, Sub, Acct, TaskID
union
SELECT     
          'Costo fletes MP'as Concepto,
           Acct, 
           Sub, 
		   ProjectID,
		   TaskID, 
		   SUM(DrAmt) AS Cargos,
		   SUM(CrAmt) AS Abonos,
		   MAX(PerPost) AS Perpost,
		   sum((DrAmt-CrAmt)) as Diferencia
FROM       dbo.GLTran WITH (nolock)  
WHERE     (Sub LIKE 'PEENGR%' or Sub LIKE 'PE0000%') 
AND (Acct IN(
'11320420',	
'11320421','11329015'))
AND (Posted = 'P') 
AND (CpnyID = 'AGQ')
AND TranDate BETWEEN (select fecha1 from nucuenta1132) AND (select fecha2 from nucuenta1132)
GROUP BY   ProjectID, Sub, Acct, TaskID








