extends Node

func test(sender,num:String):
	if sender is player:
		sender.chat_menu.append_message("test pass" + num)
