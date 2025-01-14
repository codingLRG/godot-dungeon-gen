class_name InteractionArea extends Area3D

signal on_hover
signal off_hover
signal interacted
signal disable

var parent : Node
var mesh : MeshInstance3D
@onready var overlay = preload("uid://m3fwn2be3pgh")
@export var i_hitbox_shape : Shape3D

func _ready():
	parent = get_parent()
	get_mesh()
	create_hitbox()
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
			
func create_hitbox():
	var i_hitbox := CollisionShape3D.new()
	i_hitbox.shape = i_hitbox_shape
	print(i_hitbox.scale)
	add_child(i_hitbox)
