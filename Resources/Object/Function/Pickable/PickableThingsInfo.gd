@tool
extends RigidBody3D

var interact_icon : String = "🤚"

@onready var mesh = $PickableArea/MeshInstance3D

#func _ready():
#	model_setter()

#func pickup(body):
#	body.Inventory.add_instance(ThingInstance)
#	queue_free()
	
#func interact(sender):
#	pickup(sender)

func _on_pickable_area_body_entered(body):
	if Global.auto_pickup:
		get_parent().interact(body)

func model_setter():
	var ThingInstance = get_thing_instance()
	if  is_instance_valid(mesh):
		if !ThingInstance:
			push_warning("NoThing")
		elif ThingInstance is ItemStackClass:
			if ThingInstance.item:
				mesh.mesh = ThingInstance.item.model
				mesh.material_override = ThingInstance.item.material
			else : push_warning("NoThing")
		elif ThingInstance is EqMetaClass:
			if ThingInstance.equipment:
				mesh.mesh = ThingInstance.equipment.model
				mesh.material_override = ThingInstance.equipment.material
			else : push_warning("NoThing")
	
func get_thing_instance():
	return get_parent().get_meta('thing_instance',null)
