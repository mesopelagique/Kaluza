//%attributes = {"shared":true,"preemptive":"capable"}
C_OBJECT:C1216($0;$result)
C_TEXT:C284($1)
C_OBJECT:C1216($2;$options)

If (Count parameters:C259=0)
	ABORT:C156
End if 
If (Count parameters:C259>1)
	$options:=$2
Else 
	$options:=New object:C1471()
End if 

  // default options
If ($options.binary=Null:C1517)
	$options.binary:=True:C214
End if 

  // result object
$result:=New object:C1471("success";False:C215)
$result.path:=$1

  // Check components dst folder
C_OBJECT:C1216($componentsFolder;$outputFile)
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

If (Position:C15("https://github.com/";$result.path)=0)
	$result.url:="https://github.com/"+$result.path
Else 
	$result.url:=$result.path
	$result.path:=Replace string:C233($result.path;"https://github.com/";"")
End if 

C_COLLECTION:C1488($urlPaths)
$urlPaths:=Split string:C1554($result.path;"/")
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

  // Try with binary
If ($options.binary)
	
	C_TEXT:C284($binaryName;$binaryFormattedName)
	$binaryName:=$result.repository+".4DZ"
	$binaryFormattedName:=Replace string:C233($binaryName;" ";".")
	
	If ($result.latest)
		$result.binaryURL:=$result.url+"/releases/latest/download/"+$binaryName
	Else 
		$result.binaryURL:=$result.url+"/releases/download/"+$options.version+"/"+$binaryName
	End if 
	
	C_TEXT:C284($content)
	C_BLOB:C604($response)
	C_LONGINT:C283($httpResult)
	$httpResult:=HTTP Request:C1158(HTTP GET method:K71:1;$result.binaryURL;$content;$response)
	
	$outputFile:=$componentsFolder.file($binaryName)
	
	$result.success:=($httpResult=200)
	
	If ($result.success)  // success
		$outputFile.setContent($response)
	Else 
		$result.errors:=New collection:C1472(New object:C1471("code";$httpResult;"message";"Failed to download"))
	End if 
	
End if 

If (Not:C34($result.success))
	  // Try with sources
	
	$outputFile:=Folder:C1567($componentsFolder.platformPath;fk platform path:K87:2).folder($result.repository+".4dbase")
	
	  // If $outputFile.exists ??  -> error already installed? or nothing, just change version if version defined using tag
	
	  // LAUNCH EXTERNAL PROCESS("git submodule add "+$result.url+".git Components/"+$result.repository+".4dbase")
	C_TEXT:C284($cmd;$in;$out;$err)
	$cmd:="git"
	If (Is Windows:C1573)
		$cmd:=$cmd+".exe"
	End if 
	
	C_BOOLEAN:C305($submodule)
	$submodule:=Folder:C1567(fk database folder:K87:14).folder(".git").exists
	If ($submodule)  // if already in git use submodule
		SET ENVIRONMENT VARIABLE:C812("_4D_OPTION_CURRENT_DIRECTORY";Folder:C1567(fk database folder:K87:14).platformPath)
		$cmd:=$cmd+" submodule -q add "+$result.url+".git 'Components/"+$outputFile.fullName+"'"  // -q quiet to not output progress in stderr
	Else   // clone
		$cmd:=$cmd+" clone -q "+$result.url+".git '"+$outputFile.path+"'"  // -q quiet to not output progress in stderr
	End if 
	LAUNCH EXTERNAL PROCESS:C811($cmd;$in;$out;$err)
	
	If (Length:C16($err)>0)
		$result.errors:=New collection:C1472($err)
	Else 
		$result.success:=True:C214
	End if 
	
End if 

$0:=$result