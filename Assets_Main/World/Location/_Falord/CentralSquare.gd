extends Node3D

@onready var grow_grass_area = $EastGround/MainRoad/GrassGround

func _ready():
	for i in 24 : for j in 34 :
		var grass = preload("res://Resources/Object/Nature/Grass/grass_ground.tscn").instantiate()
		grass.position = grow_grass_area.position + Vector3( i-11.5, 0, j+6.5)
		grow_grass_area.add_child(grass)
