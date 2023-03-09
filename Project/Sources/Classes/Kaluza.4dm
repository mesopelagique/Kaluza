
Class extends Object

Class constructor($input : Variant)
	If (Count parameters:C259=0)
		$input:=This:C1470.getFile()
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
	
	If (This:C1470.dependencies=Null:C1517)
		This:C1470.dependencies:=New collection:C1472
	End if 
	If (This:C1470.devDependencies=Null:C1517)
		This:C1470.devDependencies:=New collection:C1472
	End if 
	
	// MARK: file
	
Function getFile : 4D:C1709.File
	return Folder:C1567(fk database folder:K87:14; *).file("component.json")
	
Function load()
	This:C1470.fill(JSON Parse:C1218(This:C1470.getFile().getText()))
	
Function save()
	If (This:C1470.devDependencies.length=0)
		OB REMOVE:C1226(This:C1470; "devDependencies")  // just to write not if empty
	End if 
	This:C1470.getFile().setText(JSON Stringify:C1217(This:C1470; *); "UTF-8-no-bom"; Line feed:K15:40)
	If (This:C1470.devDependencies=Null:C1517)
		This:C1470.devDependencies:=New collection:C1472
	End if 
	
	// MARK: dependency
	
Function addDependency($dependency : Variant; $dev : Boolean) : cs:C1710.Dependency
	
	Case of 
		: (Value type:C1509($dependency)=Is text:K8:3)  // suppose path
			
			If (This:C1470._dependencyCollection($dev).indexOf($dependency)=0)
				This:C1470._dependencyCollection($dev).push($dependency)
			Else 
				ASSERT:C1129(False:C215; "Already added "+$dependency)  // ??
			End if 
			
			var $dependencyObj : cs:C1710.Dependency
			$dependencyObj:=cs:C1710.Dependency.new()
			$dependencyObj.path:=$dependency
			$dependencyObj.parent:=This:C1470
			
			return $dependencyObj
			
		: (Value type:C1509($dependency)=Is object:K8:27)
			
			If ($dependency.path#Null:C1517)
				Case of 
					: (OB Instance of:C1731($dependency; cs:C1710.Dependency))
						
						This:C1470._dependencyCollection($dev).push($dependency.path)
						
						// : (OB Instance of($dependency; 4D.Folder))
						
						return $dependency
						
					Else 
						// normal object definition
						This:C1470._dependencyCollection($dev).push($dependency.path)
				End case 
			Else 
				ASSERT:C1129(False:C215; "No path for dependency"+JSON Stringify:C1217($dependency))
			End if 
			
		Else 
			
			ASSERT:C1129(False:C215; "Unknown dependency format")
			
	End case 
	
Function removeDependency($dependency : Variant; $dev : Boolean) : cs:C1710.Dependency
	var $index : Integer
	var $dependencies : Collection
	
	$dependencies:=This:C1470._dependencyCollection($dev)
	
	Case of 
		: (Value type:C1509($dependency)=Is text:K8:3)  // suppose path
			
			$index:=$dependencies.indexOf($dependency)
			If ($index<0)
				ASSERT:C1129(False:C215; "Already removed "+$dependency)  // ??
			Else 
				$dependencies.remove($index)
			End if 
			
			var $dependencyObj : cs:C1710.Dependency
			$dependencyObj:=cs:C1710.Dependency.new()
			$dependencyObj.path:=$dependency
			$dependencyObj.parent:=This:C1470
			return $dependencyObj
			
		: (Value type:C1509($dependency)=Is object:K8:27)
			
			If ($dependency.path#Null:C1517)
				Case of 
					: (OB Instance of:C1731($dependency; cs:C1710.Dependency))
						
						$index:=$dependencies.indexOf($dependency.path)
						If ($index<0)
							ASSERT:C1129(False:C215; "Already removed "+$dependency.path)  // ??
						Else 
							$dependencies.remove($index)
						End if 
						// : (OB Instance of($dependency; 4D.Folder))
						
						return $dependency
					Else 
						// normal object definition
						$index:=$dependencies.indexOf($dependency.path)
						If ($index<0)
							ASSERT:C1129(False:C215; "Already removed "+$dependency.path)  // ??
						Else 
							$dependencies.remove($index)
						End if 
						var $dependencyObj : cs:C1710.Dependency
						$dependencyObj.fill($dependency)
						return $dependencyObj
				End case 
			Else 
				ASSERT:C1129(False:C215; "No path for dependency"+JSON Stringify:C1217($dependency))
			End if 
			
		Else 
			
			ASSERT:C1129(False:C215; "Unknown dependency format")
			
	End case 
	
Function installDependency($dependency : Variant; $dev : Boolean) : Object
	var $dependencyObj : cs:C1710.Dependency
	$dependencyObj:=This:C1470.addDependency($dependency; $dev)
	
	return $dependencyObj.install(This:C1470.options)
	
Function uninstallDependency($dependency : Variant; $dev : Boolean) : Object
	var $dependencyObj : cs:C1710.Dependency
	$dependencyObj:=This:C1470.removeDependency($dependency; $dev)
	
	$dependencyObj.delete()
	
	// MARK: dependencies
Function devDepencyInstances() : Collection
	return This:C1470._buildDependencies(This:C1470.devDependencies)
	
Function dependencyInstances() : Collection
	return This:C1470._buildDependencies(This:C1470.dependencies)
	
Function _dependencyCollection($dev : Boolean) : Collection
	return (Bool:C1537($dev) ? This:C1470.devDependencies : This:C1470.dependencies)
	
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