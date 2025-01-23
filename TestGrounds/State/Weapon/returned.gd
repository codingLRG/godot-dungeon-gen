extends WeaponState
@export var return_curve : Curve
var travel_time : float = 2
var sample_point : float = 0.0
var path_curve : Curve3D 
var path : Path3D
var path_follow : PathFollow3D
# handles unhandled inputs and allows for interaction upon InputEvent
func handle_input(_event: InputEvent) -> void:
	pass

# called every physics tick
func physics_update(delta) -> void:
	sample_point += delta
	path_follow.progress_ratio = return_curve.sample(sample_point)
	path_curve.set_point_position(1,equipped_player.camera.global_position)
	path.curve = path_curve
	if(path_follow.progress_ratio > 0.95):
		finished.emit("Equipped", {"player" : equipped_player})
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
func update(delta) -> void:
	pass

# called when state is entered, enum is for initialization
func enter(previous_state_path : String, data :={}) -> void:
	sample_point = 0
	path_curve = Curve3D.new()
	path = Path3D.new()
	path_follow = PathFollow3D.new()
	weapon.disable_gravity()
	equipped_player = data.player
	path_curve.add_point(weapon.global_position)
	path_curve.add_point(equipped_player.camera.global_position)
	path.curve = path_curve
	var scene = get_tree().root
	path.add_child(path_follow)
	scene.add_child(path)
	weapon.reparent(path_follow)
	path_follow.loop = false
	pass

# cleanup step of state
func exit() -> void:
	weapon.enable_gravity()
	weapon.reparent(get_tree().root)
	path.queue_free()
	path_curve = null
	pass
