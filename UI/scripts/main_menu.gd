extends Control

@onready var credits: Panel = $Credits
#--------------------------------------------------------#
func _ready() -> void:
	pass # Replace with function body.

#----------------Menu list buttons------------------------#
func _on_start_pressed() -> void:
	pass # Replace with function body.


func _on_options_pressed() -> void:
	pass # Replace with function body.


func _on_credits_pressed() -> void:
	credits.show()

func _on_quit_pressed() -> void:
	get_tree().quit()

#----------------------------------------------------------#
func _on_quit_credits_pressed() -> void:
	credits.hide()
