#define NUM_COLOURS 4
#define BRIGHTNESS 1.0

shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;
uniform sampler2D bayer_texture : repeat_enable, filter_nearest_mipmap;

uniform float dither_amount = 0;
uniform float brightness = 1.0;
uniform float contrast = 1.0;
uniform float saturation = 1.0;
uniform vec3[NUM_COLOURS] pallette;

vec3 find_closest (vec3 original_colour) {	
	vec3 out_colour = vec3 (100.0*255.0);
	
    for (int i = 0; i < NUM_COLOURS; i++)
    {
        float dist = distance(out_colour, original_colour);
        float dist2 = distance(pallette[i], original_colour);
        float closest = step(dist, dist2);
        out_colour = mix(pallette[i], out_colour, closest);
    }
    
	return out_colour ;
}

void fragment() {
    vec3 screen_colour = textureLod(screen_texture, SCREEN_UV, 0.0).rgb;
	
	screen_colour.rgb = mix(vec3(0.0), screen_colour.rgb, brightness);
    screen_colour.rgb = mix(vec3(0.5), screen_colour.rgb, contrast);
    screen_colour.rgb = mix(vec3(dot(vec3(1.0), screen_colour.rgb) * 0.33333), screen_colour.rgb, saturation);
	
	float bayer = textureLod(bayer_texture, FRAGCOORD.xy/8.0, 0.0).r;
	vec3 dithered = step(bayer, screen_colour);
	
	vec3 out_colour = mix(screen_colour, dithered, dither_amount);
	out_colour *= 255.0;
    out_colour = find_closest(out_colour);
    out_colour /= 255.0;
	
	COLOR = vec4(out_colour, 1.0);
}