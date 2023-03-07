
Class extends Object

Function install($options : Object) : Object
	
	If (This:C1470.parent.options=Null:C1517)
		This:C1470.parent.options:=$options
	Else 
		var $key : Text
		For each ($key; ($options || New object:C1471()))
			This:C1470.parent.options[$key]:=$options[$key]  // override. XXX need a deep copy if option inside obj
		End for each 
	End if 
	
	return install_github(This:C1470.path; $options)
	
Function user() : Text
	return Split string:C1554(This:C1470.path; "/")[0]
	
Function repository() : Text
	return Split string:C1554(This:C1470.path; "/")[1]
	
Function isInstalled() : Boolean
	
	var $componentsFolder : 4D:C1709.Folder
	$componentsFolder:=Folder:C1567(fk database folder:K87:14).folder("Components")
	Case of 
		: ($componentsFolder.file(This:C1470.repository()+".4DZ").exists)
			return True:C214
		: ($componentsFolder.folder(This:C1470.repository()+".4dbase").exists)
			return True:C214
		Else 
			return False:C215
	End case 
	
/*
	
Function outdated()
$0:=False
	
*/