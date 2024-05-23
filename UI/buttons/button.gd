extends Button

@onready var sfx: AudioStreamPlayer = $AudioStreamPlayer
func _on_pressed() -> void:
	sfx.play()
