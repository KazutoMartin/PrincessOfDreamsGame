extends CharacterBody2D


const SPEED = 400.0
const JUMP_VELOCITY = -400.0
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var head: RayCast2D = $head
@onready var feet: RayCast2D = $feet
@onready var climb: CollisionShape2D = $climb
@onready var snow: GPUParticles2D = $"../../snow"
@onready var canvas_modulate: CanvasModulate = $"../../CanvasModulate"
@onready var timer: Timer = $"../../start/Timer"

var once_changed = false
var game_started = false
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Start") and not game_started:
		game_started = true
		timer.start()
		
	if !game_started:
		return
	if event.is_action_pressed("take_photo"): # Or your custom input action like "take_photo"
		print("runniong")
		print("runniong2")
	if event.is_action_pressed("snowing"): # Or your custom input action like "take_photo"
		print("setting to true")
		snow.visible = true
		change_color()
func change_color():
 	# Change the CanvasModulate color to a green tint
 	#canvas_modulate.color = Color(0.0, 1.0, 0.0, 1.0)
	
 	# Or, to fade out:
	var tween = create_tween()
	
	tween.tween_property(canvas_modulate, "color", Color(0.803, 0.669, 0.92, 1), 3) # Fade to white over 3 seconds

func _physics_process(delta: float) -> void:
	if !game_started:
		animated_sprite_2d.play("starting")
		return
		
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	if not timer.is_stopped():
		animated_sprite_2d.play("starting")
		move_and_slide()
		return
		
	
	

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
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


func _on_wish_trigger_body_entered(body: Node2D) -> void:
	pass # Replace with function body.




func _on_river_triger_body_exited(body: Node2D) -> void:
	var tween = create_tween()
	once_changed = true
	tween.tween_property(canvas_modulate, "color", Color(1,1,1,1), 3) # Fade to white over 3 seconds
