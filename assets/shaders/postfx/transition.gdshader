shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;

global uniform float transition_amount = 0.0;

void fragment() {
	vec4 output_colour = vec4(1.0f, 1.0f, 1.0f, 1.0f);
	
	// Even or odd row
	float div = 2.0f;
	float num = floor(SCREEN_UV.y * 10.0f);
	float odd = num - (div * floor(num/div));
	
	// Transition
	vec2 translate = SCREEN_UV;
	if (odd == 0.0f)
	{
		translate.x  = translate.x - transition_amount;
		output_colour = textureLod(screen_texture, translate, 0.0);
		if (translate.x < 0.0)
		{
			output_colour = vec4(0,0,0,1);
		}
	}
	else
	{
		translate.x = translate.x + transition_amount;
		output_colour = textureLod(screen_texture, translate, 0.0);
		if (translate.x > 1.0)
		{
			output_colour = vec4(0,0,0,1);
		}
	}
	
	COLOR = output_colour;
}
