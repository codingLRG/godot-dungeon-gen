extends "res://Dungeon/dun_node.gd"

class_name Dungeon

var root_node : DungeonNode
var pointer_node : DungeonNode
var border_size : int
var max_rooms : int
var random_gen = RandomNumberGenerator.new()
var dun_seed : int
var generated : bool
var debuggingTrigger : int
var max_depth : int
var most_locked : int

func _init(border_param : int, 
space_param : int, seed_param : int):
	self.border_size = border_param
	self.debuggingTrigger = -border_size - 1
	self.max_rooms = space_param
	dun_seed = seed_param
	#print(dun_seed)
	random_gen.set_seed(dun_seed)
	seed(dun_seed)
	var even_param : int = [border_param,border_param+1,1,0].pick_random()
	var starting_local : int = (border_param**2)/2+1 if border_param % 2 == 1 else (border_param**2 - border_param)/2 + even_param
	self.root_node = DungeonNode.new(starting_local)
	_populate()
	self.root_node.quality = -1
	self.generated = _generate()

func _populate(param_node := root_node):
	pointer_node = param_node
	var restart := false
	var chance := random_gen.randi_range(
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
	if(chance < 3):
		for i in range(0,dir.size()):
			pointer_node.children[i]._lock()
		if(chance == 1):
			restart = true
	return restart

func _generate():
	_select_able_child(pointer_node)
	var counter := 0
	while(_fill_map() and counter < max_rooms):
		counter+=1
	if(counter < max_rooms):
		root_node = DungeonNode.new(-1)
		return false
	_cleanup_tool()
	
	_create_boss(find_farthest_nodes(2).pick_random())
	var secret_room_num := random_gen.randi_range(2,max_rooms/20)
	for i in range(0,secret_room_num):
		_create_secret(find_most_locked().pick_random())
		
	#print(" ")
	_generate_abstract()
	#_select_node(debuggingTrigger)
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
	if(_populate(pointer_node)):
		#print("HELLO")
		pointer_node = root_node
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
		if(param_id == debuggingTrigger and param_root.children[i].quality == 2): #DEBUGGING CALL
			var output = ""
			for j in range(0,_depth_tool(param_root.id)):
				output += "\t"
			print(output+"PARENT: "+(convert_these_cords([param_root])[0].print())+ " CHILD: "+(convert_these_cords([param_root.children[i]])[0].print())+"("+str(param_root.children[i].children.size())+")")
		if(_select_node(param_id,param_root.children[i])):
			return true
	pointer_node = param_root
	return param_id == param_root.id

func _depth_tool(param_id := root_node.id, param_root := root_node)->int:
	var dist := -1
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

func _create_boss(param_root : DungeonNode):
	pointer_node = param_root
	pointer_node.quality = 3
	var dir = [
		param_root.id - 1, 
		param_root.id + 1, 
		param_root.id + border_size, 
		param_root.id - border_size,].filter(_filter_boss)
	pointer_node.children = []
	for i  in range(0,dir.size()):
		_select_node(dir[i])
		_select_node(pointer_node.parent_id)
		pointer_node.children = pointer_node.children.filter(func(element : DungeonNode): return element.id != dir[i])

func _filter_boss(param_int : int):
	if(param_int == pointer_node.parent_id):
		return false
	for i in range(0, pointer_node.children.size()):
		if(pointer_node.children[i].id == param_int):
			return false
	return true

func _create_secret(param_root : DungeonNode):
	most_locked = -1
	param_root.quality = 4
	

func find_most_locked(param_root := root_node, param_lock := -1, 
param_arr : Array[DungeonNode] = []) -> Array[DungeonNode]:
	param_lock = param_root.lock_count
	if(param_root.quality == 0):
		if(param_lock == most_locked):
			param_arr.append(param_root)
		elif(param_lock > most_locked):
			#print(convert_these_cords([param_root])[0].print())
			most_locked = param_lock
			param_arr = [param_root]
	for i in range(0,param_root.children.size()):
		param_arr = find_most_locked(param_root.children[i],
			param_lock,param_arr)
	return param_arr


func convert_to_cords(param_root := root_node)->Array[Dun_Conv]:
	var entrance : int = _door_translate(param_root.parent_id - param_root.id) if param_root.parent_id != -1 else null
	var exit : int 
	for i in range(0, param_root.children.size()):
		if param_root.children[i].quality != 0:
			exit += _door_translate(param_root.children[i].id-param_root.id)
	var temp := Dun_Conv.new(
		(param_root.id-1)%border_size,
		(param_root.id-1)/border_size,
		param_root.quality,
		param_root.locked,
		entrance,
		exit)
	var node_values :Array[Dun_Conv]= []
	node_values.append(temp)
	for i in range(0,param_root.children.size()):
		node_values.append_array(
			convert_to_cords(param_root.children[i]))
	return node_values
	#node_list.append(obj)

func convert_these_cords(param_list : Array[DungeonNode]):
	var node_values := []
	for i in range(0,param_list.size()):
		var temp := Dun_Conv.new(
			(param_list[i].id-1)%border_size,
			(param_list[i].id-1)/border_size,
			param_list[i].quality,
			param_list[i].locked,
			null,
			null)
		node_values.append(temp)
	return node_values

func find_farthest_nodes(param_qual : int, param_root := root_node, param_depth := -1, 
param_arr : Array[DungeonNode] = [])->Array[DungeonNode]:
	param_depth = _depth_tool(param_root.id)
	if(param_root.quality == param_qual):
		if(param_depth == max_depth):
			param_arr.append(param_root)
		elif(param_depth > max_depth):
			#print(convert_these_cords([param_root])[0].print())
			max_depth = param_depth
			param_arr = [param_root]
	for i in range(0,param_root.children.size()):
		param_arr = find_farthest_nodes(param_qual, param_root.children[i],
			param_depth,param_arr)
	return param_arr
