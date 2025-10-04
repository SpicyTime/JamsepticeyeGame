shader_type canvas_item;


uniform vec4 color: source_color;
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture;
uniform float alarm_strength: hint_range(0.0, 1.0) = 0.0;
void fragment() {
	vec4 pixelColor = texture(SCREEN_TEXTURE, SCREEN_UV);
	float brightness = (pixelColor.r + pixelColor.b + pixelColor.g)  / 3.0;
	vec4 grayScale = vec4(brightness, brightness, brightness, pixelColor.a * alarm_strength);
	COLOR = grayScale * color;
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
