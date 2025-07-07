shader_type canvas_item;

// ADD THIS LINE for Godot 4.0.x compatibility:
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

uniform vec4 effect_color = vec4(1.0, 1.0, 1.0, 1.0); // Color of the flash/shadow (white for flash, black for shadow)
uniform float effect_amount : hint_range(0.0, 1.0) = 0.0;     // Overall strength/intensity of the effect (0 = no effect, 1 = full effect)
uniform float vignette_power : hint_range(0.1, 10.0) = 2.0;    // Controls how sharp the vignette effect is (higher = sharper transition)
uniform float vignette_radius : hint_range(0.0, 1.0) = 0.75;   // How far from the center the effect starts to become noticeable

void fragment() {
	// SCREEN_UV provides the UV coordinates of the current pixel on the screen (0,0 top-left, 1,1 bottom-right).
	vec2 uv = SCREEN_UV;
	// Define the center of the screen.
	vec2 center = vec2(0.5, 0.5);
	
	// Calculate the distance of the current pixel from the center of the screen.
	// Multiply by 2.0 to normalize the distance so that the furthest corner has a value around 1.0 (sqrt(0.5^2+0.5^2)*2 = 1.414, but smoothstep handles the range).
	float dist_from_center = length(uv - center) * 2.0;
	
	// Create a vignette effect:
	// smoothstep(edge0, edge1, x) returns 0.0 if x is less than edge0, 1.0 if x is greater than edge1,
	// and smoothly interpolates between 0.0 and 1.0 otherwise.
	// This makes the effect start at vignette_radius and reach full intensity at the edges/corners.
	float vignette_factor = smoothstep(vignette_radius, 1.0, dist_from_center);
	
	// Apply power to the vignette factor to control its falloff (sharpness).
	vignette_factor = pow(vignette_factor, vignette_power);
	
	// Mix the original screen texture color with our effect_color.
	// The amount of mixing is controlled by 'vignette_factor' and 'effect_amount'.
	// If 'effect_color' is white, it brightens. If black, it darkens.
	// The 'effect_amount' uniform, controlled by GDScript, acts as an overall intensity multiplier.
	vec4 final_color = mix(texture(SCREEN_TEXTURE, SCREEN_UV), effect_color, vignette_factor * effect_amount);
	
	// Set the final color of the pixel.
	COLOR = final_color;
}