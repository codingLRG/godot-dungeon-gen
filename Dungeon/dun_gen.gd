@tool #allows to run in editor
extends Node3D

@onready var grid_map : GridMap = $GridMap

@export var test_run : bool = false : set = set_start

func set_start(val:bool)->void:
	var dungeon := Dungeon.new()
	dungeon._generate()

	#visualize_border()
	#make_room()

@export var border_size : int = 20 : set = set_border_size
@export var space : int = 10 : set = set_space

func set_border_size(val : int)->void:
	border_size = val
	if Engine.is_editor_hint():
		visualize_border()
		
func set_space(val : int)->void:
	space = val
	if Engine.is_editor_hint():
		visualize_border()

func visualize_border():
	grid_map.clear()
	for i in range(-1,border_size + 1):
		grid_map.set_cell_item(Vector3i(i,0,-1),0)
		grid_map.set_cell_item(Vector3i(i,0,border_size),0)
		grid_map.set_cell_item(Vector3i(border_size,0,i),0)
		grid_map.set_cell_item(Vector3i(-1,0,i),0)

func generate(dungeon_tree):
	grid_map.clear()
	for i in range(0, dungeon_tree.size()):
		make_room(dungeon_tree[i])
		await get_tree().create_timer(0.1).timeout 

func make_room(param):
	#print(str(param.id)+ " with quality "+str(param.quality) +" and is locked: "+ str(param.blocked))
	var pos : Vector3i
	pos.x = param.id % border_size
	pos.z = param.id / border_size
	if(param.quality == 0 
	and param.blocked):
		grid_map.set_cell_item(pos,4)
	elif(param.quality == 0):
		grid_map.set_cell_item(pos,1)
	elif(param.quality == 1):
		grid_map.set_cell_item(pos,3)
	else:
		grid_map.set_cell_item(pos,2)
