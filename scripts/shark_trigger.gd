extends Area2D

@export var faller_path: NodePath
var faller_node: RigidBody2D

func _ready():
	faller_node = get_node(faller_path) as RigidBody2D

func _on_Area2D_body_entered(body: Node) -> void:
	# When *anything* enters, check if it was the Player
	print("entered")
	print(body.name)
	if body.name == "Princess":  # or use body.is_in_group("player") if you tagged it 
		faller_node.gravity_scale = 1


func _on_body_entered(body: Node2D) -> void:
	# When *anything* enters, check if it was the Player
	print("entered")
	print(body.name)
	if body.name == "Princess":  # or use body.is_in_group("player") if you tagged it 
		faller_node.gravity_scale = 0.5
