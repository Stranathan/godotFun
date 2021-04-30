shader_type canvas_item;

void vertex()
{
	
}

uniform vec2 myPos = vec2(1.);
uniform vec2 camPos = vec2(1.);

uniform float aggroNum = 3;
uniform vec3 aggroCol = vec3(0.1, 0.2, 1.0);

void fragment() 
{
	vec2 fragCoord = FRAGCOORD.xy;
	vec2 iResolution = 1.0 / SCREEN_PIXEL_SIZE;
	
	vec2 uv = ( fragCoord -.5*iResolution.xy ) / iResolution.y;
	vec2 spritePos = ( myPos -.5*iResolution.xy ) / iResolution.y;
	vec2 cammy = ( camPos -.5*iResolution.xy ) / iResolution.y;
	
	float len = length(5. * (uv - vec2(spritePos.x, cammy.y - spritePos.y)));
	float colMask = sin(2.0 * pow(len, 2.5) -  aggroNum * TIME)/(2. * 3.14159 * len);
    vec3 col = aggroCol * colMask; // sin(10. * len - 20. * TIME);
    COLOR = vec4(col, 1.0);
}
