@tool
extends RigidBody3D

@onready var mesh = $PickableArea/MeshInstance3D

func _on_pickable_area_body_entered(body):
	if Global.auto_pickup:
		get_parent().touch(body)

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
	if get_parent().has_meta('thing_instance'):
		return get_parent().get_meta('thing_instance')
