extends WeaponState
@export var return_curve : Curve
var travel_time : float = 2
var sample_point : float = 0.0

var equipped_player : Player

var path_curve : Curve3D 
var path : Path3D
var path_follow : PathFollow3D

# handles unhandled inputs and allows for interaction upon InputEvent
func handle_input(_event: InputEvent) -> void:
	pass

# called every physics tick
func physics_update(delta) -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func update(delta) -> void:
	pass

# called when state is entered, enum is for initialization
func enter(previous_state_path : String, data :={}) -> void:
	weapon.phy_hitbox.disabled = true
	weapon.int_hitbox.disabled = true
	weapon.gravity_scale = 0
	pass

# cleanup step of state
func exit() -> void:
	weapon.phy_hitbox.disabled = false
	weapon.int_hitbox.disabled = false
	weapon.gravity_scale = weapon.GRAVITY_SCALE
	pass
