shader_type canvas_item;

uniform vec3 color : source_color = vec3(1);
uniform float color_intensity : hint_range(0.0, 1.0, 0.1) = 1.0;

void fragment() {
	float pixel_alpha = texture(TEXTURE, UV).a;
	vec4 final_color = mix(texture(TEXTURE, UV), vec4(color, pixel_alpha), color_intensity);
	COLOR = final_color;
}
