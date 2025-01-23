class_name Player extends CharacterBody3D


var speed : float
const WALK_SPEED = 3.0
const SPRINT_SPEED = 7.0
const JUMP_VELOCITY = 4.5
const BOB_FREQ = 0.03
const BOB_AMP = 0.03
var t_bob := 0.0

const BASE_FOV = 75.0
const FOV_CHANGE = 1.5

var init_weapon = preload("res://TestGrounds/Items/Weapon.tscn")

signal attack_trigger(object)
signal throw_trigger(camera : Camera3D, strength : float)

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
@onready var neck : Node3D = $Neck
@onready var camera : Camera3D = $Neck/Camera3D
@onready var hand : Node3D = $"Neck/Camera3D/Equipped Weapon"
func _ready():
	#SignalBus.equip_signal.connect(_equip_item)
	GlobalVar.player_cam = camera
	pass

func _unhandled_input(event: InputEvent)->void:
	if event is InputEventMouseButton:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	elif event.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		if event is InputEventMouseMotion:
			neck.rotate_y(-event.relative.x*0.003)
			camera.rotate_x(-event.relative.y*0.003)
			camera.rotation.x = clamp(camera.rotation.x,deg_to_rad(-80),deg_to_rad(90))
	if event.is_action_pressed("drop") and hand.get_child_count() != 0:
		_throw_weapon()
		pass

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
	#Handle sprint
	if Input.is_action_pressed("sprint"):
		speed = SPRINT_SPEED
	else:
		speed = WALK_SPEED

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("left", "right", "forward", "back")
	var direction = (neck.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if is_on_floor():
		if direction:
			velocity.x = direction.x * speed
			velocity.z = direction.z * speed
		else:
			velocity.x = lerp(velocity.x,direction.x * speed, delta * 10)
			velocity.z = lerp(velocity.z,direction.z * speed, delta * 10)
	else:
		velocity.x = lerp(velocity.x,direction.x * speed, delta * 3)
		velocity.z = lerp(velocity.z,direction.z * speed, delta * 3)
		
	#HEAD BOB
	t_bob += delta + velocity.length() + float(is_on_floor())
	neck.transform.origin = _headbob(t_bob) #probably not going to implement, will lead to innaccurate shots
	
	#FOV CHANGE
	var velocity_clamped = clamp(velocity.length(), 0.5, SPRINT_SPEED * 2)
	var target_fov = BASE_FOV + FOV_CHANGE * velocity_clamped
	camera.fov = lerp(camera.fov, target_fov, delta * 5.0)

	move_and_slide()
	
func _headbob(input) -> Vector3:
	var pos = Vector3.ZERO
	pos.y = sin(input * BOB_FREQ) * BOB_AMP
	pos.x = cos(input * BOB_FREQ/2) * BOB_AMP
	return pos
	
func _drop_item():
	var weapon : Weapon = hand.get_child(0)
	weapon.throw(self)
	pass
	
func _throw_weapon():
	# TO DO
	var weapon : Weapon = hand.get_child(0)
	weapon.throw(self)
	pass

func _on_interact_ray_player_update(object):
	print(object.get_parent())
	if object is Weapon:
		_equip_weapon(object)
	pass # Replace with function body.
	print(object.get_parent())

func _equip_weapon(object : Weapon):
	if hand.get_child_count() != 0:
		_drop_item()
	object.equip(self)
