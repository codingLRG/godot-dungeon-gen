extends RayCast3D

var previous_interact : Node
signal player_update(object)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var current_interact = get_collider()
	# if the collider hasn't detected anything new, ignore all these processes in order to save on memory
	if current_interact != previous_interact:
		if previous_interact != null and previous_interact.has_signal("off_hover"):
			previous_interact.emit_signal("off_hover")
		if current_interact != null and current_interact.has_signal("on_hover"):
			current_interact.emit_signal("on_hover")
		previous_interact = current_interact
	if Input.is_action_just_pressed("interact"):
		_interaction()


func _interaction():
	if previous_interact != null and previous_interact.has_signal("interacted"):
		previous_interact.emit_signal("interacted")
		player_update.emit(previous_interact.get_parent())
