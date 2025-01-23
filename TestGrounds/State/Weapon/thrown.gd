extends WeaponState
@export var gravity_curve : Curve
var point : float = 0
var collided : bool = false
# Called when the node enters the scene tree for the first time.
func enter(previous_state_path : String, data :={}):
	weapon.phy_hitbox.disabled = false
	var phy_material = PhysicsMaterial.new()
	phy_material.bounce = .8
	weapon.physics_material_override = phy_material
	weapon.disable_gravity()
	equipped_player = data.player
	weapon.freeze = false
	weapon.apply_central_impulse(-10 * equipped_player.camera.transform.basis.z)
	
func exit():
	point = 0
	collided = false
	weapon.enable_gravity()
	weapon.physics_material_override = null
	pass
	
func physics_update(delta):
	point += delta
	if weapon.gravity_scale < weapon.GRAVITY_SCALE:
		weapon.gravity_scale = gravity_curve.sample(point)
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.


func update(delta):
	pass




func _on_weapon_body_entered(body):
	if not collided: 
		collided = true
		weapon.gravity_scale = weapon.GRAVITY_SCALE
		print("COLLISION")
		await get_tree().create_timer(1.0).timeout
		finished.emit("Returned", {"player" : equipped_player})

