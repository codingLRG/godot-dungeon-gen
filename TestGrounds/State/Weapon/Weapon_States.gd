class_name WeaponState extends State

const OVERWORLD = "overworld"
const EQUIPPED = "equipped"
const THROWN = "thrown"

var weapon : Weapon
var equipped_player : Player

func _ready():
	await owner.ready
	weapon = owner as Weapon
	assert(weapon != null, "The WeaponState state type must be used only in the weapon scene. 
		It needs the owner to be a Weapon node.")
	pass
