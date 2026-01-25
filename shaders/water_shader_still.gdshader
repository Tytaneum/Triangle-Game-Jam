shader_type canvas_item;
render_mode blend_mix;

uniform sampler2D screen_texture: hint_screen_texture;

	// Called for every vertex the material is visible on.
void vertex() {
	
}

	// Called for every pixel the material is visible on.
void fragment() {
	
	COLOR = texture(TEXTURE, UV);
	COLOR *= texture(screen_texture, SCREEN_UV);
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
