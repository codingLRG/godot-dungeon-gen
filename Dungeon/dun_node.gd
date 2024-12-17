class DungeonNode:
	var id : int #key
	var parent_id : int
	var children : Array[DungeonNode]
	var quality : int = 0
	#var lockedDoors
	#var blockedDoors #uncomment at a later time
	var locked : bool = false
	var lock_count : int = 0
	
	func _init(param_id : int,param_parent : int = 0):
		self.id = param_id
		self.parent_id = param_parent
	func _add_children(child_param : Array[DungeonNode]):
		for i in range(0,child_param.size()):
			self.children.append(child_param[i])
	func _lock():
		self.locked = true
		self.lock_count += 1
		
