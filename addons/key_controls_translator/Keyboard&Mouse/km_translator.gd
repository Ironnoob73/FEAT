extends Node

var QuoteLeft = "`"
var Minus = "-"
var Equal = "="
var BracketLeft = "["
var BracketRight = "]"
var BackSlash = "\\"
var Semicolon = ";"
var Apostrophe = "\'"
var Comma = ","
var Period = "."
var Slash = "/"

var Up = "^"
var Down = "_"
var Left = "<"
var Right = ">"
var Space = ":"

var Alt = "a"
var Backspace = "b"
var Ctrl = "c"
var Delete = "d"
var Enter = "e"
var KpEnter = "f"
var Kp9 = "g"
var Home = "h"
var Insert = "i"
var CapsLock = "l"
var Menu = "m"
var NumLock = "n"
var Kp0 = "o"
var Print = "p"
var ScrollLock = "q"
var Pause = "r"
var Shift = "s"
var Tab = "t"
var Kp8 = "u"
var Windows = "w"
var KpPeriod = "x"
var Kp7 = "y"
var End = "z"

var PageUp = "{"
var PageDown = "}"
var Escape = "~"

var Kp1 = "\u00B9" # ¹
var Kp2 = "\u00B2" # ²
var Kp3 = "\u00B3" # ³
var Kp4 = "("
var Kp5 = "?"
var Kp6 = ")"
var KpDivide = "%"
var KpMultiply = "*"
var KpSubtract = "\u00AF" # ¯
var KpAdd = "\u00B1" # ±

var F1 = "\u00C0"
var F2 = "\u00C1"
var F3 = "\u00C2"
var F4 = "\u00C3"
var F5 = "\u00C4"
var F6 = "\u00C5"
var F7 = "\u00C6"
var F8 = "\u00C7"
var F9 = "\u00C8"
var F10 = "\u00C9"
var F11 = "\u00CA"
var F12 = "\u00CB"

func get_key_from_name(key_name:String):
	return get(key_name.replace(" ",""))

func get_key_from_event(event:InputEvent):
	if event is InputEventKey:
		return get_key_from_name(event.as_text())
	else:
		return null
