shader_type spatial;

uniform vec2 SIZE = vec2(32, 32);

uniform float radius = 8;
uniform float transparency: hint_range(0.0, 1.0, 0.1) = 0.0;

void fragment() {
	vec2 uv = vec2(floor(UV.x * SIZE.x) + 0.5, floor(UV.y * SIZE.y) + 0.5);
	uv -= (SIZE/2.0);
	ALBEDO = vec3(0.0, 0.0, 0.0);
	ALPHA = float(int(length(uv) <= radius)) * transparency;
}
