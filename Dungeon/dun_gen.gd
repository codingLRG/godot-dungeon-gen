@tool #allows to run in editor
extends Node3D

@onready var grid_map : GridMap = $GridMap

@export var test_run : bool = false : set = set_start
@export var border_size : int = 20 : set = set_border_size
@export var space : int = 10 : set = set_space
@export var seed : String = "" : set = set_seed

func set_start(val:bool)->void:
	var random_gen = RandomNumberGenerator.new()
	
	if(seed):
		random_gen.set_seed(seed.hash())
		#print("SET SEED " + str(random_gen.get_seed()))
	var dungeon := Dungeon.new(border_size,space,random_gen.randi())
	var fail_counter = 0
	while(!dungeon.generated and fail_counter < 100):
		dungeon = Dungeon.new(border_size,space,random_gen.randi())
		fail_counter += 1
	if fail_counter == 100:
		print("BROKE")
	var test : Array= dungeon.convert_to_cords()
	#for i in range(0,test.size()):
	#	var temp = test[i]
	#	print(temp[0])
	generate(dungeon.convert_to_cords())
	#visualize_border()
	#make_room()


func set_border_size(val : int)->void:
	border_size = val
	if Engine.is_editor_hint():
		visualize_border()
		
func set_space(val : int)->void:
	space = val
	if Engine.is_editor_hint():
		visualize_border()

func set_seed(val : String)->void:
	seed = val

func visualize_border():
	grid_map.clear()
	for i in range(-1,border_size + 1):
		grid_map.set_cell_item(Vector3i(i,0,-1),0)
		grid_map.set_cell_item(Vector3i(i,0,border_size),0)
		grid_map.set_cell_item(Vector3i(border_size,0,i),0)
		grid_map.set_cell_item(Vector3i(-1,0,i),0)

func generate(dungeon_tree):
	grid_map.clear()
	await get_tree().create_timer(0.3).timeout 
	for i in range(0, dungeon_tree.size()):
		var list :Dun_Conv = dungeon_tree[i]
		#if(list.quality != 0):
		make_room(list.x_axis,list.y_axis,list.quality,list.locked)
			#await get_tree().create_timer(0.05).timeout 

func make_room(x,y,q,l):
	#print("("+str(x)+","+str(y)+")"+ " with quality "+str(q))
	var pos : Vector3i
	pos.x = x
	pos.z = y
	if(q == 0):
		if(!l):
			grid_map.set_cell_item(pos,1)
		else:
			grid_map.set_cell_item(pos,0)
	elif(q == 1):
		grid_map.set_cell_item(pos,3)
	elif(q == -1):
		grid_map.set_cell_item(pos,4)
	else:
		grid_map.set_cell_item(pos,2)
