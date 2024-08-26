
-----------------create get sp----
alter procedure SP_GetClientsById 
@Id int=0
as begin
select Id,Name_En,Image from Clients   WHERE (@Id = 0 OR Id = @Id)  AND IsActive=1
end;

exec SP_GetClientsById 0
select * from Clients
--------------create sp fro create update and delete--------

alter procedure SP_AddUpdateHomePageClients       
@Id int=0,
@Name_En nvarchar(100)=null,
@Image nvarchar(max)= null,
 @FlagId INT
as begin
  IF @FlagId = 1 
    BEGIN                
        IF NOT EXISTS (SELECT 1 FROM Clients WHERE Name_en = @Name_en AND IsActive = 1)  
        BEGIN  
            
            INSERT INTO Clients (Name_En, Image, IsActive)                
            VALUES (@Name_En, @Image, 1);
			 SELECT 'Clients  Inserted Successfully' AS message, 1 AS Status;     
  END  
  ELSE  
  BEGIN  
   SELECT 'Already Client name exists!' AS message, 0 AS Status;   
  END  
    END    
	 ELSE IF @FlagId = 2                
    BEGIN       
 if not exists (Select 1 from Clients Where Name_en=@Name_En and Image=@Image and IsActive=1)  
 BEGIN  
           
    
       UPDATE Clients---update
	   set 
	   Name_en=@Name_En,
	    Image = (CASE WHEN  @Image IS NOT NULL AND @Image != '' THEN @Image ELSE Image END )
	   where Id=@Id;

    
        SELECT 'Updated Successfully' AS message, 1 AS Status;     
  END  
  ELSE  
  BEGIN  
  SELECT 'Duplicate record!' AS message, 0 AS Status;    
  END  
    END   
	ELSE IF @FlagId = 3    
	BEGIN                
    IF exists (Select 1 from Clients Where IsActive=1 and Id!=@Id)  
    BEGIN
	UPDATE Clients----delete
	set
	 
	 
	 IsActive=0
	WHERE Id=@Id;
	SELECT 'Deleted Successfully' AS message, 1 AS Status;     
	END
	ELSE
	BEGIN
	SELECT 'Cannot be deleted. At least one Client should be available.' AS message, 0 AS Status; 
	END
	END
END; 
---------------retreive the sdetails-------------------
select * from Clients
-----------------------------execute insert details----------------------
EXEC SP_AddUpdateHomePageClients
    @Name_En = 'xyz',
    @Image = '1110mahal.png',
    @FlagId = 1;
	-------------------------------execute update details----------------
	EXEC SP_AddUpdateHomePageClients
    @Name_En = 'abaa',
    @Image = '',
    @FlagId = 2,
    @Id = 11;  
	------------------execute delete----------------------
	EXEC SP_AddUpdateHomePageClients
    @Id = 10,     
	  @Name_En = '',    
    @Image = '',  
            
    @FlagId = 3;         
	select * from Clients
	delete from clients where isactive=0

sp_helptext SP_AddUpdateHomePageClients
