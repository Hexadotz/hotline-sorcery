extends Camera2D

@export var player: PlayerScript

@export var distance: Vector2 = Vector2.ZERO #this limits the distance the camera offsets from the player good for ranged attack
@export var pan_speed: float = 10.0 #this variables changes the speed the camera offsets
#-----------------------------------------------------------#
func _ready() -> void:
	pass 
