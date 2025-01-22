class_name WeaponStateMachine extends Node

@export var init_state : State = null
## The current state of the state machine.
@onready var state: State = (func get_initial_state() -> State:
	return init_state if init_state != null else get_child(0)
).call()
# Called when the node enters the scene tree for the first time.
func _ready():
	for state_node : State in find_children("*","State"):
		state_node.finished.connect(_transition)
	# State machines usually access data from the root node of the scene they're part of: the owner.
	# We wait for the owner to be ready to guarantee all the data and nodes the states may need are available.
	await owner.ready
	state.enter("")

func _transition(target_state_path: String, data: Dictionary = {}):
	if not has_node(target_state_path):
		# if trying to access non existant state, print error
		printerr("%s: Trying to transition to state %s but it does not exist." % [owner.name, target_state_path])
		return
	
	# holding previous state to pass through new state with previous state data
	var previous_state_path := state.name
	state.exit()
	state = get_node(target_state_path)
	state.enter(previous_state_path, data)

func _unhandled_input(event: InputEvent) -> void:
	state.handle_input(event)

func _process(delta: float) -> void:
	state.update(delta)

func _physics_process(delta: float) -> void:
	state.physics_update(delta)
