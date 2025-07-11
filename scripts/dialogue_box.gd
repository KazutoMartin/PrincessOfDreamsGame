extends CanvasLayer

@onready var label: Label = $NinePatchRect/Label

# Optional typing effect
var full_text := ""
var char_index := 0
var typing_speed := 0.02
var typing_timer := 0.0
var is_typing := false

func show_text(text: String):
	full_text = text
	char_index = 0
	typing_timer = 0
	label.text = ""
	is_typing = true
	visible = true

func _process(delta: float):
	if is_typing:
		typing_timer += delta
		if typing_timer >= typing_speed:
			typing_timer = 0
			if char_index < full_text.length():
				label.text += full_text[char_index]
				char_index += 1
			else:
				is_typing = false

func hide_box():
	visible = false
