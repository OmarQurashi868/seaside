shader_type spatial;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear;
uniform float target_alpha = 0.0;

void vertex() {
	//VERTEX.x += sin(TIME);
}

void fragment() {
	vec3 color;
	ALBEDO = vec3(0.12, 0.62, 0.78);
	ALPHA = target_alpha;
}

void light() {
	// Called for every pixel for every light affecting the material.
}
