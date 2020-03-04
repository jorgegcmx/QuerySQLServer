
CREATE VIEW view_reporte1132 AS
SELECT    'DIESEL' as Concepto,
           Acct, 
           Sub, 
		   ProjectID,
		   TaskID, 
		   SUM(DrAmt) AS Cargos,
		   SUM(CrAmt) AS Abonos,
		   MAX(PerPost) AS Perpost
FROM       dbo.GLTran WITH (nolock)  
WHERE     (Sub LIKE 'PEENGR%') 
AND (Acct IN('11320325','11329005'))
AND (Posted = 'P') 
AND (CpnyID = 'AGQ') 
AND TranDate BETWEEN '20200220' AND '20200303'
GROUP BY   ProjectID, Sub, Acct, TaskID
union
SELECT     
          'GASOLINA'as Concepto,
           Acct, 
           Sub, 
		   ProjectID,
		   TaskID, 
		   SUM(DrAmt) AS Cargos,
		   SUM(CrAmt) AS Abonos,
		   MAX(PerPost) AS Perpost
FROM       dbo.GLTran WITH (nolock)  
WHERE     (Sub LIKE 'PEENGR%') 
AND (Acct IN('11320329','11329004'))
AND (Posted = 'P') 
AND (CpnyID = 'AGQ')
AND TranDate BETWEEN '20200220' AND '20200303'
GROUP BY   ProjectID, Sub, Acct, TaskID
union
SELECT     
          'ENERGIA ELECTRICA'as Concepto,
           Acct, 
           Sub, 
		   ProjectID,
		   TaskID, 
		   SUM(DrAmt) AS Cargos,
		   SUM(CrAmt) AS Abonos,
		   MAX(PerPost) AS Perpost
FROM       dbo.GLTran WITH (nolock)  
WHERE     (Sub LIKE 'PEENGR%') 
AND (Acct IN('11320401','11329002'))
AND (Posted = 'P') 
AND (CpnyID = 'AGQ')
AND TranDate BETWEEN '20200220' AND '20200303'
GROUP BY   ProjectID, Sub, Acct, TaskID
union
SELECT     
          'ARRENDAMIENTO DE TERRENOS'as Concepto,
           Acct, 
           Sub, 
		   ProjectID,
		   TaskID, 
		   SUM(DrAmt) AS Cargos,
		   SUM(CrAmt) AS Abonos,
		   MAX(PerPost) AS Perpost
FROM       dbo.GLTran WITH (nolock)  
WHERE     (Sub LIKE 'PEENGR%') 
AND (Acct IN('11320406','11329003'))
AND (Posted = 'P') 
AND (CpnyID = 'AGQ')
AND TranDate BETWEEN '20200220' AND '20200303'
GROUP BY   ProjectID, Sub, Acct, TaskID
union
SELECT     
          'DEPRESIACION'as Concepto,
           Acct, 
           Sub, 
		   ProjectID,
		   TaskID, 
		   SUM(DrAmt) AS Cargos,
		   SUM(CrAmt) AS Abonos,
		   MAX(PerPost) AS Perpost
FROM       dbo.GLTran WITH (nolock)  
WHERE     (Sub LIKE 'PEENGR%') 
AND (Acct IN('11320701','11329013'))
AND (Posted = 'P') 
AND (CpnyID = 'AGQ')
AND TranDate BETWEEN '20200220' AND '20200303'
GROUP BY   ProjectID, Sub, Acct, TaskID

