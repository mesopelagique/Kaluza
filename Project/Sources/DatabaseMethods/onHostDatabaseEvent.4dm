  // On Host Database Event database method
C_LONGINT:C283($1)
Case of 
	: ($1=On before host database startup:K74:3)
		C_OBJECT:C1216($file;$result)
		$file:=Folder:C1567(fk database folder:K87:14;*).file("component.json")
		If ($file.exists)
			$result:=cs:C1710.Kaluza.new($file).installDependencies()  // XXX maybe if hasInstalled request database restart
		End if 
		
End case 