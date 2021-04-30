shader_type canvas_item;

uniform float _PerlinPrecision = 8.0;
uniform float _PerlinOctaves = 8.0;
uniform float _PerlinSeed = 0.0;

float when_lt(float x, float y)
{
	return max(sign(y - x), 0.0);
}
float when_gt(float x, float y) 
{
	return max(sign(x - y), 0.0);
}
float rnd(vec2 xy)
{
    return fract(sin(dot(xy, vec2(12.9898-_PerlinSeed, 78.233+_PerlinSeed)))* (43758.5453+_PerlinSeed));
}
float inter(float a, float b, float x)
{
    //return a*(1.0-x) + b*x; // Linear polation

    float f = (1.0 - cos(x * 3.1415927)) * 0.5; // Cosine interpolation
    return a*(1.0-f) + b*f;
}
float perlin(vec2 uv)
{
    float a,b,c,d, coef1,coef2, t, p;

    t = _PerlinPrecision;					// Precision
    p = 0.0;								// Final heightmap value

    for(float i=0.0; i<_PerlinOctaves; i++)
    {
        a = rnd(vec2(floor(t*uv.x)/t, floor(t*uv.y)/t));	//	a----b
        b = rnd(vec2(ceil(t*uv.x)/t, floor(t*uv.y)/t));		//	|    |
        c = rnd(vec2(floor(t*uv.x)/t, ceil(t*uv.y)/t));		//	c----d
        d = rnd(vec2(ceil(t*uv.x)/t, ceil(t*uv.y)/t));

        if((ceil(t*uv.x)/t) == 1.0)
        {
            b = rnd(vec2(0.0, floor(t*uv.y)/t));
            d = rnd(vec2(0.0, ceil(t*uv.y)/t));
        }

        coef1 = fract(t*uv.x);
        coef2 = fract(t*uv.y);
        p += inter(inter(a,b,coef1), inter(c,d,coef1), coef2) * (1.0/pow(2.0,(i+0.6)));
        t *= 2.0;
    }
    return p;
}
float smoke(vec2 p, float widthNoise, float blurVal)
{
    float d = length(p - vec2(0., clamp(p.y, -0.5, 0.5)));
    //float m = smoothstep(widthNoise, widthNoise + blurVal, d);
    float baseRadius = 0.1;
    float blah = baseRadius * (2. * (0.5 - 2. * p.y*p.y));
    float n = smoothstep(-0.5, 0.5, p.y) * 3. * widthNoise;
    float m = smoothstep(blah,  blah + n, d);
    return 1. - m;
}

void fragment()
{
	vec2 uv = 2. *  UV - 1.;

    vec3 col = 0.5 + 0.5*cos(TIME + uv.xyx + vec3(0,2,4));
    float noise = perlin(uv - vec2(0., 1. * TIME));
     
	float val = smoke(uv, noise * 0.1 , noise * 0.01);
	col *= val;
	COLOR = vec4(col, when_gt(val, 0.01));
}