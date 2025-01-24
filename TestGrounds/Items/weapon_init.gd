@tool
class_name Weapon extends RigidBody3D

@export var WEAPON_RESOURCE : WEAPON_TYPE
@onready var mesh : MeshInstance3D = %Mesh

var debugger = GlobalVar.debug

@onready var phy_hitbox : CollisionShape3D = %P_Hitbox
@onready var int_hitbox : CollisionShape3D = %InteractionArea/I_Hitbox
@onready var hrt_hitbox : CollisionShape3D = %HurtArea/H_Hitbox

@onready var state_machine : WeaponStateMachine = $WeaponStateMachine

var phy_material = self.physics_material_override

const GRAVITY_SCALE : float = 1

var is_equipped : bool = false
var equipped_player : CharacterBody3D = null

# Called when the node enters the scene tree for the first time.
func _ready():
	_load_weapon()
	
	pass # Replace with function body.

func _load_weapon():
	mesh.mesh = WEAPON_RESOURCE.mesh
	phy_hitbox.shape = WEAPON_RESOURCE.p_hitbox
	int_hitbox.shape = WEAPON_RESOURCE.i_hitbox 
	hrt_hitbox.shape = WEAPON_RESOURCE.t_hitbox
	
static func spawn_new(resource : WEAPON_TYPE, impulse : Vector3 = Vector3(0,0,0)) -> Weapon:
	var weapon_scene : PackedScene = load("uid://bb542r4ysussq")
	var new_weapon : Weapon = weapon_scene.instantiate()
	new_weapon.WEAPON_RESOURCE = resource
	new_weapon.apply_central_impulse(impulse)
	return new_weapon

func drop(player : Player):
	overworld()
	self.apply_central_impulse(3*-player.camera.global_basis.z + Vector3(0,1,0))

func equip(player : Player):
	state_machine.state.finished.emit("Equipped", {"player" : player})

func throw(player : Player):
	state_machine.state.finished.emit("Thrown", {"player" : player})
	self.apply_central_impulse(10*-player.camera.global_basis.z + Vector3(0,1,0))
	
func overworld():
	state_machine.state.finished.emit("Overworld")
	
func _process(delta):
	GlobalVar.add_debug("Weapon",self.global_position,1)
	pass
