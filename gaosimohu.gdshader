shader_type canvas_item;

uniform float f:hint_range(0.0,5.0);
uniform sampler2D screen_texture:hint_screen_texture,repeat_disable,filter_linear_mipmap;

void fragment() {
	COLOR.rgb=texture(screen_texture,SCREEN_UV,f).rgb;
}

