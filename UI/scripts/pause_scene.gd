class_name PlayerUI extends CanvasLayer

@export var player: PlayerScript
@export var score_lab: Label
@export var mult_lab: Label
@export var mult_timer: Timer

@onready var current_sc = get_tree().current_scene
@onready var pause_ui: CenterContainer = $Pause_UI
@onready var option_ui: Control = $options

@onready var post_process: TextureRect = $"Post Process"
@onready var floor_clr_text: CenterContainer = $floor_clr
@onready var fps_label: Label = $fps
@onready var HUD: Control = $HUD

@onready var mana_shader: ColorRect = $HUD/mana
@onready var mana_label: Label = $HUD/mana/Label

var is_paused: bool = true

var kill_mult: int = 1
var score: int = 0
const KILL_SCORE: int = 200

signal lvl_done
#NOTE: appearantly the ordering of the controle node actually do fucking matter
#meaning the PAUSE_UI NEEDS TO ALWAYS BE ON THE BUTTOM
#----------------------------------------------------------#
func _ready() -> void:
	score_lab.visible = false
	post_process.visible = true
	$HUD/restart.visible = false
	connect("lvl_done", show_floor_clear)
	player.connect("died", _on_player_death)
	current_sc.connect("level_started", _weapon_selection)
	
	for n in get_tree().get_nodes_in_group("enemy"):
		n.connect("enemy_died", _calculate_score)

func _physics_process(delta: float) -> void:
	
	var fps: float = Engine.get_frames_per_second()
	$fps.text = "FPS:" + str(fps)
	
	score_lab.text = str(score)
	if kill_mult > 1:
		mult_lab.text = "X" + str(kill_mult)
		mult_lab.visible = true
	else:
		mult_lab.visible = false
	
	#toggle the pause menu on or off
	if Input.is_action_just_pressed("ui_cancel"):
		is_paused = !is_paused
		if option_ui.visible:
			option_ui.visible = false
	
	#NOTE: i'm thinking about making the mouse mode confined to keep it from going from ouside the window
	#We also need a custom cursor
	Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED) if is_paused else Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	#show the pause menu if we're not is_paused else hide it
	get_tree().paused = !is_paused
	pause_ui.visible = !is_paused
	
	
	_mana_label(delta)


func _mana_label(delta: float) -> void:
	player.mana = clamp(player.mana, 0, 15)
	var rng: float = player.mana
	rng = lerp(rng, remap(player.mana, 0, 15, 0, 1), 0.2 * delta)
	
	mana_label.text = "Will: " + str(player.mana)
	mana_shader.material.set_shader_parameter("range", remap(player.mana, 0, 15, 0, 1))


func _calculate_score() -> void:
	score += (KILL_SCORE * kill_mult)
	kill_mult += 1
	mult_timer.start()

func show_floor_clear(txt: String = "") -> void:
	if txt == "":
		floor_clr_text.visible = true
		$floor_clr/all_clear_signal.start()
	else:
		$floor_clr/Label.text = "Building cleared"
		
		floor_clr_text.visible = true
		$floor_clr/all_clear_signal.start()

func _weapon_selection() -> void:
	$HUD/CenterContainer.visible = true
	player.wep_manager.staff.active = false

func _on_player_death() -> void:
	$HUD/restart.visible = true

#--------------------------------------------------------------------------#
func _on_resume_pressed() -> void:
	is_paused = true

func _on_restart_pressed() -> void:
	get_tree().reload_current_scene()

func _on_options_pressed() -> void:
	option_ui.visible = !option_ui.visible

func _on_menu_pressed() -> void:
	pass

func _on_exit_pressed() -> void:
	get_tree().quit()

#--------------------------------------------------------#
func _on_item_list_item_activated(index: int) -> void:
	player.wep_manager.staff.weapon_type = index
	player.wep_manager.staff.active = true
	$HUD/CenterContainer.visible = false
	score_lab.visible = true

func _on_mult_timer_timeout() -> void:
	kill_mult = 1

func _on_all_clear_signal_timeout() -> void:
	floor_clr_text.visible = false
