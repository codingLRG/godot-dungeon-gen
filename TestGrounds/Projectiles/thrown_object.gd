extends RigidBody3D

var model : Resource

# Called when the node enters the scene tree for the first time.
func _ready():
	
	pass # Replace with function body.

func set_type(object : Resource):
	model = object

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _load_model():
	var mesh :MeshInstance3D= $Damage_Object/Collision_Hitbox
	mesh.mesh = model.mesh
	

func _on_body_entered(body):
	var world = get_tree().root
	var weapon = Weapon.spawn_new(model)
	world.add_child(weapon)
	queue_free()
	


func _on_damage_object_area_entered(area):
	pass # Replace with function body.
