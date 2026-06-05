shader_type canvas_item;

uniform float open: hint_range(0, 1);

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec2 uv = abs((UV * 2.0f)-vec2(1.0, 1.0));
	if (uv.x < open) {
		COLOR = vec4(0.0, 0.0, 0.0, 0.0);
	} else {
		COLOR = vec4(0.0, 0.0, 0.0, 1.0);
	}
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
