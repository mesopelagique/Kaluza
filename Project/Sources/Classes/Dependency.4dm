
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
	
	var $remote : Text
	$remote:=This:C1470.remote
	Case of 
		: ($remote="github")
			return install_github(This:C1470.path; $options)
		Else 
			ASSERT:C1129(False:C215; "Install from remote type "+$remote+" with path "+String:C10(This:C1470.path)+" is not yet supported")
	End case 
	
Function get remote : Text
	Case of 
		: ((Position:C15("https://"; This:C1470.path)>0) || (Position:C15("http://"; This:C1470.path)>0))
			return "http"
		: ((Position:C15("git@"; This:C1470.path)>0))
			return "git"
		: (Split string:C1554(This:C1470.path; "/").length=2)
			return "github"
		: ((Position:C15("file://"; This:C1470.path)>0))  // XXX support only file:// or other file path?
			return "file"
		Else 
			return "invalid"
	End case 
	
	// If github return the username or organization
Function get user : Text
	If (This:C1470.remote="github")
		return Split string:C1554(This:C1470.path; "/")[0]
	Else 
		return ""
	End if 
	
	// Return a name for the repository according to provided path
Function get repository : Text
	If (This:C1470.remote="github")
		return Split string:C1554(This:C1470.path; "/")[1]
	Else 
		var $col : Collection
		$col:=Split string:C1554(This:C1470.path; "/")
		return Replace string:C233($col[$col.length-1]; ".git"; "")
	End if 
	
	// Return true if it seems installed by checking if <repository> .4dbase or .4DZ 
Function get isInstalled : Boolean
	var $componentsFolder : 4D:C1709.Folder
	$componentsFolder:=Folder:C1567(fk database folder:K87:14; *).folder("Components")
	return ($componentsFolder.file(This:C1470.repository+".4DZ").exists)\
		 || ($componentsFolder.folder(This:C1470.repository+".4dbase").exists)
	
Function get fileSystemPath : Object
	var $componentsFolder : 4D:C1709.Folder
	$componentsFolder:=Folder:C1567(fk database folder:K87:14; *).folder("Components")
	If ($componentsFolder.file(This:C1470.repository+".4DZ").exists)
		return $componentsFolder.file(This:C1470.repository+".4DZ")
	End if 
	If ($componentsFolder.file(This:C1470.repository+".4dbase").exists)
		return $componentsFolder.file(This:C1470.repository+".4dbase")
	End if 
	
Function uninstall()
	This:C1470.delete()
	
Function delete()
	var $componentsFolder : 4D:C1709.Folder
	$componentsFolder:=Folder:C1567(fk database folder:K87:14; *).folder("Components")
	
	If ($componentsFolder.file(This:C1470.repository+".4DZ").exists)
		$componentsFolder.file(This:C1470.repository+".4DZ").delete()
	End if 
	If ($componentsFolder.file(This:C1470.repository+".4dbase").exists)
		$componentsFolder.file(This:C1470.repository+".4dbase").delete(fk recursive:K87:7)
	End if 
	
/*
	
Function outdated()
$0:=False
	
*/