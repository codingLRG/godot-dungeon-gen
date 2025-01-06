class_name Dun_Conv

var x_axis : int
var y_axis : int
var quality : int
var locked : bool
var entrance : int
var exits : int

func _init(param_x,param_y,param_q,param_l,param_ent,param_exi):
	x_axis = param_x
	y_axis = param_y
	quality = param_q
	locked = param_l
	entrance = param_ent if param_ent else -1
	exits = param_exi if param_exi else -1

func print()->String:
	var str = "[" + str(x_axis) +", " + str(y_axis) + "]"
	return str
	
