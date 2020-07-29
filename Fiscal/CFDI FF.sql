CREATE PROCEDURE nuspFF_CFDI33_Tr @FolioFactura AS VARCHAR(10)
AS
--DECLARE @FolioFactura AS VARCHAR(10) = 'OS00049728'
--DECLARAMOS VARIABLES PARA AGREGAR LOS CONCEPTOS DE LA FACTURA
DECLARE @Cadena VARCHAR(MAX)
SELECT @Cadena = '<Conceptos>'+ CHAR(13) + CHAR(10)

--DECLARAMOS TABLA TEMPORAL PARA GUARDAR LOS CONCEPTOS DE LA FACTURA
DECLARE @T_Conceptos TABLE (
	  ID INT IDENTITY,
	  ClaveArticulo VARCHAR(10), 
	  Cantidad FLOAT, 
	  Unidad VARCHAR(10),
	  Concepto_Factura VARCHAR(100),
	  PrecioUnitario NUMERIC(14,2),
	  ImportePartida NUMERIC(14,2), 
	  Base NUMERIC(14,2),
	  Impuesto VARCHAR(3),
	  TipoFactor VARCHAR(10),
	  TasaCuota NUMERIC(14,6),
	  ImporteImpuesto NUMERIC(14,2)
)

--INSERTAMOS VALORES EN LA TABLA TEMPORAL
INSERT INTO @T_Conceptos
SELECT RIGHT( LTRIM(RTRIM( A.TranDesc)), 7) as Articulo, 
qty AS Cantidad,
unitdesc AS Unidad,
A.TranDesc AS Descripcion,
A.UnitPrice AS PrecioUnitario, 
A.tranamt AS Importe, 
A.tranamt AS base, 
'002' AS Impuesto, 
'Tasa' AS TipoFactor,
ROUND(A.TaxAmt00/A.tranamt,2) AS TasaCuota, 
A.TaxAmt00 AS ImporteImpuesto 
FROM ARTran A
WHERE A.RefNbr = @FolioFactura and Crtd_Prog = '08010' AND A.UnitPrice <> 0

--DECLARAMOS CICLO PARA LEER LOS CONCEPTOS DE LA FACTURA Y AGREGARLOS A LA VARIABLE DE CONCEPTOS
DECLARE @X INT
DECLARE @Y INT
    
SET @X = 1
SELECT @Y = MAX(ID) FROM @T_Conceptos
    
WHILE @X <= @Y
BEGIN
	SELECT @Cadena=@Cadena + 'P'+ RIGHT('0' + CONVERT(VARCHAR,Id),2) + '_ClaveProdServ=73151602' + CHAR(13) + CHAR(10) + 
	'P'+ RIGHT('0' + CONVERT(VARCHAR,Id),2) +'_NoIdentificacion=' + CHAR(13) + CHAR(10) + 
	'P'+ RIGHT('0' + CONVERT(VARCHAR,Id),2) +'_Cantidad=' + ISNULL(CONVERT(VARCHAR,Cantidad),'') + + CHAR(13) + CHAR(10) + 
	'P'+ RIGHT('0' + CONVERT(VARCHAR,Id),2) +'_ClaveUnidad=EA' + CHAR(13) + CHAR(10) + 
	'P'+ RIGHT('0' + CONVERT(VARCHAR,Id),2) +'_Unidad='+ Unidad + CHAR(13) + CHAR(10) + 
	'P'+ RIGHT('0' + CONVERT(VARCHAR,Id),2) +'_Descripcion=' + ISNULL(CONVERT(VARCHAR(200),Concepto_Factura),'') + CHAR(13) + CHAR(10) + 
	'P'+ RIGHT('0' + CONVERT(VARCHAR,Id),2) +'_ValorUnitario='+ ISNULL(CONVERT(VARCHAR,CAST(PrecioUnitario AS MONEY),1),'') + CHAR(13) + CHAR(10) + 
	'P'+ RIGHT('0' + CONVERT(VARCHAR,Id),2) +'_Descuento=0.00' + CHAR(13) + CHAR(10) + 
	'P'+ RIGHT('0' + CONVERT(VARCHAR,Id),2) +'_Importe=' + ISNULL(CONVERT(VARCHAR,CAST(ImportePartida AS MONEY),1),'') + CHAR(13) + CHAR(10) + 
	'//Impuestos Trasladados (IT)' + CHAR(13) + CHAR(10) + 
	'P'+ RIGHT('0' + CONVERT(VARCHAR,Id),2) +'_ITBase='+ CONVERT(VARCHAR,CAST(Base AS MONEY),1) + CHAR(13) + CHAR(10) + 
	'P'+ RIGHT('0' + CONVERT(VARCHAR,Id),2) +'_ITImpuesto='+ CONVERT(VARCHAR,Impuesto) + CHAR(13) + CHAR(10) + 
	'P'+ RIGHT('0' + CONVERT(VARCHAR,Id),2) +'_ITTipoFactor='+ CONVERT(VARCHAR,TipoFactor) + CHAR(13) + CHAR(10) + 
	'P'+ RIGHT('0' + CONVERT(VARCHAR,Id),2) +'_ITTasaoCuota='+ CONVERT(VARCHAR,TasaCuota) + CHAR(13) + CHAR(10) + 
	'P'+ RIGHT('0' + CONVERT(VARCHAR,Id),2) +'_ITImporte='+CONVERT(VARCHAR,CAST(ImporteImpuesto AS MONEY),1) + CHAR(13) + CHAR(10) 
	FROM @T_Conceptos
	WHERE ID=@X
	SET @X = @X + 1
