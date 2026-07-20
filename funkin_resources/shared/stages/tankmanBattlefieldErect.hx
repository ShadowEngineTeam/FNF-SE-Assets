import objects.BGSprite;
import flixel.math.FlxAngle;
import haxe.Json;
import flixel.effects.FlxFlicker;
import backend.Difficulty;
import animate.FlxAnimate;

var sniper;
var guy;

function onCreate(){
	var bg:BGSprite = new BGSprite("stages/tankmanBattlefield/erect/bg", -985, -809);
	bg.scale.set(1.15, 1.15);
	bg.updateHitbox();
	insert(members.indexOf(gfGroup), bg);
	
	sniper = new FlxAnimate(-100, 350);
	sniper.frames = Paths.getTextureAtlas("stages/tankmanBattlefield/erect/sniper");
	sniper.anim.addBySymbol("idle", "sniper idle", 24, false);
	sniper.anim.addBySymbol("sip", "sniper sip", 24, false);
	sniper.anim.play("idle");
	sniper.scale.set(1.15, 1.15);
	sniper.updateHitbox();
	insert(members.indexOf(gfGroup), sniper);
	
	guy = new FlxAnimate(1400, 400);
	guy.frames = Paths.getTextureAtlas("stages/tankmanBattlefield/erect/rando");
	guy.anim.addBySymbol("idle", "rando", 24, false);
	guy.anim.play("idle");
	guy.scale.set(1.15, 1.15);
	guy.updateHitbox();
	insert(members.indexOf(gfGroup), guy);
	
	var bricksGround:BGSprite = new BGSprite("stages/tankmanBattlefield/erect/bricksGround", 465, 760);
	bricksGround.scale.set(1.15, 1.15);
	bricksGround.updateHitbox();
	insert(members.indexOf(gfGroup) + 1, bricksGround);
	
	game.startHScriptsNamed("stages/props/tankmenStress");
}
function onCreatePost(){
	for (i in [dad, boyfriend, gf]) {
		if (ClientPrefs.data.shaders) updateCharacterShader(i);
	}
}
function onEvent(n){
	if (n == "Change Character") {
		for (i in [dad, boyfriend, gf]) {
			if (ClientPrefs.data.shaders) updateCharacterShader(i);
		}
	}
}
function onBeatHit() bopDance();
function bopDance(){
	if (curBeat % 2 == 0){
		guy.anim.play("idle", true);
		if (sniper.anim.curAnim.name != "sip" || sniper.anim.curAnim.name == "sip" && sniper.anim.curAnim.finished) sniper.anim.play(FlxG.random.bool(2) ? "sip" : "idle", true);
	}
}
function updateCharacterShader(char){
	var shader = new FlxRuntimeShader(Paths.getTextFromFile("shaders/dropshadow.frag"));
	
	shader.setFloatArray("dropColor", [0.937254902, 1, 0.278431373]);
	shader.setFloat("brightness", -46);
	shader.setFloat("hue", -38);
	
	shader.setFloat("contrast", -25);
	shader.setFloat("saturation", -20);
	shader.setFloat("AA_STAGES", 2);
	shader.setFloat("dist", 15);
	shader.setFloat("ang", 90 * FlxAngle.TO_RAD);
	shader.setFloat("thr", 0.1);
	shader.setFloat("thr2", 1);
	shader.setFloat("str", 1);
	if (char.isAnimate) char.useRenderTexture = true;
	char.animation.onFrameChange.add(function(){
		shader.setFloatArray("uFrameBounds", [char.frame.uv.left, char.frame.uv.top, char.frame.uv.right, char.frame.uv.bottom]);
		shader.setFloat("angOffset", char.frame.angle * FlxAngle.TO_RAD);
	});
	// I don't want my phone died 
	char.shader = shader;
	switch(char){
		case gf:
			if (char.curCharacter == 'nene-tankmen') { shader.setBitmapData("altMask", Paths.image('stages/tankmanBattlefield/erect/masks/neneTankmen_mask').bitmap);
				shader.setBool("useMask", true);
			}
			if (char.curCharacter == 'gf-tankmen') { shader.setBitmapData("altMask", Paths.image('stages/tankmanBattlefield/erect/masks/gfTankmen_mask').bitmap);
				shader.setBool("useMask", true);
			}
			shader.setFloat("thr2", 0.4);
		case dad:
			shader.setFloat("thr", 0.3);
			shader.setFloat("ang", 25 * FlxAngle.TO_RAD);
			if (char.curCharacter == "tankman-bloody"){
				shader.setBitmapData("altMask", Paths.image('stages/tankmanBattlefield/erect/masks/tankmanCaptainBloody_mask').bitmap);
				shader.setBool("useMask", true);
			}
	}
}