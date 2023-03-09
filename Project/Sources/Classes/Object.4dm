
Function toString() : Text
	return OB Class:C1730(This:C1470).name+"["+JSON Stringify:C1217(This:C1470)+"]"
	
Function fill($obj : Object)
	var $key : Text
	For each ($key; $obj)
		This:C1470[$key]:=$obj[$key]
	End for each 