extends Node2D

@export var background: ColorRect 

@onready var player = get_tree().current_scene.get_node("player")

@onready var floor_A: Node2D = $"Floor A/FloorA"
@onready var floor_B: Node2D = $"Floor B/FloorB"
@onready var floor_C: Node2D = $"Floor C/FloorC"

@onready var music_player: AudioStreamPlayer = $music
@onready var cutscene_cam: Camera2D = $Cutscene_Camera
const OFFSET: Vector2 = Vector2(500, 500)

var cur_floor: int = 0

var level_clear: bool = false

var A_clear: bool = false
var A_clear_instant: bool = false

var B_clear: bool = false
var B_clear_instant: bool = false

var C_clear: bool = false
var C_clear_instant: bool = false

signal level_started
signal switched_floor
signal floor_cleared

var stunts: Array = []
#-------------musics---------------#
@onready var credits_music: AudioStreamMP3 = preload("res://sound/music/43-journey-onward-loop-retrowave-128-ytshorts.savetube.me.mp3")
@onready var lvl_clear_music: AudioStreamMP3 = preload("res://sound/menu_ambience.mp3")
@onready var combat_music: AudioStreamMP3 = preload("res://sound/music/fairy_dust.mp3")
#----------------------------------------------------------#
func _ready() -> void:
	level_started.emit()
	for x in get_tree().get_nodes_in_group("enemy"):
		x.connect("enemy_died", _check_floor_clear)
	cur_floor = 0
	
	music_player.stream = combat_music

func _physics_process(_delta: float) -> void:
	A_clear = _is_floor_clear($"Floor A/enemies")
	B_clear = _is_floor_clear($"Floor B/enemies")
	C_clear = _is_floor_clear($"Floor C/enemies")
	
	level_clear = C_clear
	
	if !music_player.is_playing():
		music_player.play()
	
	if go_up:
		cutscene_cam.global_position.y -= 30 * get_physics_process_delta_time()
		background.global_position = cutscene_cam.global_position - OFFSET
	else:
		background.global_position = player.global_position - OFFSET

func _background_colors() -> void:
	pass

func _is_floor_clear(entites: Node2D) -> bool:
	for x in entites.get_children():
		if x.is_in_group("enemy"):
			if not x.IS_DEAD:
				return false
	
	return true

func set_floor_light(value: bool) -> void:
	var lights: Array = $"Floor A/lights".get_children()
	lights.append_array($"Floor B/lights".get_children())
	lights.append_array($"Floor C/lights".get_children())
	
	for light in lights:
		if light is PointLight2D:
			light.enabled = value
			light.shadow_enabled = value

func _check_floor_clear() -> void:
	await get_tree().create_timer(0.1).timeout
	if A_clear and !A_clear_instant:
		player.UI.emit_signal("lvl_done")
		A_clear_instant = true
	elif B_clear and !B_clear_instant:
		player.UI.emit_signal("lvl_done")
		B_clear_instant = true
	elif C_clear: 
		player.UI.emit_signal("lvl_done", "balls")
		
		music_player.stream = preload("res://sound/sfx/HM_lvlClear.mp3")
		music_player.play()
		
		await music_player.finished
		
		music_player.stream = lvl_clear_music
		music_player.play()

#-----------------------Floor A----------------------------#
func _on_to_B_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		if A_clear and not level_clear:
			cur_floor = 1
			
			emit_signal("switched_floor", $"Floor B/TO_A".global_position)

#-----------------------Floor B----------------------------#
func _on_BACK_TO_A_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		if level_clear:
			cur_floor = 0
			
			emit_signal("switched_floor", $"Floor A/TO_B".global_position)

func _on_TO_C_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		if B_clear and not level_clear:
			cur_floor = 2
			
			emit_signal("switched_floor", $"Floor C/TO_B".global_position)
#-----------------------Floor C----------------------------#
func _on_BACK_TO_B_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		if level_clear:
			cur_floor = 1
			
			emit_signal("switched_floor", $"Floor B/TO_C".global_position)
#---------------------------------------------------------#
var go_up: bool = false
func _on_level_complete_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		#if level_clear:
			music_player.stream = credits_music
			music_player.play()
			body.LOCK_MOVE = true
			cutscene_cam.make_current()
			player.UI.HUD.visible = false
			cutscene_cam.global_position = body.global_position
			go_up = true
			
			$level_boundry/CollisionPolygon2D.call_deferred("set_disabled", true)
			await get_tree().create_timer(20).timeout
			
			$Cutscene_Camera/AnimationPlayer.play("roll_credits")
