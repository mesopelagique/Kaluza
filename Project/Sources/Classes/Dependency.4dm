
Class extends Object

Function install()
	C_OBJECT:C1216($0)
	$0:=install_github (This:C1470.path;This:C1470.parent.options)
	
Function user()
	C_TEXT:C284($0)
	$0:=Split string:C1554(This:C1470.path;"/")[0]
	
Function repository()
	C_TEXT:C284($0)
	$0:=Split string:C1554(This:C1470.path;"/")[1]
	
Function isInstalled()
	C_BOOLEAN:C305($0)
	$componentsFolder:=Folder:C1567(fk database folder:K87:14).folder("Components")
	Case of 
		: ($componentsFolder.file(This:C1470.repository()+".4DZ").exists)
			$0:=True:C214
		: ($componentsFolder.folder(This:C1470.repository()+".4dbase").exists)
			$0:=True:C214
		Else 
			$0:=False:C215
	End case 
	
/*
	
Function outdated()
$0:=False
	
*/