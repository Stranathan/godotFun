shader_type canvas_item;

void vertex()
{
}

//uniform vec3 testCol = vec3(1., 1., 1.);
uniform float attackTimer = 50;

void fragment() 
{
//	vec2 fragCoord = FRAGCOORD.xy;
//	vec2 iResolution = 1.0 / SCREEN_PIXEL_SIZE;
//	vec2 uv = ( fragCoord -.5*iResolution.xy ) / iResolution.y;
	
	vec3 col = vec3(1., 0.1, 0.7) + 20.0 * exp(-(100.0 * attackTimer * attackTimer));
    COLOR = vec4(col, 1.0);
}