END

SET @Cadena=@Cadena + '</Conceptos>' + CHAR(13) + CHAR(10)

--DECLARAMOS LAS VARIABLES Y LLAMAMOS EL PROCEDIMIENTO ALMACENADO QUE CAMBIA EL NUMERO A LETRA
DECLARE @TotalLetra AS VARCHAR(100)
DECLARE @Total AS NUMERIC(14,2)
SET @Total = (SELECT OrigDocAmt FROM ARDoc WHERE DocType='IN' AND RefNbr=@FolioFactura)
EXEC sp_Dinero_a_Texto @Total,@TotalLetra OUTPUT

--GENERAMOS EL SELECT PARA LLENAR EL ARCHIVO .FF CON LOS DATOS DE LA FACTURA CON LA SINTAXIS CORRESPONDIENTE 
--DEL ARCHIVO .FF
SELECT

(SELECT '<Factura>'+ CHAR(13) + CHAR(10) + CHAR(13) + CHAR(10) + 
'<Comprobante>' + CHAR(13) + CHAR(10) + 
'Serie='+ ISNULL(FSS.Serie,'') + CHAR(13) + CHAR(10) + 
'Folio='+ ISNULL(CONVERT(VARCHAR,(SELECT sigfolio + 1  FROM feSetupSeriesCFDI33 
		WHERE Status='TRANS')),'') + CHAR(13) + CHAR(10) + 
'Fecha='+ ISNULL(LEFT(CAST(CONVERT(VARCHAR(19), SYSDATETIME(), 120) as VARCHAR(50)),10) +'T'+
         RIGHT(CAST(CONVERT(VARCHAR(19), SYSDATETIME(), 120) as VARCHAR(50)),8),'') + CHAR(13) + CHAR(10) +
'FormaPago='+ 
CASE
	WHEN ISNULL(REPLACE(NCE.s4future12,'NA','99'),'99') ='' THEN '99'
	ELSE ISNULL(REPLACE(NCE.s4future12,'NA','99'),'99')  
END	+ CHAR(13) + CHAR(10) +
'FormaPagoLeyenda='+ ISNULL(
	CASE 
		WHEN ISNULL(REPLACE(NCE.s4future12,'NA','99'),'99') ='' THEN 'POR DEFINIR'
		ELSE (SELECT Descripcion from CFDI33FormaPago WHERE ClveFormaPago=NCE.s4future12) 
	END
,'POR DEFINIR') + CHAR(13) + CHAR(10) +
'CondicionesDePago='+ ISNULL((SELECT Descr from Terms where TermsId =C.terms),'') + CHAR(13) + CHAR(10) +
'SubTotal='+ CONVERT(VARCHAR,CONVERT(MONEY,(ARD.OrigDocAmt - dbo.FE_IVA (ARD.BatNbr,@FolioFactura))),1) + CHAR(13) + CHAR(10) +
'Descuento=0.00'+ CHAR(13) + CHAR(10) +
'IVA='+ CONVERT(VARCHAR,CONVERT(MONEY,dbo.FE_IVA (ARD.BatNbr,@FolioFactura),1)) + CHAR(13) + CHAR(10) +
'Total='+ ISNULL(CONVERT(VARCHAR,CONVERT(MONEY, OrigDocAmt),1),'') + CHAR(13) + CHAR(10) +
'Moneda='+ ISNULL(CASE 
			WHEN ARD.CuryId = 'MN' THEN 'MXN' 	
			ELSE ARD.CURYID 
	   END,'') + CHAR(13) + CHAR(10) +
'TipoCambio='+ ISNULL(CAST(ARD.CuryRate  AS VARCHAR(20)),'') + CHAR(13) + CHAR(10) +
'TipoDeComprobante=I'+ CHAR(13) + CHAR(10) +
'TipoDeComprobanteLeyenda=Ingreso'+ CHAR(13) + CHAR(10) +
'tituloDocumento=FACTURA'+ CHAR(13) + CHAR(10) +
'MetodoPago='+(
	SELECT CASE 
		WHEN  TermsId = '00' THEN 'PUE' 
		WHEN  TermsId <> '00' THEN 'PPD'
	END FROM Terms WHERE TermsId=C.terms) + CHAR(13) + CHAR(10) +
'MetodoPagoLeyenda='+(
	SELECT CASE
		WHEN  TermsId = '00' THEN 'Pago en una sola exhibición' 
		WHEN  TermsId <> '00' THEN 'Pago en parcialidades o diferido'  
	END FROM Terms WHERE TermsId=C.terms) + CHAR(13) + CHAR(10) +
'LugarExpedicion=20138'+ CHAR(13) + CHAR(10) +
'</Comprobante>'+ CHAR(13) + CHAR(10)
FROM feSetupSeries FSS WHERE Status = 'TRANS') AS Comprobante,

