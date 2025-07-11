extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
const SPEED = 300.0
var moving = false

func _physics_process(delta: float) -> void:
	if moving:
		animated_sprite_2d.flip_h = true
		velocity.x = -1 * SPEED
		move_and_slide()
	


	
	


func _on_bus_trigger_body_entered(body: Node2D) -> void:
	print("bus trigger body entered")
	if body.name=="Princess":
		moving = true
