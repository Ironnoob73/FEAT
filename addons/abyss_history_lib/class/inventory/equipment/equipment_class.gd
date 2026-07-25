extends AHL_ThingClass
class_name AHL_EquipmentClass

@export var performance : float
@export var durability : float
@export var delay : float = 0.5
@export var name1 : String

func get_subname() -> String:
	if name1:
		return name1
	return "tool.type.undefined"
