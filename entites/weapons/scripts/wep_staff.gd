class_name Staff extends Node2D

@export_group("Node refrences")
@export var animation: AnimatedSprite2D 
@export var spawn_point: Node2D 
@export var cast_cooldown: Timer 
@export var middle_point: Marker2D
@export var audio: AudioStreamPlayer
@export var hurtbox: Area2D
@export var sound_box: Area2D

@export_group("")
@export var projectile: PackedScene
@export var bullet_speed: float = 200.0

@export_group("weapons")
@export var weapon_type: WEAPON_TYPE
@export_subgroup("normal")
@export var normal_cooldown: float = 0.2
@export var normal_cost: float = 1.0
@export var normal_dmg: float = 5.0
@onready var normal_sfx: AudioStreamMP3 = preload("res://sound/magic_missile.mp3")
@export_subgroup("auto")
@export var auto_cooldown: float = 0.1
@export var auto_cost: float = 3
@export var auto_dmg: float = 2.5
@export_subgroup("shotgun")
@export var shotgun_cooldown: float = 0.1
@export var shotgun_spread: float = 5
@export var shotgun_pellets: int = 3
@export var shotgun_dmg: float = 3
@onready var shotgun_sfx: AudioStreamMP3 = preload("res://sound/magic_hit.mp3")

@onready var staff_sprites: SpriteFrames = preload("res://entites/weapons/staff/staff_sprites.tres")
@onready var wand_sprites: SpriteFrames = preload("res://entites/weapons/staff/wand_sprites.tres")
@onready var swing_sfx: AudioStreamRandomizer = preload("res://sound/audio_streams/swing_set.tres")
@onready var player: PlayerScript = get_tree().get_nodes_in_group("player")[0]
@onready var shotgun_array: Array = []

signal shot_fired

var can_cast: bool = true
var active: bool = true

enum WEAPON_TYPE{
	SEMI_AUTOMATIC,
	AUTOMATIC,
	SHOTGUN,
	LAZER,
	GRENADER
}

#----------------------------------------------#
func _ready() -> void:
	GlobalVariables.player_staff = self
	#player = GlobalVariables.player
	self.connect("shot_fired", _alert_enemies)
	var random_gen: RandomNumberGenerator = RandomNumberGenerator.new()
	for pellets: int in range(shotgun_pellets):
		var marker: Marker2D = Marker2D.new()
		var rand_value: float = random_gen.randf_range(-shotgun_spread, shotgun_spread)
		marker.position = Vector2(5, rand_value)
		
		spawn_point.add_child(marker)
	
	shotgun_array = spawn_point.get_children()

func _physics_process(_delta: float) -> void:
	$CanvasLayer/Label.text = "Mana: " + str(player.mana)
	if player.mana > 0:
		if active and can_cast:
			match weapon_type:
				WEAPON_TYPE.SEMI_AUTOMATIC:
					if Input.is_action_just_pressed("fire"):
						cast_cooldown.wait_time = normal_cooldown
						_fire_normal(normal_dmg, normal_cost)
					else:
						animation.stop()
				WEAPON_TYPE.AUTOMATIC:
					if Input.is_action_pressed("fire"):
						cast_cooldown.wait_time = auto_cooldown
						_fire_normal(auto_dmg, auto_cost)
					else:
						animation.stop()
				WEAPON_TYPE.SHOTGUN:
					if Input.is_action_just_pressed("fire"):
						_fire_shotgun()
						
				WEAPON_TYPE.LAZER:
					if Input.is_action_pressed("fire"):
						_fire_lazer()
				
				WEAPON_TYPE.GRENADER:
					if Input.is_action_just_pressed("fire"):
						_fire_nade()
		
	else:
		animation.stop()
		if Input.is_action_just_pressed("fire"):
			swing()

func _fire_normal(dmg: float, cost: float) -> void:
	emit_signal("shot_fired")
	animation.set_sprite_frames(wand_sprites)
	animation.play("firing")
	
	audio.stream = normal_sfx
	audio.play()
	
	var projectile_inst: RigidBody2D = projectile.instantiate() #instancate the projectile set its start position set it's direction times speed then spawn it
	projectile_inst.prepare_proj(player, spawn_point.global_position, get_global_mouse_position(), bullet_speed)
	projectile_inst.proj_type = projectile_inst.TYPE.MISSLE
	projectile_inst.damage = dmg
	spawn_point.add_child(projectile_inst)
	
	cast_cooldown.start() #after we shoot give a small cooldown (this is the firerate)
	player.mana -= cost
	can_cast = false

func _fire_shotgun() -> void:
	animation.set_sprite_frames(staff_sprites)
	animation.play("firing")
	
	audio.stream = shotgun_sfx
	audio.play()
	
	cast_cooldown.wait_time = shotgun_cooldown
	for point in shotgun_array:
		var projectile_inst: RigidBody2D = projectile.instantiate()
		projectile_inst.prepare_proj(player, spawn_point.global_position, point.global_position, bullet_speed)
		projectile_inst.damage = shotgun_dmg
		projectile_inst.proj_type = projectile_inst.TYPE.FIREBALL
		spawn_point.add_child(projectile_inst)
		
		cast_cooldown.start()
		can_cast = false
	
	player.mana -= shotgun_pellets

var lazer_param = PhysicsRayQueryParameters2D.new()
func _fire_lazer() -> void:
	lazer_param.from = spawn_point.global_position
	lazer_param.to = get_global_mouse_position()
	
	var resault: Dictionary = get_world_2d().direct_space_state.intersect_ray(lazer_param)
	
	if resault.has("collider"):
		var coll = resault["collider"]
		if coll.is_in_group("enemy"):
			coll.on_hit(1, spawn_point.global_position.direction_to(get_global_mouse_position()))

func _fire_nade() -> void:
	var projectile_inst: RigidBody2D = projectile.instantiate() #instancate the projectile set its start position set it's direction times speed then spawn it
	projectile_inst.prepare_proj(player, spawn_point.global_position, get_global_mouse_position(), bullet_speed)
	projectile_inst.proj_type = projectile_inst.TYPE.BOMB
	spawn_point.add_child(projectile_inst)

#--------------------------------------------------------------------#
func swing() -> void:
	audio.stream = swing_sfx
	if not audio.is_playing():
		audio.play()
	
	var enemy_list: Array  = hurtbox.get_overlapping_bodies()
	for node in enemy_list:
		if node.is_in_group("enemy"):
			node.set_state(node.STATES.KNOCKBACK)

func _alert_enemies() -> void:
	if !sound_box.has_overlapping_bodies():
		return
	else:
		var enemies: Array = sound_box.get_overlapping_bodies()
		for hostile in enemies:
			hostile.set_state(hostile.STATES.CHASE)

#allow shooting again after the shoot colldown
func _on_fire_rater_timeout() -> void:
	can_cast = true
