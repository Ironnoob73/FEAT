extends Node

static func test(sender,num:String):
	if sender is player:
		sender.chat_menu.append_message("test pass" + num)
		
static func host(sender,port:String):
	if sender is player:
		Global.host(int(port))
		sender.chat_menu.append_message("Start to host a server at:" + port)

static func join(sender,address:String,port:String):
	if sender is player:
		Global.join(address,int(port))
		sender.chat_menu.append_message("Start to join a server to:" + address + ":" + port)
