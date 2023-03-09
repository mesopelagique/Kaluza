//%attributes = {}

var $kaluza; $result : Object
$kaluza:=cs:C1710.Kaluza.new()
$kaluza.options:=New object:C1471("binary"; False:C215)
$kaluza.dependencies:=New collection:C1472("mesopelagique/ObjectClassMapper")


var $dependencies : Collection
$dependencies:=$kaluza.allDependencyInstances()

$result:=$kaluza.installDependencies()
ASSERT:C1129($result.success; JSON Stringify:C1217($result))

For each ($dependency; $dependencies)
	ASSERT:C1129($dependency.isInstalled; "Not installed "+$dependency.toString())
End for each 

var $dependency : Object
For each ($dependency; $dependencies)
	$dependency.uninstall()
	ASSERT:C1129(Not:C34($dependency.isInstalled); "Must not be installed "+$dependency.toString())
End for each 

For each ($dependency; $dependencies)
	$dependency.install()
	ASSERT:C1129($dependency.isInstalled; "Not installed "+$dependency.toString())
End for each 

$kaluza.save()