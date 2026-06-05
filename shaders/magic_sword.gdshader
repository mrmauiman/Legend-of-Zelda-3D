shader_type spatial;
render_mode cull_disabled;

uniform sampler2D sword_texture : source_color;
uniform float emission_energy = 1;

void fragment() {
	vec4 texture_color = texture(sword_texture, UV);
	vec4 white = vec4(1.0f, 1.0f, 1.0f, 1.0f);
	ALBEDO = texture_color.rgb;
	ALPHA = texture_color.a;
	EMISSION = vec3(float(texture_color == white) * emission_energy);
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
