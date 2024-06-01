extends Control

@export var pause_UI: PlayerUI
@export var menu_UI: CanvasLayer

#-------------------------------------------------------------#
func _ready() -> void:
	$CenterContainer/Panel/HBoxContainer/buttons/showFps.button_pressed = GlobalVariables.show_fps
	$CenterContainer/Panel/HBoxContainer/buttons/disableLights.button_pressed = !GlobalVariables.disable_lights

func _physics_process(_delta: float) -> void:
	pass

func _on_close_pressed() -> void:
	hide()

func _on_show_fps_toggled(toggled_on: bool) -> void:
	if pause_UI:
		GlobalVariables.show_fps = toggled_on

func _on_disable_lights_toggled(toggled_on: bool) -> void:
	GlobalVariables.disable_lights = !toggled_on
	var cur_scene = get_tree().get_current_scene()
	if cur_scene:
		if cur_scene.has_method("set_floor_light"):
			cur_scene.set_floor_light(!toggled_on)
