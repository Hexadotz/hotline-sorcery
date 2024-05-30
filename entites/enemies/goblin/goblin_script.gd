@tool
class_name Goblin extends CharacterBody2D

@export var inital_state: STATES
@export var visible_eyesight: bool = true
@export var patrol_path: PathFollow2D ##the path the enemy will follow when patrolling, if none given it will pick a random path

@export_group("node refrences")
@export var nav_agent: NavigationAgent2D
@export var animation: AnimatedSprite2D
@export var sight_area: Node2D
@export var body: CollisionShape2D

@export_subgroup("state refrences")
@export var move_state: Node
@export var attack_state: Node2D
@export var hide_state: Node
@export var panic_state: Node
@export var knock_state: Node
@export var patrol_state: Node
@export var wep_search_state: Node
@export_group("floats")
@export_range(25.0, 50, 0.1) var attack_distance: float = 30
@export var detection_range: float = 100 ##the distance the enemy can look too
@export var detection_gap: float = 40.0 ##how wide the view
@export var pickup_raduis: float = 25.0 ##how close the weapon needs to be for the enemy to pick it up

@onready var player: PlayerScript = get_tree().get_nodes_in_group("player")[0]
@onready var cur_scene:= get_tree().get_current_scene()
@onready var club: PackedScene = preload("res://entites/weapons/wep_club.tscn")
@onready var blood: PackedScene = preload("res://misc/blood_particle.tscn")

var direction: Vector2 = Vector2.ZERO

var ass_firction: float = 5.0
var health: float = 10.0
var speed: float = 200


var IS_DEAD: bool = false
var ARMED: bool = true

signal enemy_died

const RUN_SPEED: float = 250#125.0
const WALK_SPEED: float = 150#70.0

enum STATES{
	IDLE,		#0
	CHASE,		#1
	PANIC,		#2
	ATTACK,		#3
	KNOCKBACK,	#4
	HIDING,		#5
	PATROL,		#6
	DEATH,		#7
	SEARCH_WEP,	#8
}

var previous_st: STATES = STATES.IDLE
var current_st: STATES = STATES.IDLE

#Weapon tracking
var current_target: Node2D = null
var weapon_memory: Array = []
#----------------------------------------------------------#
func _ready() -> void:
	await get_tree().create_timer(0.1).timeout
	set_state(inital_state)

func _physics_process(_delta: float) -> void:
	if Engine.is_editor_hint():
		sight_area.visible = visible_eyesight
	else:
		if !IS_DEAD:
			_state_machine()
		else:
			velocity = lerp(velocity, Vector2.ZERO, ass_firction * get_physics_process_delta_time())
			if velocity.length() < 10:
				body.disabled = true
		
		move_and_slide()

func set_state(new_st: STATES) -> void:
	if current_st != new_st:
		previous_st = current_st
		current_st = new_st

#the base state machine 
func _state_machine() -> void:
	match current_st:
		STATES.IDLE:
			animation.play("idle")
			velocity = Vector2.ZERO
			if health < 5:
				set_state(STATES.HIDING)
		
		STATES.CHASE:
			move_state.move_to(player.global_position)
			speed = RUN_SPEED
			
			#if the hostile is close enough to the player attack
			if !player.IS_DEAD:
				if global_position.distance_to(player.global_position) < attack_distance:
					set_state(STATES.ATTACK)
			else:
				#if someone killed the player don't bother chasing a dead man
				set_state(STATES.IDLE)
			
		STATES.PANIC:
			panic_state.panic()
		STATES.ATTACK:
			attack_state.attack()
		
		STATES.KNOCKBACK:
			knock_state.knockback(last_shot_dir)
			drop_weapon()
			
		STATES.HIDING:
			hide_state.hide()
		STATES.PATROL:
			speed = WALK_SPEED
			patrol_state.patrol() 
			
		STATES.DEATH:
			animation.play("death")
			if !IS_DEAD:
				velocity = last_shot_dir * 100
				IS_DEAD = true
				enemy_died.emit()
				cur_scene.stunts.append("kill")
				if global_position.distance_to(player.global_position) < 50:
					player.mana += 5
				
				drop_weapon()
			
		STATES.SEARCH_WEP:
			animation.play("unarmed")
			wep_search_state.look_for_weapon()

func get_current_state() -> String:
	return STATES.keys()[current_st]

func get_previous_state() -> String:
	return STATES.keys()[previous_st]

var last_shot_dir: Vector2 = Vector2.ZERO #get the last direction of what hit
func on_hit(dmg: float, hit_dir: Vector2, type: String = "") -> void:
	health -= dmg
	last_shot_dir = hit_dir
	
	var blood_ins: GPUParticles2D = blood.instantiate()
	blood_ins.global_position = global_position
	blood_ins.rotate_towards(hit_dir)
	
	cur_scene.add_child(blood_ins)
	
	if type == "burn":
		animation.modulate = Color(0.22, 0.22, 0.22)
	
	if health <= 0:
		set_state(STATES.DEATH)

func drop_weapon() -> void:
	#make the enemy unarmed
	if ARMED:
		var wep_ins: RigidBody2D = club.instantiate() 
		wep_ins.global_position = global_position
		
		cur_scene.stunts.append("Knockback")
		cur_scene.add_child(wep_ins)
		ARMED = false

func pickup_weapon() -> void:
	var prev_wep_index: int = weapon_memory.find(current_target)
	weapon_memory.remove_at(prev_wep_index)
	current_target.queue_free()
	ARMED = true
	set_state(STATES.CHASE)
