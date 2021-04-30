shader_type canvas_item;

float when_lt(float x, float y)
{
	return max(sign(y - x), 0.0);
}
float when_gt(float x, float y) 
{
	return max(sign(x - y), 0.0);
}

void fragment() 
{
	vec2 uv = 2. * UV - 1.;
	float len = length(uv);
	float mask = 1. - smoothstep(0.3, 0.35, len);
	vec3 col = vec3(0.2, 0.9, 0.2) * mask; //sin(5. * TIME) * len;
	
	COLOR = vec4(col, when_gt(mask, 0));
}