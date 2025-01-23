extends WeaponState

# handles unhandled inputs and allows for interaction upon InputEvent
func handle_input(event: InputEvent) -> void:
	if event.is_action_pressed("attack"):
		attack(equipped_player.camera)
	pass

# called every physics tick
func physics_update(delta) -> void:
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
func update(delta) -> void:
	pass

# called when state is entered, enum is for initialization
func enter(previous_state_path : String, data :={}) -> void:
	weapon.int_hitbox.disabled = true
	weapon.phy_hitbox.disabled = true
	weapon.freeze = true
	equipped_player = data.player 
	weapon.reparent(equipped_player.hand)
	var origin_var = weapon.WEAPON_RESOURCE.position
	var rotation_var =  weapon.WEAPON_RESOURCE.rotation
	weapon.transform.origin = origin_var
	weapon.rotation_degrees = rotation_var
	
	pass

# cleanup step of state
func exit() -> void:
	weapon.freeze = false
	weapon.transform.origin = equipped_player.camera.transform.origin
	weapon.apply_central_impulse(-10 * equipped_player.transform.basis.z + Vector3(0,2,0))
	weapon.reparent(get_tree().root)
	pass
	
func attack(camera : Camera3D):
	# grabs current moment in the game and projects a ray with length of 1000, returns collision
	var space_state = camera.get_world_3d().direct_space_state
	var screen_center = get_viewport().size/2
	var origin = camera.project_ray_origin(screen_center)
	var end = origin + camera.project_ray_normal(screen_center) * 1000
	var query = PhysicsRayQueryParameters3D.create(origin,end)
	query.collide_with_bodies
	var result = space_state.intersect_ray(query)
	add_bullet_hole(result.get("position"))

func add_bullet_hole(position:Vector3):
	var hole_scene = load("uid://hilnx0x72nv0")
	var hole = hole_scene.instantiate()
	get_tree().root.add_child(hole)
	hole.global_position = position
	await get_tree().create_timer(3).timeout
	hole.queue_free()
	pass
