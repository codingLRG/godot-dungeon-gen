extends WeaponState

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
	weapon.hrt_hitbox.disabled = true
	pass

# cleanup step of state
func exit() -> void:
	weapon.hrt_hitbox.disabled = false
	pass
