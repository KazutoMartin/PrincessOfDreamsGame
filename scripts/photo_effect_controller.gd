# photo_effect_controller.gd
extends ColorRect

# Export variables allow you to easily tweak these values in the Inspector.
@export var flash_duration: float = 0.15  # Duration of the flash phase (in seconds)
@export var shadow_duration: float = 0.25 # Duration of the shadow phase (in seconds)
@export var shadow_delay: float = 0.05    # Delay between the flash fading out and the shadow fading in (in seconds)
@export var flash_color: Color = Color(1.0, 1.0, 1.0, 1.0) # White color for the flash
@export var shadow_color: Color = Color(0.0, 0.0, 0.0, 0.7) # Dark, semi-transparent color for the shadow

var _tween: Tween = null # Reference to the Tween node for animation
var _shader_material: ShaderMaterial = null # Reference to the ShaderMaterial instance

func _ready() -> void:
	# Get the ShaderMaterial instance from this ColorRect's material.
	_shader_material = material as ShaderMaterial
	if _shader_material == null:
		printerr("PhotoEffectLayer requires a ShaderMaterial to function.")
		queue_free() # If no shader material is found, remove this node to prevent errors.
		return
	
	# Ensure the effect is completely off initially.
	_shader_material.set_shader_parameter("effect_amount", 0.0)
	# Hide the ColorRect until the effect is explicitly triggered.
	visible = false

# This function triggers the entire photo effect sequence.
func trigger_photo_effect() -> void:
	# If a tween is already running, stop it to prevent overlapping effects.
	if _tween != null and _tween.is_running():
		_tween.kill()
	
	# Make the ColorRect visible so the effect can be seen.
	visible = true
	
	# Create a new Tween for animating the shader parameters.
	_tween = create_tween()
	# Set the tween to run animations sequentially (one after another).
	_tween.set_parallel(false)
	
	# --- Flash Phase ---
	# Set the shader's effect_color to the flash color.
	_shader_material.set_shader_parameter("effect_color", flash_color)
	
	# Tween 1: Fade in the flash effect (effect_amount from 0.0 to 1.0).
	_tween.tween_property(_shader_material, "shader_parameter/effect_amount", 1.0, flash_duration / 2.0) \
		.set_ease(Tween.EASE_OUT) \
		.set_trans(Tween.TRANS_QUAD) # Quadratic easing for a smooth start.
	
	# Tween 2: Fade out the flash effect (effect_amount from 1.0 to 0.0).
	_tween.tween_property(_shader_material, "shader_parameter/effect_amount", 0.0, flash_duration / 2.0) \
		.set_ease(Tween.EASE_IN) \
		.set_trans(Tween.TRANS_QUAD) # Quadratic easing for a smooth end.
	
	# --- Shadow Phase ---
	# Tween 3: Add a small delay before the shadow effect begins.
	_tween.tween_interval(shadow_delay)
	
	# Set the shader's effect_color to the shadow color.
	_shader_material.set_shader_parameter("effect_color", shadow_color)
	
	# Tween 4: Fade in the shadow effect (effect_amount from 0.0 to 1.0).
	_tween.tween_property(_shader_material, "shader_parameter/effect_amount", 1.0, shadow_duration / 2.0) \
		.set_ease(Tween.EASE_OUT) \
		.set_trans(Tween.TRANS_QUAD)
	
	# Tween 5: Fade out the shadow effect (effect_amount from 1.0 to 0.0).
	_tween.tween_property(_shader_material, "shader_parameter/effect_amount", 0.0, shadow_duration / 2.0) \
		.set_ease(Tween.EASE_IN) \
		.set_trans(Tween.TRANS_QUAD)
	print("gotHere")
	# Tween 6: After all animations are complete, hide the ColorRect and clear the tween reference.
	_tween.tween_callback(func():
		visible = false
		_tween = null
	)
