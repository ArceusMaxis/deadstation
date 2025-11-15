shader_type canvas_item;
render_mode unshaded;

uniform highp float cell_size = 4.0;
uniform highp float move_speed = 0.5;
uniform highp float distortion_amount = 0.3;
uniform highp float distortion_speed = 1.0;
uniform highp float color_shift_speed = 0.5;
uniform highp float spin_speed = 0.3;

uniform int num_colors = 5;
uniform highp vec4 color_array[10] : source_color;

vec2 hash2(vec2 p) {
    p = vec2(dot(p, vec2(127.1, 311.7)), dot(p, vec2(269.5, 183.3)));
    return -1.0 + 2.0 * fract(sin(p) * 43758.5453123);
}

float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    vec2 u = f * f * (3.0 - 2.0 * f);
    return mix(mix(dot(hash2(i + vec2(0.0, 0.0)), f - vec2(0.0, 0.0)),
                   dot(hash2(i + vec2(1.0, 0.0)), f - vec2(1.0, 0.0)), u.x),
               mix(dot(hash2(i + vec2(0.0, 1.0)), f - vec2(0.0, 1.0)),
                   dot(hash2(i + vec2(1.0, 1.0)), f - vec2(1.0, 1.0)), u.x), u.y);
}

vec2 rot2(vec2 p, float a) {
    float c = cos(a), s = sin(a);
    return vec2(c*p.x - s*p.y, s*p.x + c*p.y);
}

vec3 voronoi(vec2 p, float t) {
    vec2 n = floor(p);
    vec2 f = fract(p);
    float md = 10.0;
    vec2 mc = vec2(0.0);
    for (int j = -1; j <= 1; j++) {
        for (int i = -1; i <= 1; i++) {
            vec2 g = vec2(float(i), float(j));
            vec2 id = n + g;
            vec2 point = g + hash2(id) * 0.5 + 0.5;
            point += sin(t + hash2(id) * 6.2831853) * 0.2;
            float d = length(f - point);
            if (d < md) {
                md = d;
                mc = id;
            }
        }
    }
    return vec3(mc, md);
}

void fragment() {
    float t = TIME;
    vec2 p = UV * cell_size;
    vec2 pivot = vec2(0.5 * cell_size);
    p = rot2(p - pivot, -t * spin_speed) + pivot;

    vec2 d = vec2(noise(p * 2.0 + t * distortion_speed),
                  noise(p * 2.0 + t * distortion_speed + 100.0)) * distortion_amount;
    p += d;

    vec3 v = voronoi(p, t * move_speed);
    float hv = fract(sin(dot(v.xy, vec2(12.9898, 78.233))) * 43758.5453);
    float ncols = max(1.0, float(num_colors));
    int idx = int(mod(hv * ncols + t * color_shift_speed, ncols));
    vec3 col = color_array[idx].rgb;

    COLOR = vec4(col, 1.0);
}