
Function toString()
	$0:=OB Class:C1730(This:C1470).name+"["+JSON Stringify:C1217(This:C1470)+"]"
	
Function equals()
	C_BOOLEAN:C305($0;$result)
	$result:=True:C214
	
	
	$0:=$result