'<Emisor>'+ CHAR(13) + CHAR(10) + 
'eRfc=RFC' + CHAR(13) + CHAR(10) +
--'eRfc=TCM970625MB1' + CHAR(13) + CHAR(10) +
'enombre=RAZON SOCIAL'+ CHAR(13) + CHAR(10) + 
'RegimenFiscal=622'+ CHAR(13) + CHAR(10) + 
'---Datos Opcionales---'+ CHAR(13) + CHAR(10) + 
'ecalle=CALLE'+ CHAR(13) + CHAR(10) + 
'enoExterior=600 2o PISO'+ CHAR(13) + CHAR(10) + 
'enoInterior='+ CHAR(13) + CHAR(10) + 
'ecolonia=COLONIA'+ CHAR(13) + CHAR(10) + 
'elocalidad=LOCALIDAD'+ CHAR(13) + CHAR(10) + 
'ereferencia='+ CHAR(13) + CHAR(10) + 
'emunicipio=MUNICIPIO'+ CHAR(13) + CHAR(10) + 
'eestado=ESTADO'+ CHAR(13) + CHAR(10) + 
'epais=MEXICO'+ CHAR(13) + CHAR(10) + 
'ecodigoPostal=20138'+ CHAR(13) + CHAR(10) + 
'etel=(449)910 90 90'+ CHAR(13) + CHAR(10) + 
'eemail='+ CHAR(13) + CHAR(10) + 
'</Emisor>' + CHAR(13) + CHAR(10) 
AS Emisor,

