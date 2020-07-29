 
DECLARE @proyecto varchar(25) =''

delete from nupeReporteMasterHeader  where  ProyectID =@proyecto
delete  from nupeCostCasCerr  where  Proyecto  =@proyecto

  
DECLARE nupeCurLlenadoModulo CURSOR FOR  
select  @proyecto

OPEN nupeCurLlenadoModulo     
FETCH NEXT FROM nupeCurLlenadoModulo      
INTO  @proyecto    
  
WHILE @@FETCH_STATUS = 0    
BEGIN   
     ----------------------------------------------------------------------
     -- LLena el Heder del Reporte Mestros Version Ootimizada 
	 ----------------------------------------------------------------------

	  exec REPORTEMAESTROPESINFACTORES  @proyecto   
      exec EncabezadoReporteMaestroPE  @proyecto   
	 -- exec REPORTEMAESTROPE  @proyecto    
    
	 update nupeContCasHdr  
     set S4Future03 = 3
     WHERE ProyectoVigente=@proyecto  	
	

 FETCH NEXT FROM nupeCurLlenadoModulo     
    INTO @proyecto     
END   
   
CLOSE nupeCurLlenadoModulo;    
DEALLOCATE nupeCurLlenadoModulo; 

/*Ajustes de importe trans no contempladas*/
select *  from nupeCostCasCerr where Proyecto='PE202003CG0207' and Grupo like '8%' and Importe>6






