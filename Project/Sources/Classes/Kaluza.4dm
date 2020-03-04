
Class extends Object

Function dependencyInstances()
	C_COLLECTION:C1488($0)
	$0:=This:C1470._buildDependencies(This:C1470.dependencies)
	
Function devDepencyInstances()
	C_COLLECTION:C1488($0)
	$0:=This:C1470._buildDependencies(This:C1470.devDependencies)
	
Function allDependencyInstances()
	C_COLLECTION:C1488($0)
	$0:=This:C1470.dependencyInstances().concat(This:C1470.devDepencyInstances())
	
Function installDependencies()
	$results:=New collection:C1472()
	This:C1470.allDependencyInstances().reduce("c_formula_this";$results;Formula:C1597(This:C1470.accumulator.push(This:C1470.value.install())))
	
	$0:=New object:C1471("results";$results)
	$0.success:=$results.reduce("c_formula_this";True:C214;Formula:C1597(This:C1470.accumulator & This:C1470.value.success))
	
/**
PRIVATE
	
*/
Function _buildDependencies()
	C_VARIANT:C1683($1)
	C_COLLECTION:C1488($dependencies;$0)
	C_TEXT:C284($path)
	C_OBJECT:C1216($dependency)
	$dependencies:=New collection:C1472()
	
	Case of 
		: (Value type:C1509($1)=Is object:K8:27)
			
			For each ($path;$1)
				$dependency:=cs:C1710.Dependency.new()
				$dependency.path:=$path
				$dependency.version:=$1[$name]
				$dependencies.push($dependency)
				$dependency.parent:=This:C1470
			End for each 
			
		: (Value type:C1509($1)=Is collection:K8:32)
			
			For each ($path;$1)
				$dependency:=cs:C1710.Dependency.new()
				$dependency.path:=$path
				$dependencies.push($dependency)
				$dependency.parent:=This:C1470
			End for each 
			
	End case 
	$0:=$dependencies
	