extends Node

var debug : DebugScreen

func add_debug(title : String, value, index : int):
	debug.add_property(title,value,index)
