class_name DebugScreen extends PanelContainer

@onready var property_container = %VBoxContainer

# Called when the node enters the scene tree for the first time.
func _ready():
	GlobalVar.debug = self
	visible = false
	
func _unhandled_input(event):
	if event.is_action_pressed("debug"):
		visible = not visible

func add_property(title: String, value,order):
	var target
	target = property_container.find_child(title,true,false)
	if not target:
		target = Label.new()
		property_container.add_child(target)
		target.name = title
		target.text = title + ": " + str(value)
	elif visible:
		target.text = title + ": " + str(value)
		property_container.move_child(target,order)
