shader_type spatial;
render_mode blend_mix, depth_draw_opaque, cull_back, diffuse_burley, specular_schlick_ggx, unshaded;

uniform int lines = 80;
uniform float amplitude : hint_range(0.0, 1.0) = 0.9;
uniform float frequency : hint_range(0.0, 0.5) = 0.1;
uniform float intensity : hint_range(0.0, 1.0) = 0.75;
uniform float line_sharpness : hint_range(0.0, 1.0) = 0.5;
uniform float line_size : hint_range(0.0, 1.0) = 0.8;
uniform float fade : hint_range(0.0, 0.5) = 0.1;
uniform float rest_size : hint_range(-2., 2.) = -0.2;
uniform float edge : hint_range(0.0, 0.5) = 0.05;
uniform float speed = 0.5;
uniform vec4 color : source_color = vec4(.8, 0.25, 0.5, 1.0);
uniform bool dot_matrix = false;
uniform int dot_matriz_size = 80;
uniform bool speech_sim = true;
uniform float speech_intensity : hint_range(0.0, 2.0) = 0.8;
uniform float progress : hint_range(0.0, 1.0) = 1.0;

float random(vec2 uv) {
	return fract(sin(dot(uv.xy,
	vec2(12.9898,78.233))) * 43758.5453123);
}

float noise(vec2 uv) {
	vec2 uv_index = floor(uv);
	vec2 uv_fract = fract(uv);
	float a = random(uv_index);
	float b = random(uv_index + vec2(1.0, 0.0));
	float c = random(uv_index + vec2(0.0, 1.0));
	float d = random(uv_index + vec2(1.0, 1.0));
	vec2 blur = smoothstep(0.0, 1.0, uv_fract);
	return mix(a, b, blur.x) +
				(c - a) * blur.y * (1.0 - blur.x) +
				(d - b) * blur.x * blur.y;
}

float fbm(vec2 uv) {
	int octaves = 4;
	float amp = 0.5;
	float freq = 4.;
	float value = 0.0;
	for(int i = 0; i < octaves; i++) {
		value += amp * noise(freq * uv - 0.5);
		amp *= 0.6;
		freq *= 2.;
	}
	return value;
}

void fragment() {
	float time = TIME;
	vec4 c = vec4(vec3(0.0), 1.0);
	float f_columns = float(lines);
	
	float cutoff = smoothstep(0.0, edge, (round((UV.x) * (f_columns)) / f_columns));
	cutoff *= 1. - smoothstep(1.-edge, 1.0, (round((UV.x) * (f_columns)) / f_columns));
	
	float ss = 1.0;
	if (speech_sim == true){
		ss = fbm(vec2(1.0, time * speed * 1.3) * speech_intensity) * 1.5;
	}
	
	float noise = fbm(vec2(round((UV.x) * f_columns) * frequency, time * speed)) * ss * progress;
	noise *= cutoff;
	
	float wave = smoothstep(1.-intensity, 1.0, noise) * amplitude;
	wave = wave + (rest_size * 0.2);
	
	float line = abs(sin((f_columns * 3.1416 * UV.x) + 1.5));
	line = smoothstep(1.-line_size, (1.-line_size) + (1.-line_sharpness), line);
	
	if (dot_matrix){
		float dm = abs(sin((float(dot_matriz_size) * 3.1416 * UV.y) + 1.5));
		dm = smoothstep(1.-line_size, (1.-line_size) + (1.-line_sharpness), dm);
		line *= dm;
	}
	
	float mask = 1.0 - smoothstep(wave, wave + fade, abs(UV.y - 0.5) * 2.);
	line *= mask;
	
	c = vec4(line) * color;
	
	ALBEDO = c.rgb;
	ALPHA = c.a;
}