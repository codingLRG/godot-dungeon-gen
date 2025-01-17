class_name Throwable extends Area3D

signal throw

var parent : Node
var thrown : bool = false
@export var damage_resource : DAMAGE_TYPE

func _ready():
	parent = get_parent()
	connect_signals()

func connect_signals():
	pass

func _physics_process(delta):
	#parent.rotation_degrees.z += 1
	pass
			
