#pragma header

uniform float sprX;
uniform float maskX;

uniform float uvFrameX;
uniform float uvFrameY;

void main() {

	float cutOff = maskX - sprX;
	float sprPos = cutOff / openfl_TextureSize.x;

	vec2 uv = openfl_TextureCoordv.xy;

	vec4 color = flixel_texture2D(bitmap, uv);

	if (uv.x < sprPos + uvFrameX) {
		color = vec4(0.0, 0.0, 0.0, 0.0);
	}

	gl_FragColor = color;
	// vec4 testCol = vec4(openfl_Position.x, openfl_Position.y, openfl_Position.z, 1.0);
	//gl_FragColor = vec4(1.0, openfl_TextureSize.x, 1.0, 1.0);

}