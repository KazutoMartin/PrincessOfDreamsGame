extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

var moving = false
func _ready() -> void:
	animated_sprite_2d.play("default")
	




func _physics_process(delta: float) -> void:
	if moving:
		velocity.y = -250
		move_and_slide()


func _on_rocket_trigger_body_entered(body: Node2D) -> void:
	if body.name == "Princess":
		moving = true
