import objects.BGSprite;
import shaders.WiggleEffect;
import effects.RetroCameraFade;
var bgGurl;
var shaderUpdate = [];
function onCreate() {
	
	var backtrees:BGSprite = new BGSprite('stages/weeb/evil/weebBackTrees', -842, -180, 0.5, 0.5);
	insert(members.indexOf(gfGroup), backtrees);
	backtrees.antialiasing = false;

	var school:BGSprite = new BGSprite('stages/weeb/evil/weebSchool', -816, -38, 0.75, 0.75);
	insert(members.indexOf(gfGroup), school);
	school.antialiasing = false;
	
	var street:BGSprite = new BGSprite('stages/weeb/evil/weebStreet', -662, 6);
	insert(members.indexOf(gfGroup), street);
	street.antialiasing = false;
	
	var trees:BGSprite = new BGSprite('stages/weeb/evil/weebTrees', -662, 6);
	insert(members.indexOf(gfGroup), trees);
	trees.antialiasing = false;
	
	bgGurl = new BGSprite("stages/weeb/evil/bgGhouls", -646, 222, 1, 1, ["BG freaks glitch instance 1"]);
	bgGurl.setGraphicSize(Std.int(bgGurl.width * 6));
	bgGurl.updateHitbox();
	insert(members.indexOf(gfGroup), bgGurl);
	bgGurl.antialiasing = bgGurl.visible = false;
	bgGurl.animation.finishCallback = (name) -> bgGurl.visible = false;

	school.setGraphicSize(Std.int(school.width * 6));
	trees.setGraphicSize(Std.int(trees.width * 6));
	backtrees.setGraphicSize(Std.int(backtrees.width * 6));
	street.setGraphicSize(Std.int(street.width * 6));

	school.updateHitbox();
	trees.updateHitbox();
	backtrees.updateHitbox();
	street.updateHitbox();
	for (i in 0...4){
		var obj = [backtrees, school, trees, street][i];
		var shader = new FlxRuntimeShader(Paths.getTextFromFile("shaders/wiggle.frag"));
		shader.setFloat("effectType", 0);
		shader.setFloat("uSpeed", [1.6, 2, 2, 2][i]);
		shader.setFloat("uFrequency", [1.6, 4, 4, 4][i]);
		shader.setFloat("uWaveAmplitude", [0.011, 0.017, 0.01, 0.007][i]);
		shader.setFloat("uTime", 0);
		shaderUpdate.push(shader);
		obj.shader = shader;
	}
	game.startHScriptsNamed("stages/props/pixel");
	game.startHScriptsNamed("stages/props/DialoguePixel");
}
var trandomf = false;
var start = false;
var seen = !PlayState.seenCutscene;
function onStartCountdown() {
	if (!trandomf && seen && PlayState.isStoryMode){
		camHUD.visible = false;
		trandomf = true;
		var redBG = new FlxSprite().makeGraphic(FlxG.width,FlxG.height,0xFFFF1B31);
		redBG.scrollFactor.set();
		add(redBG);
		var senpai = new BGSprite("stages/weeb/senpaiCrazy",0,0,0,0,["Senpai Pre Explosion instance 1"]);
		senpai.dance(true);
		senpai.animation.curAnim.paused = true;
		senpai.scale.set(6,6);
		senpai.updateHitbox();
		senpai.screenCenter();
		senpai.antialiasing = false;
		senpai.alpha = 0;
		senpai.x += senpai.width/5;
		add(senpai);
		FlxG.sound.playMusic(Paths.music("weeb/LunchboxScary"));
		new FlxTimer().start(0.3, function(timer) {
			senpai.alpha += 0.15;
			if (senpai.alpha < 1) timer.reset();
			else {
				senpai.alpha = 1;
				senpai.dance(true);
				FlxG.sound.play(Paths.sound('weeb/senpai_Dies'),1,false,null,true, function() {
						remove(redBG);
						RetroCameraFade.fadeBlack(FlxG.camera, 6, 1.4);
						new FlxTimer().start(1.4, function(){
							FlxG.camera.filters = [];
							game.startCountdown();
						});
				});
				
				new FlxTimer().start(3.2, function() {
					RetroCameraFade.fadeWhite(FlxG.camera, 8, 1.4);
					new FlxTimer().start(1.4,function() {
						FlxG.camera.filters = [];
						remove(senpai);
						RetroCameraFade.fadeToBlack(FlxG.camera, 8, 0.8);
					});
				});
			}
		});
		return Function_Stop;
	}
	if (!start && seen && PlayState.isStoryMode) {
		game.callOnScripts("startConversation");
		start = true;
		return Function_Stop;
	}
}
function onUpdate(e){
	for (a in shaderUpdate) a.setFloat("uTime", a.getFloat("uTime") + e * game.playbackRate);
}
function onEvent(n){
	if (n == "BG Freak Ghost") {
		bgGurl.visible = true;
		bgGurl.dance(true);
	}
}