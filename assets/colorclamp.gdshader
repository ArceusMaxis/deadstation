shader_type canvas_item;
render_mode unshaded;

uniform bool enabled = true;
uniform bool dithering = true;
uniform int colors : hint_range(1, 256, 1) = 12;
uniform int dither_size : hint_range(1, 8) = 1;
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

const int _S=4;
const float _M[16]=float[](
    0.00,0.50,0.10,0.65,
    0.75,0.25,0.90,0.35,
    0.20,0.70,0.05,0.50,
    0.95,0.40,0.80,0.30
);

float _b(ivec2 _c){
    ivec2 _m = ivec2(_c.x % _S, _c.y % _S);
    return _M[_m.y * _S + _m.x];
}

float _q(float _r, float _t, int _n){
    float N = float(_n);
    float f = clamp(_r,0.0,1.0)*N;
    float i = floor(f);
    float fr = f - i;
    float th = _t * 0.999;
    float k = i + (1.0 - step(fr, th));
    return k / N;
}

void fragment(){
    vec4 R = texture(SCREEN_TEXTURE, SCREEN_UV);
    ivec2 U = ivec2(FRAGCOORD.xy / float(max(dither_size,1)));

    if (enabled){
        float T = dithering ? _b(U) : 1.0;
        float S = (T - 0.5) * T + 0.5;
        int N = max(colors - 1, 1);    // avoid div-by-zero when colors==1, this kicked my ass
        COLOR.rgb = vec3(
            _q(R.r, S, N),
            _q(R.g, S, N),
            _q(R.b, S, N)
        );
    } else {
        COLOR.rgb = R.rgb;
    }
}