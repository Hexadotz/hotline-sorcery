@tool
extends StaticBody2D

@export var object_type: TABLES

@onready var sprite: Sprite2D = $Sprite2D
@onready var collision: CollisionShape2D = $CollisionShape2D

enum TABLES{
	TABLE_RECTANGLE,
	TABLE_RECTANGLE_SIDE,
	TABLE_ROUND_UP,
	TABLE_ROUND_SIDE,
	CHAIR_RECT,
	CHAIR_RECT_SIDE,
	CHAIR_ROUND,
	CHAIR_ROUND_SIDE,
}
var tabel_rect_shape = RectangleShape2D.new()
var table_round_shape = CircleShape2D.new()
var chair_rect_shape = RectangleShape2D.new()
var chair_round_shape = CircleShape2D.new()
#-----------------------------------------------------------#
func _ready() -> void:
	tabel_rect_shape.size = Vector2(48,24)
	tabel_rect_shape.set_local_to_scene(true)
	
	chair_rect_shape.size = Vector2(20, 20)
	chair_rect_shape.set_local_to_scene(true)
	
	table_round_shape.radius = 17
	table_round_shape.set_local_to_scene(true)
	
	chair_round_shape.radius = 9
	chair_rect_shape.set_local_to_scene(true)
	
	_set_table()

func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		_set_table()

func _set_table() -> void:
	match object_type:
		TABLES.TABLE_RECTANGLE:
			sprite.texture.region = Rect2(Vector2(1, 5), Vector2(49, 25))
			collision.shape = tabel_rect_shape
		
		TABLES.TABLE_RECTANGLE_SIDE:
			sprite.texture.region = Rect2(Vector2(4, 36), Vector2(48, 24))
			collision.shape = tabel_rect_shape
		
		TABLES.TABLE_ROUND_UP:
			sprite.texture.region = Rect2(Vector2(132, 0), Vector2(44, 35))
			collision.shape = table_round_shape
		
		TABLES.TABLE_ROUND_SIDE:
			sprite.texture.region = Rect2(Vector2(132, 35), Vector2(44, 32))
			collision.shape = table_round_shape
		
		TABLES.CHAIR_RECT:
			sprite.texture.region = Rect2(Vector2(68, 8), Vector2(20, 20))
			collision.shape = chair_rect_shape
		
		TABLES.CHAIR_RECT_SIDE:
			sprite.texture.region = Rect2(Vector2(60, 40), Vector2(36, 24))
			collision.shape = chair_rect_shape
		
		TABLES.CHAIR_ROUND:
			sprite.texture.region = Rect2(Vector2(100, 8), Vector2(20, 20))
			collision.shape = chair_round_shape
		
		TABLES.CHAIR_ROUND_SIDE:
			sprite.texture.region = Rect2(Vector2(100, 44), Vector2(20, 16))
			collision.shape = chair_round_shape
