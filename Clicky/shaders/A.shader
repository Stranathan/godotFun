shader_type canvas_item;

void fragment()
{
	vec2 uv = 2. *  UV - 1.;
	
	float gridX = fract((uv.x) * 20.);
	gridX = smoothstep(0.1, 0.11, gridX);
	float gridY = fract(uv.y * 20.);
	gridY = smoothstep(0.1, 0.11, gridY);
	vec3 matteRed = vec3(1., 0.2, 0.2);
	float grid = clamp(gridX * gridY, 0., 1.);
	vec3 col = grid * matteRed;
	COLOR = vec4(col, 0.4);
}