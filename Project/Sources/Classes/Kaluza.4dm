
Class extends Object

Class constructor
	C_VARIANT:C1683($1)
	If (Count parameters:C259>0)
		If (Value type:C1509($1)=Is object:K8:27)
			C_OBJECT:C1216($conf)
			If (OB Class:C1730($1).name="File")  // load from file
				$conf:=JSON Parse:C1218($1.getText())
			Else 
				$conf:=$1
			End if 
			C_TEXT:C284($key)
			For each ($key;$conf)  // cppy?
				This:C1470[$key]:=$conf[$key]
			End for each 
		Else 
			  // unknown
		End if 
		
	End if 
	
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
	C_OBJECT:C1216($0;$1;$options)
	C_COLLECTION:C1488($results)
	$results:=New collection:C1472()
	$options:=$1
	
	This:C1470.allDependencyInstances().reduce("c_formula_this";$results;Formula:C1597(This:C1470.accumulator.push(This:C1470.value.install($options))))
	
	$0:=New object:C1471("results";$results)
	$0.success:=$results.reduce("c_formula_this";True:C214;Formula:C1597(This:C1470.accumulator & This:C1470.value.success))
	$0.hasInstalled:=$results.extract("hasInstalled").indexOf(True:C214)>=0
	
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
				$dependency.version:=$1[$path]
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
	