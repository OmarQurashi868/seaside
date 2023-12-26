shader_type spatial;
uniform vec3 target_color = vec3(1, 0, 0);
uniform float target_alpha = 0.8;
uniform bool is_building = false;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	// Called for every pixel the material is visible on.
	ALBEDO = COLOR.rgb;
	ALPHA = 1.0;
	if (is_building) {
		ALBEDO = target_color;
		ALPHA = target_alpha;
	}
}

void light() {
	// Called for every pixel for every light affecting the material.
}
