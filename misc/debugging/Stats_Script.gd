class_name DebuggerOverlay extends CanvasLayer
#This is something i use for my own games, i use it to debug certain stuff by showing variables

@onready var cur_scene:= get_tree().current_scene

@export var float_steps: float = 0.01
var Stats: Array = []
#-----------------------------------------------------------------#
func add_stats(Stats_text: String = "",
				Target: String = "" , 
				node_name: String = "" ,
				property: String = "" ,
				Stat_color: String = ""):
	
	Stats.append([Stats_text, Target, node_name, property, Stat_color])

func _process(_delta: float) -> void:
	var label_text: String = ""
	
	var fps: = Engine.get_frames_per_second()
	label_text += str("FPS: ", fps)
	label_text += "\n"
	
	var memory = OS.get_static_memory_usage()
	label_text += str("Static Memory: ", String.humanize_size(memory))
	label_text += "\n"
	
	for s in Stats:
		var node_V2: Object = null
		var value = null
		
		if s[1] != "":
			node_V2 = cur_scene.find_child(s[1])
		
		if node_V2:
			value = get_node_property(node_V2, s[2], s[3])
			#rounds the numbers so they won't look like shit
			match typeof(value):
				TYPE_VECTOR3:
					value = _format_vector3(value)
				TYPE_VECTOR2:
					value = _format_vector2(value)
				TYPE_FLOAT:
					value = snapped(value, float_steps)
			value = str(value)
				
			#sets the text a color if given as a paramater (the last paramater in add_stats)
			label_text += _set_color((s[0]+ ": " + value) ,s[4]) if s[4] != "" else (s[0]+ ": " + value)
		else:
			if s[0].count("-") == 2:
				var text: String = s[0].replace("-", "")
				label_text += "----------- " + text + " -----------"
			
		
		label_text += "\n"
	
	$RichTextLabel.text = label_text

func get_node_property(targ: Object, node_name: String, property: String):
	var object: Object = targ.find_child(node_name) if node_name != "" else targ
	var variable = null
	
	if object:
		if object.has_method(property):
			variable = object.call(property)
		else:
			variable = object.get(property)
	
	return variable

func _set_color(text:String, color: String) -> String:
	return "[color="+ color + "]" + text + "[/color]"

func _format_vector3(vector) -> String:
	return ("%3.2f" % vector.x + " , " + "%3.2f" % vector.y + " , " + "%3.2f" % vector.z)

func _format_vector2(vector) -> String:
	return ("%5.3f" % vector.x + " , " + "%5.3f" % vector.y)
