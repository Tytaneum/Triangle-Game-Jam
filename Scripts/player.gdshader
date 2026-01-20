shader_type canvas_item;

uniform vec4 BODY : source_color;
uniform vec4 ACCENT : source_color;
uniform vec4 DRILL : source_color;
uniform vec4 DRILL_2 : source_color;


uniform vec4 ALT_BODY : source_color;
uniform vec4 ALT_ACCENT : source_color;
uniform vec4 ALT_DRILL : source_color;
uniform vec4 ALT_DRILL_2 : source_color;

void fragment() {
	vec4 current_color = texture(TEXTURE, UV);
	if (distance(current_color, BODY)< 0.1){
		COLOR = ALT_BODY;
	}
	else if(distance(current_color, ACCENT)< 0.1){
		COLOR = ALT_ACCENT;
	}
	else if(distance(current_color, DRILL)< 0.1){
		COLOR = ALT_DRILL;
	}
	
	else if(distance(current_color, DRILL_2)< 0.1){
		COLOR = ALT_DRILL_2;
	}
	
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
