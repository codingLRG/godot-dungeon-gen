extends Node

var parent : Weapon
var returned : bool

signal throw(player : CharacterBody3D)

# Called when the node enters the scene tree for the first time.
func _ready():
	parent = get_parent()
	_connect_parent()
	pass # Replace with function body.

func _connect_parent():
	parent.add_user_signal("throw")
	parent.connect("throw",thrown_object)
	pass

func thrown_object(player : CharacterBody3D):
	print(player)
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