CASE 
	WHEN NCE.S4Future11 ='B' THEN 
		'<Receptor>' + CHAR(13) + CHAR(10) + 
		'Rfc=XAXX010101000' + CHAR(13) + CHAR(10) +       
		'Nombre=' + ISNULL(LTRIM(RTRIM(C.Name)),'') + CHAR(13) + CHAR(10) + 
		'UsoCFDI='+ 
		CASE
			WHEN ISNULL((RTRIM(LTRIM(NCE.User24))),'')='' THEN 'G01'
			ELSE ISNULL((RTRIM(LTRIM(NCE.User24))),'G01')
		END + CHAR(13) + CHAR(10) + 
		'UsoCFDILeyenda=' + ISNULL(
		CASE 
			WHEN LTRIM(RTRIM(NCE.User24))='G01' THEN 'Adquisición de mercancias'
			WHEN LTRIM(RTRIM(NCE.User24))='G02' THEN 'Devoluciones, descuentos o bonificaciones'
			WHEN LTRIM(RTRIM(NCE.User24))='G03' THEN 'Gastos en general'
		END,'Adquisición de mercancias') + CHAR(13) + CHAR(10) + 
		'calle='+ ISNULL(C.billaddr1,'') + CHAR(13) + CHAR(10) + 
		'noExterior='+ CHAR(13) + CHAR(10) + 
		'noInterior='+ CHAR(13) + CHAR(10) + 
		'colonia='+ ISNULL(C.billaddr2,'') + CHAR(13) + CHAR(10) + 
		'localidad='+ CHAR(13) + CHAR(10) + 
		'municipio='+ ISNULL(C.BillCity,'') + CHAR(13) + CHAR(10) + 
		'estado='+ ISNULL(C.BillState,'') + CHAR(13) + CHAR(10) + 
		'pais='+ ISNULL((SELECT descr FROM Country WHERE CountryID=C.BillCountry),'') + CHAR(13) + CHAR(10) + 
		'codigoPostal='+ ISNULL(C.BillZip,'') + CHAR(13) + CHAR(10) + 
		'tel='+ ISNULL(C.Phone,'') + CHAR(13) + CHAR(10) + 
		'email='+ ISNULL(NCE.user25,'') + CHAR(13) + CHAR(10) + 
		'</Receptor>' + CHAR(13) + CHAR(10)
	WHEN NCE.S4Future11='C' THEN
		'<Receptor>' + CHAR(13) + CHAR(10) + 	
		'Rfc=XAXX010101000' + CHAR(13) + CHAR(10) +      
		'Nombre=PUBLICO EN GENERAL'+ CHAR(13) + CHAR(10) + 
		'UsoCFDI=G01'+ CHAR(13) + CHAR(10) + 
		'UsoCFDILeyenda=Adquisición de mercancias' + CHAR(13) + CHAR(10) + 
		'calle=CALLE'+ CHAR(13) + CHAR(10) + 
		'noExterior=' + CHAR(13) + CHAR(10) + 
		'noInterior=' + CHAR(13) + CHAR(10) + 
		'colonia=COLONIA' + CHAR(13) + CHAR(10) + 
		'localidad=' + CHAR(13) + CHAR(10) + 
		'municipio=ESTADO' + CHAR(13) + CHAR(10) + 
		'estado=ESTADO' + CHAR(13) + CHAR(10) + 
		'pais=MEXICO' + CHAR(13) + CHAR(10) + 
		'codigoPostal=20135' + CHAR(13) + CHAR(10) + 
		'tel=' + CHAR(13) + CHAR(10) + 
		'email='+ CHAR(13) + CHAR(10) + 
		'</Receptor>' + CHAR(13) + CHAR(10) 
	ELSE
		'<Receptor>'+ CHAR(13) + CHAR(10) + 
		'Rfc='+ 
		CASE 
			WHEN C.Name='VENTAS CONTADO' THEN 'XAXX010101000'
			WHEN REPLACE(REPLACE(C.user1,' ',''),'-','')='' THEN 'XAXX010101000'
			ELSE REPLACE(REPLACE(C.user1,' ',''),'-','')
		END + CHAR(13) + CHAR(10) + 
		'Nombre='+ ISNULL(C.Name,'') + CHAR(13) + CHAR(10) + 
		'UsoCFDI='+ 
		CASE
			WHEN ISNULL((RTRIM(LTRIM(NCE.User24))),'')='' THEN 'G01'
			ELSE ISNULL((RTRIM(LTRIM(NCE.User24))),'G01')
		END + CHAR(13) + CHAR(10) + 
		'UsoCFDILeyenda=' + ISNULL(
		CASE 
			WHEN LTRIM(RTRIM(NCE.User24))='G01' THEN 'Adquisición de mercancias'
			WHEN LTRIM(RTRIM(NCE.User24))='G02' THEN 'Devoluciones, descuentos o bonificaciones'
			WHEN LTRIM(RTRIM(NCE.User24))='G03' THEN 'Gastos en general'
		END,'Adquisición de mercancias') + CHAR(13) + CHAR(10) + 
		'---Datos Opcionales---'+ CHAR(13) + CHAR(10) + 
		'calle='+ ISNULL(C.billaddr1,'') + CHAR(13) + CHAR(10) + 
		'noExterior='+ CHAR(13) + CHAR(10) + 
		'noInterior='+ CHAR(13) + CHAR(10) + 
		'colonia='+ ISNULL(C.billaddr2,'') + CHAR(13) + CHAR(10) + 
		'localidad='+ CHAR(13) + CHAR(10) + 
		'municipio='+ ISNULL(C.BillCity,'') + CHAR(13) + CHAR(10) + 
		'estado='+ ISNULL(C.BillState,'') + CHAR(13) + CHAR(10) + 
		'pais='+ ISNULL((SELECT descr FROM Country WHERE CountryID=C.BillCountry),'') + CHAR(13) + CHAR(10) + 
		'codigoPostal='+ ISNULL(C.BillZip,'') + CHAR(13) + CHAR(10) + 
		'tel='+ ISNULL(C.Phone,'') + CHAR(13) + CHAR(10) + 
		'email='+ ISNULL(NCE.user25,'') + CHAR(13) + CHAR(10) + 
		'</Receptor>' + CHAR(13) + CHAR(10)
