class_name InteractionArea extends Area3D

signal on_hover
signal off_hover
signal interacted

var disabled : bool = false

var parent : Node
var mesh : MeshInstance3D
var i_hitbox : CollisionShape3D
@onready var overlay = preload("uid://m3fwn2be3pgh")

func _ready():
	parent = get_parent()
	get_mesh()
	connect_signals()

func focus():
	mesh.material_overlay = overlay
	pass
	
func unfocus():
	mesh.material_overlay = null
	pass
	
func connect_signals():
	on_hover.connect(focus)
	off_hover.connect(unfocus)
	
func get_mesh():
	for i in parent.get_children():
		if i is MeshInstance3D:
			mesh = i

func disable_box():
	if disabled:
		disabled = false		
	else:
		disabled = true
	i_hitbox.disabled = disabled
