extends Area3D

@export var item : String
@onready var mesh = $MeshInstance3D

func _ready():
	if item :
		var item_class = AllItems.get_item_from_name(item)
		mesh.mesh = item_class.model
		mesh.material_override = item_class.material

func _on_body_entered(body):
	body.Inventory.add_equipment(item)
	queue_free()
