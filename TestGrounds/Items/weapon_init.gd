@tool

class_name Weapon extends RigidBody3D

@export var WEAPON_RESOURCE : WEAPON_TYPE

@onready var mesh : MeshInstance3D = %Mesh
@onready var phy_hitbox : CollisionShape3D = %P_Hitbox

@onready var int_hitbox : CollisionShape3D = %Interaction_Area/I_Hitbox



var is_equipped : bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	_load_weapon()
	pass # Replace with function body.

func equip_weapon(weapon : WEAPON_TYPE = null, player : bool = false):
	WEAPON_RESOURCE = weapon
	_load_weapon()

func _physics_process(delta):
	pass

func _load_weapon():
	mesh.mesh = WEAPON_RESOURCE.mesh if WEAPON_RESOURCE.mesh_weapon != null else null
	phy_hitbox.shape = WEAPON_RESOURCE.p_hitbox if WEAPON_RESOURCE.p_hitbox != null else null
	int_hitbox.shape = WEAPON_RESOURCE.i_hitbox if WEAPON_RESOURCE.i_hitbox != null else null
	
static func spawn_new(resource : WEAPON_TYPE, impulse : Vector3 = Vector3(0,0,0)) -> Weapon:
	var weapon_scene : PackedScene = load("uid://bb542r4ysussq")
	var new_weapon : Weapon = weapon_scene.instantiate()
	new_weapon.WEAPON_RESOURCE = resource
	new_weapon.apply_central_impulse(impulse)
	return new_weapon
	
func equipped():
	self.freeze = true
	var origin_var = WEAPON_RESOURCE.position
	var rotation_var = WEAPON_RESOURCE.rotation
	transform.origin = origin_var
	rotation_degrees = rotation_var
	toggle_hitboxes()
	pass
	
func unequipped():
	self.freeze = false
	toggle_hitboxes()
	
func toggle_hitboxes():
	int_hitbox.disabled = not int_hitbox.disabled
	phy_hitbox.disabled = not phy_hitbox.disabled

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
