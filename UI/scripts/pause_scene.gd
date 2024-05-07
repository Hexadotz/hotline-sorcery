extends CanvasLayer

var captured: bool = true
#----------------------------------------------------------#
func _physics_process(_delta: float) -> void:
	#toggle the pause menu on or off
	if Input.is_action_just_pressed("ui_cancel"):
		captured = !captured
	
	#NOTE: i'm thinking about making the mouse mode confined to keep it from going from ouside the window
	#We also need a custom cursor
	Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED) if captured else Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	get_tree().paused = !captured
	
	#show the pause menu if we're not captured else hide it
	show() if !captured else hide()

func _on_resume_pressed() -> void:
	captured = true

func _on_restart_pressed() -> void:
	get_tree().reload_current_scene()

func _on_options_pressed() -> void:
	pass

#go to the main menu (still WIP because uh... we need a menu in the first place)
func _on_menu_pressed() -> void:
	pass

func _on_quit_pressed() -> void:
	get_tree().quit()


