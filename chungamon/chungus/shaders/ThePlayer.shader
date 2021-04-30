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
	
	vec3 col = vec3(1., 0.0, 0.0); // + 10.0 * exp(-(50. * timer * timer));
    COLOR = vec4(col, 1.0);
}
