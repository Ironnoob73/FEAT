extends Node3D

@onready var grow_grass_area: StaticBody3D = $CENTER/Ground/GrassGround

func _ready() -> void:
	for i: int in 24 : for j: int in 34 :
		var grass: Area3D = preload("res://Resources/Object/Nature/Grass/grass_ground.tscn").instantiate()
		grass.position = grow_grass_area.position + Vector3( i + 40.5, - 0.5, j + 6.5)
		grow_grass_area.add_child(grass)
