extends RigidBody2D

@export var type: String = ""
@export var hurtbox: Area2D
@export var audio: AudioStreamPlayer
@export var throw_strength: float = 250.0

@onready var player_path: PlayerScript = get_tree().get_nodes_in_group("player")[0]
@onready var collision_box: CollisionShape2D = $Collision #disables the rigidbody collision shape to prevent annoying bugs
@onready var cur_scene:= get_tree().current_scene

@export var FATAL_THROW: bool = false #if the weapon can kill after being thrown
var is_swinging: bool = false
var active: bool = true #disables the weapon if it's on the floor or on the back of the player
#-----------------------------------------------------------#
func _ready() -> void:
	active = false

func _physics_process(_delta: float) -> void:
	if Input.is_action_just_pressed("fire") and get_parent() != cur_scene:
		if active:
			swing()
	
	if Input.is_action_just_pressed("drop-pickup"):
		throw()
	
	if linear_velocity.length() < 75:
		hurtbox.throw_box.disabled = true

func swing() -> void:
	if not audio.is_playing():
		audio.play()
	$AnimationPlayer.play("shit")
	var enemy_list: Array  = hurtbox.get_overlapping_bodies()
	for node in enemy_list:
		if node.is_in_group("enemy"):  
			node.on_hit(throw_strength, global_position.direction_to(node.global_position))
	
	active = false
	$cooldown.start()

func pickup() -> void:
	#when we pickup the weapon, we disable its physics property as well as it's collision shape
	freeze = true
	active = true
	collision_box.disabled = true
	hurtbox.swing_box.disabled = false
	hurtbox.throw_box.disabled = true
	linear_velocity = Vector2.ZERO

#NOTE: i hate how this looks man, goddamn it
func throw() -> void:
	if active:
		reparent(cur_scene)
		freeze = false
		linear_velocity = player_path.looking_at() * throw_strength
		collision_box.disabled = false
		hurtbox.swing_box.disabled = true
		hurtbox.throw_box.disabled = false
		
		#disable the weapon functionality after we throw it
		active = false

func _on_cooldown_timeout() -> void:
	if get_parent() != cur_scene:
		active = true
