# DialogueTrigger.gd
extends Area2D

@export var message: String
@export var dialogue_box_path: NodePath

func _on_body_entered(body):
	print("entered")
	if body.name == "Princess":  # or use group
		var box = get_node(dialogue_box_path)
		box.show_text(message)
