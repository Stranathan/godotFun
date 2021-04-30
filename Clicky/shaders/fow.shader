shader_type canvas_item;

float when_eq(float x, float y) {
  return 1.0 - abs(sign(x - y));
}

float when_neq(float x, float y) {
  return abs(sign(x - y));
}

float when_gt(float x, float y) {
  return max(sign(x - y), 0.0);
}

float when_lt(float x, float y) {
  return max(sign(y - x), 0.0);
}

float when_ge(float x, float y) {
  return 1.0 - when_lt(x, y);
}

float when_le(float x, float y) {
  return 1.0 - when_gt(x, y);
}

float smin( float a, float b, float k )
{
    float h = clamp( 0.5+0.5*(b-a)/k, 0.0, 1.0 );
    return mix( b, a, h ) - k*h*(1.0-h);
}

uniform vec2 aClickyPos = vec2(0.);
uniform vec2 rocketPos = vec2(0.);

void fragment()
{
	vec2 uv = 2. *  UV - 1.;
	float lenClicky = length(uv - aClickyPos);
	float lenRocket = length(uv - rocketPos);
	float kParam = mix(0., 1., length(aClickyPos - rocketPos));
	float s = smin(lenClicky, lenRocket, 0.2 + kParam);
	
	float val = 20. * s;
	vec3 col = vec3(1. - clamp(val, 0., 1));
	COLOR = vec4(col, val);
}