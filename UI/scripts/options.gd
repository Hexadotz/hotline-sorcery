extends Control

@export var pause_UI: PlayerUI
@export var menu_UI: CanvasLayer

#-------------------------------------------------------------#
func _ready() -> void:
	pass

func _physics_process(_delta: float) -> void:
	pass

func _on_close_pressed() -> void:
	hide()

func _on_show_fps_toggled(toggled_on: bool) -> void:
	if pause_UI:
		pause_UI.fps_label.visible = toggled_on
		GlobalVariables

func _on_disable_lights_toggled(toggled_on: bool) -> void:
	var cur_scene = get_tree().get_current_scene()
	if cur_scene:
		if cur_scene.has_method("set_floor_light"):
			cur_scene.set_floor_light(!toggled_on)
