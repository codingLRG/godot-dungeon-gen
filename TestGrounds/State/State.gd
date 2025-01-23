class_name State extends Node

# used to signal the end of a state and transfering to a new state
signal finished(next_stage_path : String, data : Dictionary)

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
	pass

# cleanup step of state
func exit() -> void:
	pass
