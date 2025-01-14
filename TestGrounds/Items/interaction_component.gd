class_name interaction_component extends Node

var parent : Node
var mesh : MeshInstance3D

# Called when the node enters the scene tree for the first time.
func _ready():
	parent = get_parent()
	get_mesh()
	connect_parent()
	pass # Replace with function body.

func on_hover():
	print("Hovered")
	pass
	
func off_hover():
	print("Off hovered")
	pass
	
func interacted():
	print(parent)
	pass
	
func connect_parent():
	parent.add_user_signal("on_hover")
	parent.add_user_signal("off_hover")
	parent.add_user_signal("interacted")
	parent.connect("on_hover",Callable(self,"on_hover"))
	parent.connect("off_hover",Callable(self,"off_hover"))
	parent.connect("interacted",Callable(self,"interacted"))
	pass
	
func get_mesh():
	for i in parent.get_children():
		if i is MeshInstance3D:
			mesh = i
