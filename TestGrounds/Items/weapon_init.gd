@tool

class_name Weapon extends RigidBody3D

@export var WEAPON_RESOURCE : WEAPON_TYPE

@onready var mesh : MeshInstance3D = %Mesh
@onready var phy_hitbox : CollisionShape3D = %P_Hitbox

@onready var int_hitbox : CollisionShape3D = %Interaction_Area/I_Hitbox
@onready var thr_hitbox : CollisionShape3D = %Throwable/T_Hitbox

var is_equipped : bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	_load_weapon()
	pass # Replace with function body.

func equip_weapon(weapon : WEAPON_TYPE = null, player : bool = false):
	WEAPON_RESOURCE = weapon
	_load_weapon()

func _load_weapon():
	mesh.mesh = WEAPON_RESOURCE.mesh_weapon if WEAPON_RESOURCE.mesh_weapon else null
	phy_hitbox.shape = WEAPON_RESOURCE.p_hitbox if WEAPON_RESOURCE.p_hitbox else null
	int_hitbox.shape = WEAPON_RESOURCE.i_hitbox if WEAPON_RESOURCE.i_hitbox else null
	thr_hitbox.shape = WEAPON_RESOURCE.t_hitbox if WEAPON_RESOURCE.t_hitbox else null
	
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
	int_hitbox.disabled = true
	phy_hitbox.disabled = true
	pass
	
func unequipped():
	self.freeze = false
	int_hitbox.disabled = false
	phy_hitbox.disabled = false

