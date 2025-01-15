@tool

class_name Weapon extends RigidBody3D

@export var WEAPON_RESOURCE : WEAPON_TYPE

@onready var mesh : MeshInstance3D = %Mesh
@onready var phy_hitbox : CollisionShape3D = %P_Hitbox

signal equipped

# Called when the node enters the scene tree for the first time.
func _ready():
	if WEAPON_RESOURCE:
		_load_weapon()
	pass # Replace with function body.

func _on_interaction_area_interacted():
	var temp = WEAPON_RESOURCE
	print("WEAPON RESOURCE: %s \nEQUIPPED: %s\n" %[WEAPON_RESOURCE,GlobalVar.equipped_weapon])
	WEAPON_RESOURCE = GlobalVar.equipped_weapon
	GlobalVar.equipped_weapon = temp
	SignalBus.equip_signal.emit()
	equip_weapon(WEAPON_RESOURCE)

func equip_weapon(weapon : WEAPON_TYPE = null, player : bool = false):
	if weapon == null and not player:
		self.queue_free()
	else:
		WEAPON_RESOURCE = weapon
		_load_weapon()

func _load_weapon():
	mesh.mesh = WEAPON_RESOURCE.mesh_weapon if WEAPON_RESOURCE else null
	phy_hitbox.shape = WEAPON_RESOURCE.p_hitbox if WEAPON_RESOURCE else null

func drop_weapon():
	if WEAPON_RESOURCE != null:
		var root = get_tree().get_root()
		apply_impulse(self.transform.basis.z, -self.transform.basis.z*10)
		WEAPON_RESOURCE = null
		_load_weapon()
	pass
	
static func spawn_new(resource : WEAPON_TYPE, basis : Basis, location : Vector3, impulse : Vector3 = Vector3(0,0,0)) -> Weapon:
	var weapon_scene : PackedScene = load("uid://bb542r4ysussq")
	var new_weapon : Weapon = weapon_scene.instantiate()
	new_weapon.WEAPON_RESOURCE = resource
	var thrown_dir = (basis * impulse).normalized()
	new_weapon.apply_impulse(thrown_dir)
	new_weapon.transform.origin = location
	return new_weapon
