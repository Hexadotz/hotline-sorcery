#NOTE: if you find any missspelling please ignore it i'm dumb
class_name PlayerScript extends CharacterBody2D

@export var body_anim: AnimatedSprite2D
@export var legs_anim: AnimatedSprite2D
@export var camera: Camera2D

@export var max_ang: float = 45
@export var tilt_strength: float = 10
@export var distance: Vector2 = Vector2.ZERO #this limits the distance the camera offsets from the player good for ranged attack
@export var pan_speed: float = 10.0 #this variables changes the speed the camera offsets
#-----movement variables------#
var target_dir: Vector2 = Vector2.ZERO
var direction: Vector2 = Vector2.ZERO #the direction the player is going to
var acceleration: float = 10.0 #the player's friction on the floor (low values makes movment slippery)
var speed: float

#-------mouse variables-------#
var mouse_pos: Vector2 = Vector2.ZERO

#-------misc stuff------------#
@onready var blood: PackedScene = preload("res://misc/blood_particle.tscn")
@onready var cur_scene: Node = get_tree().current_scene
var IS_DEAD: bool = false
#-------debugging stuff----------#
var test_point: PackedScene = preload("res://entites/player/test_mesh.tscn")
var instance: MeshInstance2D
#-------------------------------------------------------#
func _ready() -> void:
	GlobalVariables.player = self
	instance = test_point.instantiate()
	add_child(instance)
	#TODO: pass the player reference to all the child nodes that needs him
	for node: Node in get_children(true):
		if node.get("player") != null:
			pass

func _physics_process(delta: float) -> void:
	if !IS_DEAD:
		#storing the mouse position in a variable so we don't call the method more thazn once
		mouse_pos = get_global_mouse_position()
		
		#makes the player look where the mouse is pointing at for aiming
		look_at(mouse_pos)
		
		#debuging mouse position NOTE: need to be removed once we have a mouse sprite
		instance.global_position = mouse_pos
		
		velocity = lerp(velocity, target_dir, acceleration * delta)
		#-----------------------------------------------------#
		_camera_process(delta)
		_animation_process(delta)
	else:
		velocity = velocity.lerp(Vector2.ZERO, 5 * get_physics_process_delta_time())
	
	move_and_slide()

func looking_at() -> Vector2:
	return global_position.direction_to(mouse_pos)

func _animation_process(_delta: float) -> void:
	if direction != Vector2.ZERO and !velocity.is_zero_approx():
		body_anim.play("run_anim")
		legs_anim.play("legs1")
	else:
		body_anim.stop()
		legs_anim.stop()
		legs_anim.rotation_degrees = 0
	
	#NOTE: this is fpr rotating the legs depending on the firection the player is walkin to
	#var legs_direction: float = position.angle_to(to_global(direction))
	#legs_anim.global_rotation = lerp(legs_anim.global_rotation, legs_direction, 100 * delta)

func _camera_process(delta: float) -> void:
	var pan_dis: float = pan_speed * 1.5 if Input.is_action_pressed("zoom") else pan_speed
	var thres: Vector2 = distance * 2 if Input.is_action_pressed("zoom") else distance
	var look_to_direction: Vector2 = (mouse_pos - global_position)
	
	#4th attempt (we so back)
	camera.offset = (look_to_direction * pan_dis) * delta
	
	#limit the pan raduis
	camera.offset = clamp(camera.offset, -thres, thres)
	
	
	#TODO: figure out how to overwrite godot's shitty camera rotation inheritance 
	camera.rotation_degrees = clamp(camera.rotation_degrees, -max_ang, max_ang)
	camera.rotation_degrees = lerp(camera.rotation_degrees, direction.x, tilt_strength * delta)


func death(direc: Vector2) -> void:
	legs_anim.visible = false
	body_anim.play("death")
	if !IS_DEAD:
		velocity = direc * 200
		rotation = global_position.angle_to(direction.normalized())
		IS_DEAD = true
	
	var blood_ins: GPUParticles2D = blood.instantiate()
	blood_ins.global_position = global_position
	blood_ins.amount = 64
	
	#convert player direction from Vector2 to Vector3 because the godot developers are fucking morons
	var dirc: Vector2 = direc.direction_to(global_position)
	var blood_dir: Vector3 = Vector3.FORWARD.rotated(Vector3.UP, Vector2(dirc.x, -dirc.y).angle())
	blood_ins.process_material.direction = -blood_dir
	
	cur_scene.add_child(blood_ins)
