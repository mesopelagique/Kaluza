var $file; $result : Object
$file:=Folder:C1567(fk database folder:K87:14).file("component.json")
If ($file.exists)
	$result:=cs:C1710.Kaluza.new($file).installDependencies()
	ASSERT:C1129($result.success)
End if 