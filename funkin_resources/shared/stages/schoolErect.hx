import backend.CoolUtil;
import objects.BGSprite;
import flixel.addons.display.FlxRuntimeShader;
import flixel.math.FlxAngle;

var shaderUpdate = [];
//var bgGurl;
function onCreate() {
	var bgSky:BGSprite = new BGSprite('stages/weeb/erect/weebSky', -626, -78, 0.2, 0.2);
	insert(members.indexOf(gfGroup), bgSky);
	bgSky.antialiasing = false;
	
	var backTrees:BGSprite = new BGSprite('stages/weeb/erect/weebBackTrees', -842, -80, 0.5, 0.5);
	insert(members.indexOf(gfGroup), backTrees);
	backTrees.antialiasing = false;

	var bgSchool:BGSprite = new BGSprite('stages/weeb/erect/weebSchool', -816, -38, 0.75, 0.75);
	insert(members.indexOf(gfGroup), bgSchool);
	bgSchool.antialiasing = false;

	var bgStreet:BGSprite = new BGSprite('stages/weeb/erect/weebStreet', -662, 6);
	insert(members.indexOf(gfGroup), bgStreet);
	bgStreet.antialiasing = false;

	var fgTrees:BGSprite = new BGSprite('stages/weeb/erect/weebTreesBack', -500, 6);
	fgTrees.setGraphicSize(Std.int(fgTrees.width * 6));
	fgTrees.updateHitbox();
	insert(members.indexOf(gfGroup), fgTrees);
	fgTrees.antialiasing = false;

	var bgTrees:FlxSprite = new FlxSprite(-806, -1050);
	bgTrees.frames = Paths.getPackerAtlas('stages/weeb/erect/weebTrees');
	bgTrees.animation.add('treeLoop', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18], 12);
	bgTrees.animation.play('treeLoop');
	bgTrees.scrollFactor.set(0.85, 0.85);
	insert(members.indexOf(gfGroup), bgTrees);
	bgTrees.antialiasing = false;

	var treeLeaves:BGSprite = new BGSprite('stages/weeb/erect/petals', -20, -40, 0.85, 0.85, ['PETALS ALL'], true);
	treeLeaves.setGraphicSize(Std.int(treeLeaves.width * 6));
	treeLeaves.updateHitbox();
	insert(members.indexOf(gfGroup), treeLeaves);
	treeLeaves.antialiasing = false;
	
	/*bgGurl = new FlxSprite(-646, 180);
	bgGurl.frames = Paths.getSparrowAtlas('stages/weeb/bgFreaks');
	bgGurl.setGraphicSize(Std.int(bgGurl.width * 6));
	bgGurl.updateHitbox();
	insert(members.indexOf(gfGroup), bgGurl);
	bgGurl.antialiasing = false;
	bgGurl.animation.addByIndices('danceLeft', 'BG girls group', CoolUtil.numberArray(14), "", 24, false);
	bgGurl.animation.addByIndices('danceRight', 'BG girls group', CoolUtil.numberArray(30, 15), "", 24, false);*/
	
	bgSky.setGraphicSize(Std.int(bgSky.width * 6));
	bgSchool.setGraphicSize(Std.int(bgSchool.width * 6));
	bgStreet.setGraphicSize(Std.int(bgStreet.width * 6));
	bgTrees.setGraphicSize(Std.int(bgTrees.width * 6));

	bgSky.updateHitbox();
	bgSchool.updateHitbox();
	bgStreet.updateHitbox();
	bgTrees.updateHitbox();

	switch (songName.toLowerCase()) {
		case 'roses':
			FlxG.sound.play(Paths.sound('ANGRY_TEXT_BOX'));
			bgSky.setGraphicSize(Std.int(bgSky.width * 6));
			//bgGurl.animation.addByIndices('danceLeft', 'BG fangirls dissuaded', CoolUtil.numberArray(14), "", 24, false);
			//bgGurl.animation.addByIndices('danceRight', 'BG fangirls dissuaded', CoolUtil.numberArray(30, 15), "", 24, false);
	}
	game.startHScriptsNamed("stages/props/DialoguePixel");
	game.startHScriptsNamed("stages/props/pixel");
	//bgGurl.animation.play("danceLeft");
}
var start = false;
var seen = !PlayState.seenCutscene;
function onStartCountdown() {
	if (!start && seen && PlayState.isStoryMode) {
		game.callOnScripts("startConversation");
		start = true;
		return "##PSYCHLUA_FUNCTIONSTOP";
	}
}
function onUpdatePost(){
	for (i in shaderUpdate) if (i != null) i();
}
function onCreatePost(){
	//updateCharacterShader(bgGurl);
	game.callOnScripts("applyAbotDropShadowShader");
	for (a in [dad, boyfriend, gf])
		if (ClientPrefs.data.shaders)
			updateCharacterShader(a);
	
}
//function onBeatHit() bgGurl.animation.play(curBeat % 2 == 0 ? "danceRight" : "danceLeft");
//function onCountdownTick(t) bgGurl.animation.play(t % 2 == 0 ? "danceRight" : "danceLeft");
function updateCharacterShader(char){
	var shader = new FlxRuntimeShader(Paths.getTextFromFile("shaders/dropshadow.frag"));
	
	shader.setFloatArray("dropColor", [0.321568627, 0.207843137, 0.11372549]);
	shader.setFloat("brightness", -66);
	shader.setFloat("hue", 10);
	shader.setFloat("contrast", 24);
	shader.setFloat("saturation", -24);
	shader.setFloat("AA_STAGES", 0);
	shader.setFloat("dist", 5);
	shader.setFloat("ang", 90 * FlxAngle.TO_RAD);
	shader.setFloat("thr", 0.1);
	shader.setFloat("thr2", 1);
	shader.setFloat("str", 1);
	char.animation.onFrameChange.add(function(){
		shader.setFloatArray("uFrameBounds", [char.frame.uv.left, char.frame.uv.top, char.frame.uv.right, char.frame.uv.bottom]);
		shader.setFloat("angOffset", char.frame.angle * FlxAngle.TO_RAD);
	});
	shaderUpdate.push(function(){
		shader.setFloatArray("uFrameBounds", [char.frame.uv.left, char.frame.uv.top, char.frame.uv.right, char.frame.uv.bottom]);
		shader.setFloat("angOffset", char.frame.angle * FlxAngle.TO_RAD);
	});
	char.shader = shader;
	switch(char){
		case gf:
			shader.setFloat("brightness", -42);
			shader.setFloat("hue", -10);
			shader.setFloat("contrass", 5);
			shader.setFloat("saturation", -25);
			shader.setFloat("dist", 3);
			shader.setFloat("thr", 0.3);
			shader.setFloat("thr2", 1);
			if (char.curCharacter == 'nene-pixel') { shader.setBitmapData("altMask", Paths.image('stages/weeb/erect/masks/nenePixel_mask').bitmap);
				shader.setBool("useMask", true);
			}
			if (char.curCharacter == 'gf-pixel') { shader.setBitmapData("altMask", Paths.image('stages/weeb/erect/masks/gfPixel_mask').bitmap);
				shader.setBool("useMask", true);
			}
		case dad | boyfriend:
			if (char.curCharacter == 'senpai' || char.curCharacter == 'senpai-angry') { shader.setBitmapData("altMask", Paths.image('stages/weeb/erect/masks/senpai_mask').bitmap);
				shader.setBool("useMask", true);
			}
			if (char.curCharacter == 'pico-pixel') { shader.setBitmapData("altMask", Paths.image('stages/weeb/erect/masks/picoPixel_mask').bitmap);
				shader.setBool("useMask", true);
			}
			if (char.curCharacter == 'bf-pixel') { shader.setBitmapData("altMask", Paths.image('stages/weeb/erect/masks/bfPixel_mask').bitmap);
				shader.setBool("useMask", true);
			}
	}
}