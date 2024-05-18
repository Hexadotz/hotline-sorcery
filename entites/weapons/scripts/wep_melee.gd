extends RigidBody2D

@export var type: String = ""
@export var hurtbox: Area2D
@export var audio: AudioStreamPlayer
@export var throw_strength: float = 250.0

@onready var player_path: PlayerScript = null
@onready var collision_box: CollisionShape2D = $Collision #disables the rigidbody collision shape to prevent annoying bugs
@onready var cur_scene:= get_tree().current_scene

@export var FATAL_THROW: bool = false #if the weapon can kill after being thrown
var is_swinging: bool = false
var active: bool = true #disables the weapon if it's on the floor or on the back of the player
#-----------------------------------------------------------#
func _ready() -> void:
	#my precious little hack, my precious...
	player_path = get_tree().get_nodes_in_group("player")[0]
	active = false

func _physics_process(_delta: float) -> void:
	if Input.is_action_just_pressed("fire"):
		if active:
			is_swinging = true
			await  get_tree().create_timer(0.1).timeout
			is_swinging = false
			
	
	if is_swinging:
		swing()
	
	if Input.is_action_just_pressed("drop-pickup"):
		throw()
	
	if linear_velocity.length() < 75:
		hurtbox.throw_box.disabled = true

func swing() -> void:
	audio.play()
	var enemy_list: Array  = hurtbox.get_overlapping_bodies()
	for node in enemy_list:
		if node.is_in_group("enemy") and node.has_method("on_hit"):
			node.on_hit(throw_strength, global_position.normalized())

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
