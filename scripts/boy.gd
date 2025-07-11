extends CharacterBody2D


const SPEED = 450.0
const JUMP_VELOCITY = -600.0
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var head: RayCast2D = $head
@onready var feet: RayCast2D = $feet
@onready var climb: CollisionShape2D = $climb
@onready var canvas_modulate: CanvasModulate = $"../../CanvasModulate"

		


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("boy jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("boy left", "boy right")
	if direction == 0 or not climb.disabled:
		animated_sprite_2d.play("idle")
	if direction > 0:
		animated_sprite_2d.flip_h = false
		head.scale.x = sign(velocity.x);
		feet.scale.x = sign(velocity.x);	
		animated_sprite_2d.play("running")
	if direction < 0:
		animated_sprite_2d.flip_h = true
		head.scale.x = sign(velocity.x);
		feet.scale.x = sign(velocity.x);
		animated_sprite_2d.play("running")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	
	if direction and velocity.y >= 0.0:
		var next_to_stair =  not head.is_colliding() and feet.is_colliding()
		climb.disabled = not next_to_stair
		if not climb.disabled:
			velocity.x = direction * SPEED * 0.4
			
		
	move_and_slide()
