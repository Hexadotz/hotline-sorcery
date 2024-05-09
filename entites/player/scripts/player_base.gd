#NOTE: if you find any missspelling please ignore it i'm dumb
class_name PlayerScript extends CharacterBody2D

@export var anim: AnimatedSprite2D
@export var camera: Camera2D

#-----movement variables------#
var target_dir: Vector2 = Vector2.ZERO
var direction: Vector2 = Vector2.ZERO #the direction the player is going to
@export var acceleration: float = 10.0 #the player's friction on the floor (low values makes movment slippery)
var speed: float

#-------mouse variables-------#
var mouse_pos: Vector2 = Vector2.ZERO

#-------debugging stuff----------#
var test_point: PackedScene = preload("res://entites/player/test_mesh.tscn")
var instance: MeshInstance2D
#-------------------------------------------------------#
func _ready() -> void:
	instance = test_point.instantiate()
	add_child(instance)
	#TODO: pass the player reference to all the child nodes that needs him
	for node in get_children(true):
		if node.has_method("Player"):
			pass

func _physics_process(delta: float) -> void:
	#storing the mouse position in a variable so we don't call the method more than once
	mouse_pos = get_global_mouse_position()
	
	#makes the player look where the mouse is pointing at for aiming
	look_at(mouse_pos)
	
	#debuging mouse position
	instance.global_position = mouse_pos
	
	velocity = lerp(velocity, target_dir, acceleration * delta)
	#-----------------------------------------------------#
	_camera_process(delta)
	_handel_animation()
	move_and_slide()

func looking_at_direction() -> Vector2:
	return global_position.direction_to(mouse_pos)

func _handel_animation() -> void:
	if direction != Vector2.ZERO and !velocity.is_zero_approx():
		anim.play("run_anim")
	else:
		anim.stop()

@export var distance: Vector2 = Vector2.ZERO #this limits the distance the camera offsets from the player good for ranged attack
@export var pan_speed: float = 10.0 #this variables changes the speed the camera offsets
func _camera_process(delta: float) -> void:
	var pan_dis: float = pan_speed * 1.5 if Input.is_action_pressed("zoom") else pan_speed
	var thres: Vector2 = distance * 2 if Input.is_action_pressed("zoom") else distance
	var look_to_direction: Vector2 = (mouse_pos - global_position)
	
	#4th attempt (we so back)
	camera.offset = (look_to_direction * pan_dis) * delta
	
	#limit the pan raduis
	camera.offset = clamp(camera.offset, -thres, thres)
