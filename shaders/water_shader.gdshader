shader_type canvas_item;
render_mode blend_mix;

uniform sampler2D screen_texture: hint_screen_texture;
uniform sampler2D noise_texture: filter_nearest, repeat_enable;
uniform float distortion = 0.01;
uniform vec2 speed = vec2(0.1, 0.05);

	// Called for every vertex the material is visible on.
void vertex() {
	
}

	// Called for every pixel the material is visible on.
void fragment() {
	vec2 uv = UV + speed * TIME;
	vec2 noise = 2.0 * texture(noise_texture, uv).rg - vec2(1.0);
	
	COLOR = texture(TEXTURE, UV);
	COLOR *= texture(screen_texture, SCREEN_UV + noise * distortion);
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
