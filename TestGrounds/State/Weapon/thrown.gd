extends WeaponState
@export var gravity_curve : Curve

signal collided

var collision : bool = false

var point : float = 0
var equipped_player : Player 

# Called when the node enters the scene tree for the first time.
func enter(previous_state_path : String, data :={}):
	weapon.int_hitbox.disabled = true
	weapon.gravity_scale = 0
	equipped_player = data.player
	weapon.global_position = equipped_player.camera.global_position
	collision = false
	var phy_material = PhysicsMaterial.new()
	phy_material.bounce = .5 # Maybe weapon resource in the future?
	weapon.physics_material_override = phy_material
	
	
	
func exit():
	## init state
	point = 0
	
	
	weapon.int_hitbox.disabled = false
	weapon.gravity_scale = weapon.GRAVITY_SCALE
	weapon.physics_material_override = weapon.phy_material
	pass
	
func physics_update(delta):
	point += delta
	weapon.rotate_z(0.2)
	if weapon.gravity_scale < weapon.GRAVITY_SCALE:
		weapon.gravity_scale = gravity_curve.sample(point)
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func update(delta):
	if collision:
		collided.emit()
	pass


func _on_weapon_body_entered(body):
	collision = true
	pass # Replace with function body.
