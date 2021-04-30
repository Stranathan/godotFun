shader_type canvas_item;

float when_lt(float x, float y)
{
	return max(sign(y - x), 0.0);
}

uniform float stateClock;

//void fragment() 
//{
//	float rad = 0.3;
//	float delta = 0.05;
//	vec2 uv = UV - vec2(0.5);
//	float angle = atan(uv.y / uv.x + 0.001);
//    float r = 0.3 + 0.075 * stateClock * cos(angle * 10.);
//    float something = smoothstep(r, r + 0.2, length(uv));
//
//    vec3 col = vec3(1., 0., 1.) * (1. - something);
//
//	COLOR = vec4(col, when_lt(rad + delta, 1. - something));
//}
void fragment() 
{
	vec2 uv = 2. * UV - 1.;
	float angle = atan(uv.y / uv.x);
	float len = length(uv) - stateClock * sin(32. * stateClock) * 0.1 * cos(6. * (angle - TIME));
	len = smoothstep(0.8, 1., len);
    vec3 col = vec3(1., 0., 1.) * (1. - len);
	
	float rad = 0.3;
	float delta = 0.05;
	COLOR = vec4(col, when_lt(rad + delta, 1. - len));
}