extends CanvasLayer

@export var score_lbl: Label
@export var kills_lbl: Label
@export var knock_lbl: Label
@export var seen_lbl: Label
@export var barrel_lbl: Label
@export var combo_lbl: Label

@onready var level: Node2D = get_parent()
@onready var Rank: Label = $Panel/centerer/Panel/rate
@onready var anim: AnimationPlayer = $AnimationPlayer
#------------------------------------------------------#
func _ready() -> void:
	pass

func start() -> void:
	var score: int = level.player.UI.score
	score_lbl.text = str(score)
	kills_lbl.text = str(level.kills)
	
	knock_lbl.text = str(level.knockbacks) + " times"
	seen_lbl.text = str(level.expos) + " times"
	
	barrel_lbl.text = str(level.booms) + " times"
	combo_lbl.text = str(level.highest_combo)
	
	#32 enemies * 1000 = 32000 (MIN)
	var rating: String = "?"
	if score < 32000:
		rating = "D"
	
	
	Rank.text = rating
	
	anim.play("resaults_anim")
