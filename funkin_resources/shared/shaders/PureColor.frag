#pragma header
uniform vec4 funnyColor;
uniform bool colSet;
void main() {
	vec4 color = flixel_texture2D(bitmap, openfl_TextureCoordv);
	if (color.a > 0.0 && colSet)
		color = funnyColor * color.a;
	gl_FragColor = color;
}