@tool
class_name Weapon extends RigidBody3D

@export var WEAPON_RESOURCE : WEAPON_TYPE
@onready var mesh : MeshInstance3D = %Mesh

@onready var phy_hitbox : CollisionShape3D = %P_Hitbox
@onready var int_hitbox : CollisionShape3D = %Interaction_Area/I_Hitbox
@onready var state_machine : WeaponStateMachine = $State_Machine

var is_equipped : bool = false
var equipped_player : CharacterBody3D = null

# Called when the node enters the scene tree for the first time.
func _ready():
	_load_weapon()
	pass # Replace with function body.

func _load_weapon():
	mesh.mesh = WEAPON_RESOURCE.mesh if WEAPON_RESOURCE.mesh != null else null
	phy_hitbox.shape = WEAPON_RESOURCE.p_hitbox if WEAPON_RESOURCE.p_hitbox != null else null
	int_hitbox.shape = WEAPON_RESOURCE.i_hitbox if WEAPON_RESOURCE.i_hitbox != null else null
	
static func spawn_new(resource : WEAPON_TYPE, impulse : Vector3 = Vector3(0,0,0)) -> Weapon:
	var weapon_scene : PackedScene = load("uid://bb542r4ysussq")
	var new_weapon : Weapon = weapon_scene.instantiate()
	new_weapon.WEAPON_RESOURCE = resource
	new_weapon.apply_central_impulse(impulse)
	return new_weapon

func drop():
	state_machine.state.finished.emit("Overworld")

func equip(player : Player):
	state_machine.state.finished.emit("Equipped",{"player" : player} )
