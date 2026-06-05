shader_type spatial;

uniform sampler2D image : source_color, filter_nearest;

uniform vec3 accent_color: source_color;
uniform vec3 highlight_color: source_color;
uniform vec3 base_color: source_color;
uniform vec3 shadow_color: source_color;

uniform vec4 temp_accent_color: source_color;
uniform vec4 temp_highlight_color: source_color;
uniform vec4 temp_base_color: source_color;
uniform vec4 temp_shadow_color: source_color;

const float EPSILON = 0.1;

void fragment() {
	vec4 color = texture(image, UV);
	
	int is_accent_color = int(distance(color, temp_accent_color) < EPSILON);
	int is_highlight_color = int(distance(color, temp_highlight_color) < EPSILON);
	int is_base_color = int(distance(color, temp_base_color) < EPSILON);
	int is_shadow_color = int(distance(color, temp_shadow_color) < EPSILON);
	int is_not_replaced = int((is_accent_color+is_highlight_color+is_base_color+is_shadow_color) == 0);
	
	//ALBEDO = highlight_color * float(is_highlight_color);
	
	ALBEDO = (color.rgb * float(is_not_replaced)) + (accent_color * float(is_accent_color)) + (highlight_color * float(is_highlight_color)) + (base_color * float(is_base_color)) + (shadow_color * float(is_shadow_color));
}

//const int pixel_size = 32;
//
//void light() {
	//ivec2 texture_size = textureSize(image, 0);
	//
	//int width = texture_size.x / pixel_size;
	//int height = texture_size.y / pixel_size;
	//
	//
//}