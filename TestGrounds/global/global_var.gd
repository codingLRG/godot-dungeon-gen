extends Node

var queue_for_removal : Array[Node]
var equipped_weapon : WEAPON_TYPE


func clear_queue():
	for i in queue_for_removal.size():
		print("Removing %s" %[queue_for_removal[i]])
		queue_for_removal[i].queue_free()
	queue_for_removal = []
	pass
