//%attributes = {"shared":true,"preemptive":"capable"}
#DECLARE($path : Text; $options : Object)->$result : Object


If (Count parameters:C259=0)
	ABORT:C156
End if 

If ($options=Null:C1517)
	$options:=New object:C1471()
End if 
// default options
If ($options.binary=Null:C1517)
	$options.binary:=True:C214
End if 

// result object
$result:=New object:C1471("success"; False:C215)
$result.path:=$path

// Check components dst folder
var $componentsFolder; $outputFile : Object
$componentsFolder:=Folder:C1567(fk database folder:K87:14).folder("Components")

If (Not:C34($componentsFolder.exists))
	$componentsFolder.create()
End if 

// Check options to get path and url
Case of 
	: ($options.version=Null:C1517)
		$result.latest:=True:C214
	: (String:C10($options.version)="latest")
		$result.latest:=True:C214
	Else 
		$result.latest:=False:C215
End case 

If (Position:C15("https://github.com/"; $result.path)=0)
	$result.url:="https://github.com/"+$result.path
Else 
	$result.url:=$result.path
	$result.path:=Replace string:C233($result.path; "https://github.com/"; "")
End if 

var $urlPaths : Collection
$urlPaths:=Split string:C1554($result.path; "/")
$result.user:=$urlPaths[0]
$result.repository:=$urlPaths[1]
/*
$componentsFolder:=$componentsFolder.folder("@"+$result.user)
If (Not($componentsFolder.exists))
$componentsFolder.create()
End if  // subfolders not supported, to optimize 4d could support subfolder with "@" as prefix like npm
*/
$result.path:=$result.user+"/"+$result.repository
$result.url:="https://github.com/"+$result.path  // remove any fioriture

// Check if already installed

//If (Bool($options.skipInstalled))
var $dependency : cs:C1710.Dependency
$dependency:=cs:C1710.Dependency.new()
$dependency.path:=$result.path

If ($dependency.isInstalled)
	$result:=New object:C1471("success"; True:C214; "statusText"; "Already installed"; "hasInstalled"; False:C215)
End if 
//End if 

// Try with binary
If (Not:C34($result.success) & ($options.binary))
	
	var $binaryName; $binaryFormattedName : Text
	$binaryName:=$result.repository+".4DZ"
	$binaryFormattedName:=Replace string:C233($binaryName; " "; ".")
	
	If ($result.latest)
		$result.binaryURL:=$result.url+"/releases/latest/download/"+$binaryName
	Else 
		$result.binaryURL:=$result.url+"/releases/download/"+$options.version+"/"+$binaryName
	End if 
	
	var $content : Text
	var $response : Blob
	var $httpResult : Integer
	$httpResult:=HTTP Request:C1158(HTTP GET method:K71:1; $result.binaryURL; $content; $response)
	
	$outputFile:=$componentsFolder.file($binaryName)
	
	$result.success:=($httpResult=200)
	
	If ($result.success)  // success
		$result.binary:=True:C214
		$result.hasInstalled:=True:C214
		$outputFile.setContent($response)
	Else 
		$result.errors:=New collection:C1472(New object:C1471("code"; $httpResult; "message"; "Failed to download"))
	End if 
	
End if 

If (Not:C34($result.success))
	// Try with sources
	
	$outputFile:=Folder:C1567($componentsFolder.platformPath; fk platform path:K87:2).folder($result.repository+".4dbase")
	
	// If $outputFile.exists ??  -> error already installed? or nothing, just change version if version defined using tag
	
	// LAUNCH EXTERNAL PROCESS("git submodule add "+$result.url+".git Components/"+$result.repository+".4dbase")
	var $cmd; $in; $out; $err : Text
	$cmd:="git"
	If (Is Windows:C1573)
		$cmd:=$cmd+".exe"
	End if 
	
	var $submodule : Boolean
	$submodule:=Folder:C1567(fk database folder:K87:14; *).folder(".git").exists || Folder:C1567(fk database folder:K87:14; *).file(".git").exists
	If ($submodule)  // if already in git use submodule
		SET ENVIRONMENT VARIABLE:C812("_4D_OPTION_CURRENT_DIRECTORY"; Folder:C1567(fk database folder:K87:14; *).platformPath)
		$cmd:=$cmd+" submodule -q --force add "+$result.url+".git 'Components/"+$outputFile.fullName+"'"  // -q quiet to not output progress in stderr
	Else   // clone
		$cmd:=$cmd+" clone -q "+$result.url+".git '"+$outputFile.path+"'"  // -q quiet to not output progress in stderr
	End if 
	LAUNCH EXTERNAL PROCESS:C811($cmd; $in; $out; $err)
	
	
	If (Position:C15("already exists in the index"; $err)>0)  // clean: this code do not support localized message from github
		// do a reset of path (maybe just removed as submodule but not commited)
		
		// LAUNCH EXTERNAL PROCESS($cmd; $in; $out; $err)
	End if 
	
	
	If (Length:C16($err)>0)
		$result.errors:=New collection:C1472($err)
	Else 
		$result.git:=True:C214
		$result.submodule:=$submodule
		$result.hasInstalled:=True:C214
		$result.success:=True:C214
	End if 
	
End if 