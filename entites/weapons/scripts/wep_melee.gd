extends RigidBody2D

@export var throw_box: CollisionShape2D 
@export var swing_box: CollisionShape2D 
@export var hurtArea: Area2D 
@export var audio: AudioStreamPlayer
@export var throw_strength: float = 250.0

@onready var player_path: PlayerScript = null
@onready var collision_box: CollisionShape2D = $Collision #disables the rigidbody collision shape to prevent annoying bugs
@onready var cur_scene:= get_tree().current_scene

var is_held: bool = false #keeps track if the weapon is being held by the player
var active: bool = true #disables the weapon if it's on the floor or on the back of the player
#-----------------------------------------------------------#
#NOTE: how the fuck am i supposed to get a reference to the player?
#one day later... you fucking retard, just use the groups or an autoload
func _ready() -> void:
	#my precious little hack, my precious...
	player_path = get_tree().get_nodes_in_group("player")[0]
	active = false
	swing_box.disabled = true
	throw_box.disabled = true

func _physics_process(_delta: float) -> void:
	
	if Input.is_action_just_pressed("fire"):
		if active:
			swing()
	
	if Input.is_action_just_pressed("drop-pickup"):
		throw()

func swing() -> void:
	audio.play()
	var enemy_list: Array  = hurtArea.get_overlapping_bodies()
	for node in enemy_list:
		if node.is_in_group("enemy") and node.has_method("on_hit"):
			node.on_hit(throw_strength, global_position.normalized())

func pickup() -> void:
	#when we pickup the weapon, we disable its physics property as well as it's collision shape
	is_held = true
	freeze = true
	active = true
	collision_box.disabled = true
	swing_box.disabled = false
	throw_box.disabled = true
	linear_velocity = Vector2.ZERO

#NOTE: i hate how this looks man, goddamn it
func throw() -> void:
	if is_held:
		reparent(cur_scene)
		freeze = false
		linear_velocity = player_path.looking_at() * throw_strength
		collision_box.disabled = false
		swing_box.disabled = true
		throw_box.disabled = false
		is_held = false
		
		#disable the weapon functionality after we throw it
		active = false

func _on_throw_hurtbox_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemy"):
		if body.has_method("on_hit"):
			if linear_velocity.length() > (throw_strength * 0.7):
				body.on_hit(throw_strength, linear_velocity.normalized())
