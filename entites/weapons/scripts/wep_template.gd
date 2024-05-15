class_name Weapon extends RigidBody2D

@export_enum("melee", "ranged") var projectile_type: int
@export var throw_strength: float = 250.0

@onready var player_path: PlayerScript = null
@onready var collision_box: CollisionShape2D = $Collision #disables the rigidbody collision shape to prevent annoying bugs
@onready var cur_scene:= get_tree().current_scene

var is_held: bool = false #keeps track if the weapon is being held by the player
var active: bool = true #disables the weapon if it's on the floor or on the back of the player
#-----------------------------------------------------------#
#NOTE: how the fuck am i supposed to get a reference to the player?
func _ready() -> void:
	#my precious little hack, my precious...
	player_path = get_tree().get_nodes_in_group("player")[0]

func _physics_process(_delta: float) -> void:
	if Input.is_action_just_pressed("drop-pickup"):
		throw()

func pickup() -> void:
	#when we pickup the weapon, we disable its physics property as well as it's collision shape
	is_held = true
	freeze = true
	active = true
	collision_box.disabled = true
	linear_velocity = Vector2.ZERO

func throw() -> void:
	if is_held:
		reparent(cur_scene)
		freeze = false
		linear_velocity = player_path.looking_at() * throw_strength
		collision_box.disabled = false
		is_held = false
		#disable the weapon functionality after we throw it
		active = false
