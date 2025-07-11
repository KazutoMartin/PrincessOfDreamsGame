extends RigidBody2D


#const SPEED = 300.0
#const JUMP_VELOCITY = -400.0
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	animated_sprite_2d.play("falling")
	
	
#func _physics_process(delta: float) -> void:
	#velocity += get_gravity() * delta * 0.2
#
	#move_and_slide()
