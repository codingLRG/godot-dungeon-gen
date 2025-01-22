extends RigidBody3D

@onready var model : Resource = preload("uid://dwy0jqr0mjhay")

var return_to_sender : bool = false
var player : CharacterBody3D 

# Called when the node enters the scene tree for the first time.
func _ready():
	var parent = get_parent()
	for i in parent.get_children():
		if i is CharacterBody3D:
			player = i
			print(player)
	pass # Replace with function body.

func set_type(object : Resource):
	model = object

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if return_to_sender:
		self.global_position = lerp(self.global_position,player.global_position,delta)
	pass
	
func _load_model():
	var mesh :MeshInstance3D= $Damage_Object/Collision_Hitbox
	mesh.mesh = model.mesh
	

func _on_body_entered(body):
	var world = get_tree().root
	var weapon = Weapon.spawn_new(model)
	world.add_child(weapon)
	weapon.global_position = self.global_position
	weapon.apply_impulse(self.linear_velocity)
	queue_free()

func _on_damage_object_area_entered(area):
	pass # Replace with function body.
