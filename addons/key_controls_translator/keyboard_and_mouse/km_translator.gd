class_name KmTranslator
extends Node

var QuoteLeft: String = "`"
var Minus: String = "-"
var Equal: String = "="
var BracketLeft: String = "["
var BracketRight: String = "]"
var BackSlash: String = "\\"
var Semicolon: String = ";"
var Apostrophe: String = "\'"
var Comma: String = ","
var Period: String = "."
var Slash: String = "/"

var Up: String = "^"
var Down: String = "_"
var Left: String = "<"
var Right: String = ">"
var Space: String = ":"

var Alt: String = "a"
var Backspace: String = "b"
var Ctrl: String = "c"
var Delete: String = "d"
var Enter: String = "e"
var KpEnter: String = "f"
var Kp9: String = "g"
var Home: String = "h"
var Insert: String = "i"
var CapsLock: String = "l"
var Menu: String = "m"
var NumLock: String = "n"
var Kp0: String = "o"
var Print: String = "p"
var ScrollLock: String = "q"
var Pause: String = "r"
var Shift: String = "s"
var Tab: String = "t"
var Kp8: String = "u"
var Windows: String = "w"
var KpPeriod: String = "x"
var Kp7: String = "y"
var End: String = "z"

var PageUp: String = "{"
var PageDown: String = "}"
var Escape: String = "~"

var Kp1: String = "\u00B9" # ¹
var Kp2: String = "\u00B2" # ²
var Kp3: String = "\u00B3" # ³
var Kp4: String = "("
var Kp5: String = "?"
var Kp6: String = ")"
var KpDivide: String = "%"
var KpMultiply: String = "*"
var KpSubtract: String = "\u00AF" # ¯
var KpAdd: String = "\u00B1" # ±

var F1: String = "\u00C0"
var F2: String = "\u00C1"
var F3: String = "\u00C2"
var F4: String = "\u00C3"
var F5: String = "\u00C4"
var F6: String = "\u00C5"
var F7: String = "\u00C6"
var F8: String = "\u00C7"
var F9: String = "\u00C8"
var F10: String = "\u00C9"
var F11: String = "\u00CA"
var F12: String = "\u00CB"

static func _get_translator() -> KmTranslator:
	return KmTranslator.new()

static func get_key_from_name(key_name:String) -> String:
	var result: Variant = _get_translator().get(key_name.replace(" ",""))
	if result is String:
		return _get_translator().get(key_name.replace(" ",""))
	return ""

static func get_key_from_event(event:InputEvent) -> String:
	if event is InputEventKey:
		return get_key_from_name(event.as_text())
	else:
		return ""
