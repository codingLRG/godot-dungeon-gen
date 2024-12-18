extends "res://Dungeon/dun_node.gd"

class_name Dungeon

var root_node : DungeonNode
var pointer_node : DungeonNode
var border_size : int
var max_rooms : int
var random_gen = RandomNumberGenerator.new()
var dun_seed : int
var generated : bool

func _init(border_param : int = 5, 
space_param : int = 15, seed_param = ""):
	self.border_size = border_param
	self.max_rooms = space_param - 2
	dun_seed = seed_param.hash() if seed_param else randi()
	seed(dun_seed)
	var even_param : int = [border_param,border_param+1,1,0].pick_random()
	var starting_local : int = (border_param**2)/2+1 if border_param % 2 == 1 else (border_param**2 - border_param)/2 + even_param
	self.root_node = DungeonNode.new(starting_local)
	_populate()
	self.root_node.quality = -1
	self.generated = _generate()

func _populate(param_node := root_node):
	pointer_node = param_node
	var chance := 1 == random_gen.randi_range(
		1,max(2, max_rooms/2 - _depth_tool(pointer_node.id)))
	pointer_node.quality = 1
	var dir = [
		pointer_node.id - 1, 
		pointer_node.id + 1, 
		pointer_node.id + border_size, 
		pointer_node.id - border_size,].filter(_filter_dir)
	var children : Array[DungeonNode] = []
	for i in range(0,dir.size()):
		children.append(DungeonNode.new(dir[i],pointer_node.id))
	pointer_node._add_children(children)
	if(pointer_node.children.size() == 0):
		pointer_node.quality = 2
	if(chance):
		for i in range(0,dir.size()):
			pointer_node.children[i]._lock()

func _generate():
	_select_able_child(pointer_node)
	var counter := 0
	while(_fill_map() and counter < max_rooms):
		counter+=1
	#if(counter < max_rooms):
	#	print("FAILED")
	#	return false
	_cleanup_tool()
	#print(" ")
	#_generate_abstract()
	
	#_select_node(-border_size - 1)
	return true

func _select_able_child(param_node : DungeonNode):
	var able_bodies : Array[int] = []
	for i in range(0,param_node.children.size()):
		if(!param_node.children[i].locked):
			able_bodies.append(param_node.children[i].id)
	if(able_bodies.size() > 0):
		_select_node(able_bodies.pick_random())
		return true
	return false

func _fill_map():
	_populate(pointer_node)
	while(!_select_able_child(pointer_node)):
		pointer_node._lock()
		if(!_select_node(pointer_node.parent_id)):
			return false
	return true

func _generate_abstract():
	for height in range(0,border_size):
		var grid := ""
		var door = 0
		for width in range(0,border_size):
			if(_select_node(width+height*border_size+1)):
				door = _pull_doors()
			else:
				door = 0
			if(width == 0):
				grid += _abs_door1(door)
			elif(width==border_size-1):
				grid += _abs_door1(door)
			else:
				grid += _abs_door1(door)
		print(grid)
		grid = ""
		for width in range(0,border_size):
			var occupied := 0
			if(_select_node(width+height*border_size+1)):
				occupied = pointer_node.quality
				door = _pull_doors()
			else:
				door = 0
			if(width == 0):
				grid += _abs_door2(door,occupied)
			elif(width==border_size-1):
				grid += _abs_door2(door,occupied)
			else:
				grid += _abs_door2(door,occupied)
		print(grid)
		grid = ""
		for width in range(0,border_size):
			if(_select_node(width+height*border_size+1)):
				door = _pull_doors()
			else:
				door = 0
			if(width == 0):
				grid += _abs_door3(door)
			elif(width==border_size-1):
				grid += _abs_door3(door)
			else:
				grid += _abs_door3(door)
		print(grid)
	return true

func _abs_door1(door : int):
	var wall = "┌"
	if(door & 0b0001 == 1):
		wall += " "
	else:
		wall += "─"
	wall += "┐"
	return wall
func _abs_door2(door : int, grid : int = 0):
	var wall
	if(door & 0b0100 == 0b0100):
		wall = " "
	else:
		wall = "│"
	if(grid == 0):
		wall += "*"
	elif(grid == 1):
		wall += " "
	elif(grid == 2):
		wall += "o"
	elif(grid == -1):
		wall += "x"
	else:
		wall += "?"
	if(door & 0b0010 == 0b0010):
		wall += " "
	else:
		wall += "│"
	return wall
func _abs_door3(door : int):
	var wall = "└"
	if(door & 0b1000 == 0b1000):
		wall += " ┘"
	else:
		wall += "─┘"
	return wall

func _recursive_test():
	return true
	
func _pull_doors(node_param := pointer_node):
	if(node_param.quality == 0):
		return 0
	var doors := 0 
	for i in range(0,node_param.children.size()):
		if(node_param.children[i].quality != 0):
			doors += _door_translate(node_param.children[i].id - node_param.id) 	
	doors += _door_translate(node_param.parent_id - node_param.id)
	return doors 

func _door_translate(direction : int) -> int:
	var doors = 0
	var neg_ = -border_size
	match direction:
			-1:
				doors += 0b0100
			1:
				doors += 0b0010
			border_size:
				doors += 0b1000
			neg_:
				doors += 0b0001
	return doors

func _select_node(param_id := root_node.id, param_root := root_node):
	for i in range(0,param_root.children.size()):
		if(param_id == -border_size - 1): #DEBUGGING CALL
			var output = ""
			for j in range(0,_depth_tool(param_root.id)):
				output += "\t"
			print(output+"PARENT: "+str(param_root.id)+ " CHILD: "+str(param_root.children[i].id)+"("+str(param_root.children[i].children.size())+")")
		if(_select_node(param_id,param_root.children[i])):
			return true
	pointer_node = param_root
	return param_id == param_root.id

func _depth_tool(param_id := root_node.id, param_root := root_node):
	var dist = -1
	if(param_id == param_root.id):
		return dist + 1
	for i in range(0,param_root.children.size()):
		dist = _depth_tool(param_id,param_root.children[i])
		if(dist >= 0):
			return dist + 1
	return dist

func _cleanup_tool(param_node := root_node):
	var loser_children = true
	for i in range(0,param_node.children.size()):
		_cleanup_tool(param_node.children[i])
		if(param_node.children[i].quality != 0):
			loser_children = false
	if(loser_children and param_node.children.size() != 0):
		param_node.quality = 2
	param_node._lock()

func _filter_dir(child_id_param : int):
	if(child_id_param == pointer_node.parent_id): # is parent
		return false
	if(child_id_param - 1 == pointer_node.id and  # wrapping
	pointer_node.id % border_size == 0): # right to left
		return false
	if(child_id_param + 1 == pointer_node.id and # wrapping
	child_id_param % border_size == 0): # left to right
		return false
	if(child_id_param > border_size**2): # overflow border
		return false
	if(child_id_param < 1): # underflow border
		return false
	var temp_var = pointer_node.id
	if(child_id_param != pointer_node.parent_id # not parent 
	and _select_node(child_id_param)): # and node exist
		pointer_node._lock()
		_select_node(temp_var)
		return false
	_select_node(temp_var)
	return true

func convert_to_cords(param_root := root_node):
	var node_values := [(param_root.id-1)%border_size,(param_root.id-1)/border_size+1,param_root.quality]
	var node_list := []
	for i in range(0,param_root.children.size()):
		node_values.append_array(convert_to_cords(param_root.children[i]))
	return node_values
	
