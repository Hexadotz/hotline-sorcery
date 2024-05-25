class_name PlayerUI extends CanvasLayer

@onready var player: PlayerScript = GlobalVariables.player
@onready var pause_ui: CenterContainer = $Pause_UI
@onready var post_process: TextureRect = $"Post Process" 
@onready var HUD: Control = $HUD

var is_paused: bool = true
#NOTE: appearantly the ordering of the controle node actually do fucking matter
#meaning the PAUSE_UI NEEDS TO ALWAYS BE ON THE BUTTOM
#----------------------------------------------------------#
func _ready() -> void:
	post_process.visible = true

func _physics_process(_delta: float) -> void:
	#toggle the pause menu on or off
	if Input.is_action_just_pressed("ui_cancel"):
		is_paused = !is_paused
	
	#NOTE: i'm thinking about making the mouse mode confined to keep it from going from ouside the window
	#We also need a custom cursor
	Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED) if is_paused else Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	#show the pause menu if we're not is_paused else hide it
	get_tree().paused = !is_paused
	pause_ui.visible = !is_paused

func switch_floor() -> void:
	var tween: Tween = get_tree().create_tween()
	
	tween.tween_property($switch_floor, "modulate", Color(1, 1, 1, 1), 5)
	tween.tween_property($switch_floor, "modulate", Color(1, 1, 1, 0), 5)


#--------------------------------------------------------------------------#
func _on_resume_pressed() -> void:
	is_paused = true

func _on_restart_pressed() -> void:
	get_tree().reload_current_scene()

func _on_options_pressed() -> void:
	pass # Replace with function body.

func _on_menu_pressed() -> void:
	pass # Replace with function body.

func _on_exit_pressed() -> void:
	get_tree().quit()

