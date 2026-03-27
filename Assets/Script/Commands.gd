extends Node

static func test(sender:Node,num:String) -> Error:
	if sender is LocalPlayer:
		var player0: LocalPlayer = sender
		player0.chat_menu.append_message("test pass" + num)
		return Error.OK
	return Error.ERR_INVALID_PARAMETER
		
static func host(_sender:Node,port:String) -> Error:
	Global.host(int(port))
	return Error.OK

static func join(_sender:Node,address:String,port:String) -> Error:
	Global.join(address,int(port))
	return Error.OK
