import objects.BGSprite;
import shaders.WiggleEffect;
import effects.RetroCameraFade;

var bgGurl;
var shaderUpdate = [];
function onCreate() {
	var backspikes = new BGSprite('stages/weeb/erect/evil/weebBackSpikes', -842, -180, 0.5, 0.5);
	insert(members.indexOf(gfGroup), backspikes);
	backspikes.antialiasing = false;
	
	var school = new BGSprite('stages/weeb/erect/evil/weebSchool', -816, -38, 0.75, 0.75);
	insert(members.indexOf(gfGroup), school);
	school.antialiasing = false;
	
	
	var backspike = new BGSprite('stages/weeb/erect/evil/backSpike', 1416, 464, 0.85, 0.85);
	insert(members.indexOf(gfGroup), backspike);
	backspike.antialiasing = false;
	
	var street = new BGSprite('stages/weeb/erect/evil/weebStreet', -662, 6);
	insert(members.indexOf(gfGroup), street);
	street.antialiasing = false;
	


	
	bgGurl = new BGSprite("stages/weeb/evil/bgGhouls", -646, 210, 1, 1, ["BG freaks glitch instance 1"]);
	bgGurl.setGraphicSize(Std.int(bgGurl.width * 6));
	bgGurl.updateHitbox();
	insert(members.indexOf(gfGroup), bgGurl);
	bgGurl.antialiasing = bgGurl.visible = false;
	bgGurl.animation.finishCallback = (name) -> bgGurl.visible = false;
	
	
	school.setGraphicSize(Std.int(school.width * 6));
	backspike.setGraphicSize(Std.int(backspike.width * 6));
	backspikes.setGraphicSize(Std.int(backspikes.width * 6));
	street.setGraphicSize(Std.int(street.width * 6));

	school.updateHitbox();
	backspike.updateHitbox();
	backspikes.updateHitbox();
	street.updateHitbox();
	for (i in 0...4){
		var obj = [backspikes, school, backspike, street][i];
		var shader = new FlxRuntimeShader(Paths.getTextFromFile("shaders/wiggle.frag"));
		shader.setFloat("effectType", 0);
		shader.setFloat("uSpeed", [1.6, 2, 2, 2][i]);
		shader.setFloat("uFrequency", [1.6, 4, 4, 4][i]);
		shader.setFloat("uWaveAmplitude", [0.011, 0.017, 0.01, 0.007][i]);
		shader.setFloat("uTime", 0);
		shaderUpdate.push(shader);
		obj.shader = shader;
	}
	game.startHScriptsNamed("stages/props/DialoguePixel");
	game.startHScriptsNamed("stages/props/pixel");
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
						FlxG.camera.filters = [];
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
		return "##PSYCHLUA_FUNCTIONSTOP";
	}
	if (!start && seen && PlayState.isStoryMode) {
		game.callOnScripts("startConversation");
		start = true;
		return "##PSYCHLUA_FUNCTIONSTOP";
	}
}
function onUpdatePost(e){
	for (a in shaderUpdate) a.setFloat("uTime", a.getFloat("uTime") + e * game.playbackRate);
}
function onEvent(n){
	if (n == "BG Freak Ghost") {
		bgGurl.visible = true;
		bgGurl.dance(true);
	}
}