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

void fragment()
{
	vec2 uv = 2. *  UV - 1.;
//	float len = length(uv);
//	float startRadius = 0.0;
//	float endRadius = 0.4;
//	float transparencyInterpolant = smoothstep(startRadius, endRadius, len);
//	vec3 col = vec3(0.14);
//
//	float i = mix(0., 1., transparencyInterpolant);
	vec3 col = vec3(0.);
	COLOR = vec4(col, 1.);
}