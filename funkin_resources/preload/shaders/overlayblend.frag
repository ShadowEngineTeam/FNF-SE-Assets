#pragma header

uniform float alphaShit;
uniform float yPos;
uniform float xPos;

uniform sampler2D funnyShit;


vec4 blendOverlay(vec4 base, vec4 blend) {
	vec4 mixed = mix(1.0 - 2.0 * (1.0 - base) * (1.0 - blend), 2.0 * base * blend, step(base, vec4(0.5)));

	// mixed = mix(mixed, blend, base.a); // proper alpha mixing?

	return mixed;
}

void main() {
	vec2 funnyUv = openfl_TextureCoordv;
	vec4 color = flixel_texture2D(bitmap, funnyUv);

	vec2 reallyFunnyUv = vec2(vec2(0.0, 0.0) - gl_FragCoord.xy / openfl_TextureSize.xy);

	vec4 gf = flixel_texture2D(funnyShit, openfl_TextureCoordv.xy + vec2(0.1, 0.2));


	vec4 mixedCol = blendOverlay(color, gf);

	gl_FragColor = mixedCol;
}