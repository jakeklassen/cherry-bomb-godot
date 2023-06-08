// https://godotshaders.com/shader/hit-flash-effect-shader/

shader_type canvas_item;

uniform bool active = false;
uniform vec4 flash_color: source_color = vec4(1.0, 0.945, 0.91, 1.0);

void fragment() {
	vec4 previous_color = texture(TEXTURE, UV);
	vec4 target_color = vec4(flash_color.r, flash_color.g, flash_color.b, previous_color.a);
	vec4 new_color = previous_color;

	if (active == true) {
		new_color = target_color;
	}

	COLOR = new_color;
}