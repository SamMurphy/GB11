shader_type canvas_item;

uniform float flash_value = 0.0;
uniform vec4 flash_colour = vec4(1.0, 1.0, 1.0, 1.0);

void fragment(){
	vec4 texture_colour = texture(TEXTURE, UV);
	COLOR = mix(texture_colour, flash_colour, flash_value);
}
