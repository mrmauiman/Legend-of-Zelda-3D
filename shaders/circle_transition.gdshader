shader_type canvas_item;

uniform float circle_radius : hint_range(0.0f, 1.0f) = 1.0f;
uniform vec2 circle_offset = vec2(0.0f, 0.2f);

uniform vec2 screen_size = vec2(1920.0f, 1080.0f);

void fragment() {
	vec2 pos = vec2(UV.x * screen_size.x, UV.y * screen_size.y);
	vec2 circle_center = vec2(screen_size.x * (0.5f + circle_offset.x), screen_size.y * (0.5f + circle_offset.y));
	if (distance(circle_center, pos) < (circle_radius * screen_size.x)) {
		COLOR.a = 0.0f;
	}
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
