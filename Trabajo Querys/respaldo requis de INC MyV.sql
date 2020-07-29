SELECT D.* INTO RESPALDOINC

SELECT D.S4Future01
--UPDATE D set  D.S4Future01 =''
FROM nurqReqHdr H inner join  nurqReqDet D on D.BatNbr=H.BatNbr where  H.DivSolic='INC' AND D.S4Future01='2219'
--AND H.BatNbr='0000090019'
