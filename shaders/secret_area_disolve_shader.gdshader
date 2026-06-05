shader_type spatial;

render_mode depth_draw_opaque, cull_back;

uniform sampler2D sprite: source_color, filter_nearest;

uniform bool disolve;

uniform float speed = 0.1; 
uniform float pixelation = 8.0;
uniform float zoom = 2.0;
uniform float gradient_pixelation : hint_range(0.001, 1.0) = 0.1;
uniform float background_threshold : hint_range(0.0, 1.0) = 0.0;

#define iTime (TIME * speed)
#define iResolution 1.0/SCREEN_PIXEL_SIZE

const mat2 mtx = mat2( vec2(0.80, -0.60), vec2(0.60, 0.80) );

float rand(vec2 n) { 
    return fract(sin(dot(n, vec2(12.9898, 4.1414))) * 43758.5453);
}

float noise(vec2 p){
    vec2 ip = floor(p);
    vec2 u = fract(p);
    u = u * u * (3.0 - 2.0 * u);

    float res = mix(
        mix(rand(ip), rand(ip + vec2(1.0, 0.0)), u.x),
        mix(rand(ip + vec2(0.0, 1.0)), rand(ip + vec2(1.0, 1.0)), u.x), u.y);
        
    return res * res;
}

float fbm( vec2 p )
{
    float f = 0.0;
    
    f += 0.500000 * noise( p + iTime ); p = mtx * p * 2.02;
    f += 0.031250 * noise( p ); p = mtx * p * 2.01;
    f += 0.250000 * noise( p ); p = mtx * p * 2.03;
    f += 0.125000 * noise( p ); p = mtx * p * 2.01;
    f += 0.062500 * noise( p ); p = mtx * p * 2.04;
    f += 0.015625 * noise( p + sin(iTime) );

    return f / 0.96875;
}

float pattern( in vec2 p )
{
	return fbm( p + fbm( p + fbm( p ) ) );
}

void fragment() {
	vec2 uv = floor(UV * 16.0f); 
	
   	float shade = pattern(uv * zoom);
	ALBEDO = texture(sprite, UV).rgb;
	
	ALPHA = float(int((shade * 10.0f * background_threshold > 1.0f) || !disolve));
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
