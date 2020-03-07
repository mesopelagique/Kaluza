//%attributes = {}

C_OBJECT:C1216($kaluza;$result)
$kaluza:=cs:C1710.Kaluza.new()
$kaluza.options:=New object:C1471("binary";False:C215)
  // $kaluza.dependencies:=New object("mesopelagique/CollectionUtils";Null;"mesopelagique/ObjectClassMapper";Null;"mesopelagique/NullCoaliescing";Null)
$kaluza.dependencies:=New collection:C1472("mesopelagique/CollectionUtils";"mesopelagique/ObjectClassMapper";"mesopelagique/NullCoaliescing")


C_COLLECTION:C1488($dependencies)
$dependencies:=$kaluza.allDependencyInstances()

$result:=$kaluza.installDependencies()
ASSERT:C1129($result.success;JSON Stringify:C1217($result))

C_OBJECT:C1216($dependency)
For each ($dependency;$dependencies)
	$dependency.install()
	ASSERT:C1129($dependency.isInstalled();"Not installed "+$dependency.toString())
End for each 

