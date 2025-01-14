@tool

class_name Weapon extends RigidBody3D

@export var WEAPON_RESOURCE : WEAPON_TYPE

@onready var mesh : MeshInstance3D = %Mesh
@onready var phy_hitbox : CollisionShape3D = %P_Hitbox

var dropped := false

signal equipped

# Called when the node enters the scene tree for the first time.
func _ready():
	if WEAPON_RESOURCE:
		_load_weapon()
	pass # Replace with function body.

func _process(delta):
	if dropped:
		apply_impulse(transform.basis.z, -transform.basis.z*50)
		dropped = false

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
