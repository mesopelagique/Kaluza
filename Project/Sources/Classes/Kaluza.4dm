
Class extends Object

Class constructor($input : Variant)
	If (Count parameters:C259=0)
		$input:=Folder:C1567(fk database folder:K87:14; *).file("component.json")
	End if 
	
	If (Value type:C1509($input)=Is object:K8:27)
		var $conf : Object
		If (OB Class:C1730($input).name="File")  // load from file
			$conf:=JSON Parse:C1218($input.getText())
		Else 
			$conf:=$input
		End if 
		This:C1470.fill($conf)
	Else 
		// unknown
	End if 
	
Function dependencyInstances() : Collection
	return This:C1470._buildDependencies(This:C1470.dependencies)
	
Function devDepencyInstances() : Collection
	return This:C1470._buildDependencies(This:C1470.devDependencies)
	
Function allDependencyInstances() : Collection
	return This:C1470.dependencyInstances().concat(This:C1470.devDepencyInstances())
	
Function installDependencies($options : Object)->$result : Object
	var $results : Collection
	$results:=New collection:C1472()
	
	This:C1470.allDependencyInstances().reduce(Formula:C1597($1.accumulator.push($1.value.install($options))); $results)
	
	$result:=New object:C1471("results"; $results)
	$result.success:=$results.reduce(Formula:C1597($1.accumulator & $1.value.success); True:C214)
	$result.hasInstalled:=$results.extract("hasInstalled").indexOf(True:C214)>=0
	
/**
PRIVATE
	
*/
Function _buildDependencies($input : Variant)->$dependencies : Collection
	
	var $path : Text
	var $dependency : Object
	$dependencies:=New collection:C1472()
	
	Case of 
		: (Value type:C1509($input)=Is object:K8:27)
			
			For each ($path; $input)
				$dependency:=cs:C1710.Dependency.new()
				$dependency.path:=$path
				$dependency.version:=$input[$path]
				$dependencies.push($dependency)
				$dependency.parent:=This:C1470
			End for each 
			
		: (Value type:C1509($input)=Is collection:K8:32)
			
			For each ($path; $input)
				$dependency:=cs:C1710.Dependency.new()
				$dependency.path:=$path
				$dependencies.push($dependency)
				$dependency.parent:=This:C1470
			End for each 
			
	End case 
	
Function save()
	var $file : 4D:C1709.File
	$file:=Folder:C1567(fk database folder:K87:14; *).file("component.json")
	
	$file.setText(JSON Stringify:C1217(This:C1470; *); "UTF-8-no-bom"; Line feed:K15:40)