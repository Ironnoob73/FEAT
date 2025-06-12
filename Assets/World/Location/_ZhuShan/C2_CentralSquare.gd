extends Node3D

@onready var grow_grass_area = $CENTER/Ground/GrassGround

func _ready():
	for i in 24 : for j in 34 :
		var grass = preload("res://Resources/Object/Nature/Grass/grass_ground.tscn").instantiate()
		grass.position = grow_grass_area.position + Vector3( i + 40.5, - 0.5, j + 6.5)
		grow_grass_area.add_child(grass)
