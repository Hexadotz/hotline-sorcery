extends Camera2D

@export var player: PlayerScript

@export var distance: Vector2 = Vector2.ZERO #this limits the distance the camera offsets from the player good for ranged attack
@export var pan_speed: float = 10.0 #this variables changes the speed the camera offsets

var mouse_Lpos: Vector2 = Vector2.ZERO

#-----------------------------------------------------------#
func _ready() -> void:
	pass 

func _physics_process(delta: float) -> void:
	#1st attempt (nuh uh)
	#NOTE: the camera offset moves further when the mouse is at the bottom right of the screen
	#print(get_viewport().get_mouse_position())
	#offset = (get_viewport().get_mouse_position() * pan_speed)
	
	#2st attempt (shitty)
	#NOTE: normalizing the verctor to keep the drag values consistant
	#print(get_viewport().get_mouse_position().normalized())
	#offset = (get_viewport().get_mouse_position().normalized() * pan_speed)
	
	#3nd attempt (it's joever)
	#print(player.mouse_pos.normalized())
	#offset = (player.mouse_pos.normalized() * pan_speed)
	
	#4th attempt (we so back)
	print((player.mouse_pos - player.global_position))
	offset = ((player.mouse_pos - player.global_position) * pan_speed) * delta
	
	#limit the pan raduis
	offset = clamp(offset, -distance, distance)
