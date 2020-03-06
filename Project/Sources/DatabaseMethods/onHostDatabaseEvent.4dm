  // On Host Database Event database method
C_LONGINT:C283($1)
Case of 
	: ($1=On before host database startup:K74:3)
		
		$file:=Folder:C1567(fk database folder:K87:14).file("component.json")
		If ($file.exists)
			cs:C1710.Kaluza.new($file).installDependencies(New object:C1471("missing";True:C214))
			
		End if 
		
End case 