extends Control

@onready var credits: Panel = $Credits
@onready var start_panel: Panel = $start_game
#--------------------------------------------------------#
func _ready() -> void:
	pass

#----------------Menu list buttons------------------------#
func _on_start_pressed() -> void:
	start_panel.visible = true

func _on_options_pressed() -> void:
	$options.visible = true

func _on_credits_pressed() -> void:
	credits.show()

func _on_quit_pressed() -> void:
	get_tree().quit()

#----------------------------------------------------------#
func _on_quit_credits_pressed() -> void:
	credits.hide()

#--------------------------------------------------------#
func _on_start_level_pressed() -> void:
	get_tree().change_scene_to_file("res://levels/lvl_1_Fl_A.tscn")

func _on_back_to_mm_pressed() -> void:
	start_panel.visible = false
