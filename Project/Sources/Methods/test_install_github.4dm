//%attributes = {}
var $result; $componentsFolder : Object

$componentsFolder:=Folder:C1567(fk database folder:K87:14).folder("Components").delete(Delete with contents:K24:24)

$result:=install_github("mesopelagique/CollectionUtils")
ASSERT:C1129($result.success; JSON Stringify:C1217($result))

$result:=install_github("mesopelagique/CollectionUtils"; New object:C1471("version"; "0.0.1"))
ASSERT:C1129($result.success; JSON Stringify:C1217($result))

$result:=install_github("mesopelagique/CollectionUtils"; New object:C1471("binary"; False:C215))
ASSERT:C1129($result.success; JSON Stringify:C1217($result))

//$result:=install_github ("mesopelagique/CollectionUtils";New object("binary";False;"version";"0.0.1"))
//ASSERT($result.success;JSON Stringify($result))