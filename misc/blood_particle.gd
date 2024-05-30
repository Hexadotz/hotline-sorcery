extends GPUParticles2D

@onready var blood_texture = preload("res://art/blood.png")

const SPRITE_SIZE: Vector2 = Vector2(8,8)
#---------------------------------------------------------------#
func _ready() -> void:
	one_shot = true
	#do not question what the fuck im doing, because i don't know myself
	var atlas_tex: AtlasTexture = AtlasTexture.new()
	atlas_tex.atlas = blood_texture
	
	var rng: RandomNumberGenerator = RandomNumberGenerator.new()
	var line: int = rng.randi_range(0, 1) * 8
	var column: int = rng.randi_range(0,4) * 8
	
	var reg: Rect2 = Rect2(Vector2(column, line), SPRITE_SIZE)
	atlas_tex.region = reg
	
	#finally put the texture
	texture = atlas_tex

func rotate_towards(target: Vector2) -> void:
	var angle: float = global_position.angle_to(target)
	rotation = angle - 90

func _on_finish_timer_timeout() -> void:
	speed_scale = 0
