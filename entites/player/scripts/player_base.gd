#NOTE: if you find any missspelling please ignore it i'm dumb
class_name PlayerScript extends CharacterBody2D

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

func _physics_process(delta: float) -> void:
	#storing the mouse position in a variable so we don't call the method more than once
	mouse_pos = get_global_mouse_position()
	
	#makes the player look where the mouse is pointing at for aiming
	look_at(mouse_pos)
	
	instance.global_position = mouse_pos
	
	if Input.is_action_just_pressed("restart"):
		get_tree().reload_current_scene()
	
	velocity = lerp(velocity, target_dir, acceleration * delta)
	move_and_slide()