END AS Receptor,

@Cadena AS Conceptos,

'<Impuestos>'+ CHAR(13) + CHAR(10) + 
'TotalImpuestosRetenidos=0.00'+ CHAR(13) + CHAR(10) + 
'TotalImpuestosTrasladados='+ CONVERT(VARCHAR,CONVERT(MONEY,dbo.FE_IVA (ARD.BatNbr,@FolioFactura)),1) + CHAR(13) + CHAR(10) +
'<trasladados>'+ CHAR(13) + CHAR(10) + 
'ImpTrasladado1_Impuesto=002'+ CHAR(13) + CHAR(10) + 
'ImpTrasladado1_TipoFactor=Tasa'+ CHAR(13) + CHAR(10) + 
'ImpTrasladado1_TasaOCuota='+ 
	CASE 
		WHEN CONVERT(VARCHAR,(
		SELECT CONVERT (NUMERIC(14,6),(ROUND( 
		dbo.FE_IVA (ARD.BatNbr,@FolioFactura) /(ARD.OrigDocAmt - (dbo.FE_IVA (ARD.BatNbr,@FolioFactura)))
		,2))))) >= '0.01' THEN 
			CONVERT(VARCHAR,CONVERT(NUMERIC(14,6),0.16))
		WHEN CONVERT(VARCHAR,(
		SELECT CONVERT (NUMERIC(14,6),(ROUND( 
		dbo.FE_IVA (ARD.BatNbr,@FolioFactura) /(ARD.OrigDocAmt - (dbo.FE_IVA (ARD.BatNbr,@FolioFactura)))
		,2))))) = '0' THEN 
			CONVERT(VARCHAR,CONVERT(NUMERIC(14,6),0.00))
		ELSE CONVERT(VARCHAR,(
		SELECT CONVERT (NUMERIC(14,6),(ROUND( 
		dbo.FE_IVA (ARD.BatNbr,@FolioFactura) /(ARD.OrigDocAmt - (dbo.FE_IVA (ARD.BatNbr,@FolioFactura)))
		,2))))) 
	END + CHAR(13) + CHAR(10) + 
'ImpTrasladado1_Importe='+ CONVERT(VARCHAR,CONVERT(MONEY,dbo.FE_IVA (ARD.BatNbr,@FolioFactura)),1) + CHAR(13) + CHAR(10) + 
'</trasladados>' + CHAR(13) + CHAR(10) + 
'</Impuestos>'+ CHAR(13) + CHAR(10)
AS Impuestos,


'<Otros>'+ CHAR(13) + CHAR(10) + 
'cant_letra=***' + REPLACE(@TotalLetra,RIGHT(@TotalLetra,2),'') +' '+ RIGHT(@TotalLetra,2)+'/100 M.N. ***'+ CHAR(13) + CHAR(10) + 
'observaciones= '+ CHAR(13) + CHAR(10) +
'tipoimpresion=0'+ CHAR(13) + CHAR(10) +
'formato=ESTANDAR_33.RAV' + CHAR(13) + CHAR(10) + 
'expedicion' + CHAR(13) + CHAR(10) + 
'expedicion=ciudad, Ags.'  + CHAR(13) + CHAR(10) +                                                                                                                                                                                           
'Nutry='  + CHAR(13) + CHAR(10) + 
'formato=ESTANDAR_33.RAV' + CHAR(13) + CHAR(10) + 					
'Corta=0'+ CHAR(13) + CHAR(10) + 
'Otros=0' + CHAR(13) + CHAR(10) + 
'Bolsa=' + CHAR(13) + CHAR(10) + 
'</Otros>'+ CHAR(13) + CHAR(10) + 
'</Factura>' AS Otros
FROM 
ARDoc ARD
INNER JOIN Customer C ON C.CustId=ARD.CustId
INNER JOIN nuCustomerExt NCE ON NCE.CustId=C.CustId
WHERE ARD.DocType= 'IN' AND ARD.RefNbr LIKE @FolioFactura

