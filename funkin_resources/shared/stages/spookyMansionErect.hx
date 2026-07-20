import objects.BGSprite;
var lighBG = [];
function onCreate() {
	game.startHScriptsNamed("stages/props/rainShader");
	FlxG.camera.filters = [];
	var rain=game.callOnScripts("getRainShader");
	game.callOnScripts("setRainAutoUpdate", [false]);
	game.callOnScripts("setRainIntensity", [0.4,0.4]);
	rain.setBool("uSpriteMode", true);
	rain.setFloat("uScale", FlxG.height / 200 * 2);
	
	var graphic = new FlxSprite(-300, -500).makeGraphic(1,1,0xFf242336);
	graphic.scale.set(2400, 2000);
	graphic.updateHitbox();
	insert(members.indexOf(gfGroup), graphic);
	
	var bgTrees = new BGSprite("stages/spookyMansion/erect/bgtrees", 200, 50, 0.8, 0.8, ["bgtrees"], true);
	bgTrees.shader = rain;
	bgTrees.animation.onFrameChange.add(function(){
		var rain=game.callOnScripts("getRainShader");
		rain.updateFrameInfo(bgTrees.frame);
	});
	insert(members.indexOf(gfGroup), bgTrees);
	
	var bgDark = new BGSprite("stages/spookyMansion/erect/bgDark",-560,-220);
	insert(members.indexOf(gfGroup), bgDark);
	
	var bgLight = new BGSprite("stages/spookyMansion/erect/bgLight",-560,-220);
	insert(members.indexOf(gfGroup), bgLight);
	lighBG.push(bgLight);
	
	var stairDark = new BGSprite("stages/spookyMansion/erect/stairsDark",966, -225);
	add(stairDark);
	
	var stairLight = new BGSprite("stages/spookyMansion/erect/stairsLight",966, -225);
	add(stairLight);
	lighBG.push(stairLight);
	
	for (i in lighBG) i.alpha = 0;
}
function onCreatePost(){
	remove(game.boyfriendGroup);
	addBehindDad(boyfriendGroup);
	for (i in [gf, dad, boyfriend]){
		if (i == null) continue;
		var sub = i.curCharacter;
		sub = sub.substr(0, sub.length - 5);
		sub = sub.toLowerCase();
		if (sub == "pico") sub = "pico-playable";
		if (!Paths.fileExists("characters/" + sub + ".json")) continue;
		var chara = new Character(0,0,sub);
		if (chara.isAnimate) chara.useRenderTexture = true;
		
		i.anim.onFrameChange.add(function(){
			chara.flipX = i.flipX;
			chara.setPosition(i.x, i.y);
			chara.playAnim(i.anim.curAnim.name,true,false,i.anim.curAnim.curFrame);
			chara.anim.curAnim.frameRate = 0;
		});
		dadGroup.add(chara);
		chara.anim.onFrameChange.add(function(){ 
			chara.holdTimer = 0;
			chara.anim.curAnim.frameRate = 0;
		});
		game.callOnHScript("applyDarkAbot", [chara]);
		chara.alpha = 0.001;
		lighBG.push(chara);
	}
}
var lightningStrikeBeat:Int = 0;
var lightningStrikeOffset:Int = 8;
function onSongRestart() {
	lightningStrikeBeat = 0;
}
function onBeatHit(){
	if (curBeat == 4&&PlayState.SONG.song == "spookeez") doLightningStrike(false, curBeat);
	if (FlxG.random.bool(10) && curBeat > (lightningStrikeBeat + lightningStrikeOffset)) doLightningStrike(true, curBeat);
}
function doLightningStrike(playSound, beat) {
	if (playSound) {
		FlxG.sound.play(Paths.sound("spookyMansion/thunder_" + FlxG.random.int(8, 24)));
	}
	lightningStrikeBeat = beat;
	lightningStrikeOffset = FlxG.random.int(8, 24);
	for (i in lighBG) i.alpha = 1;
	boyfriend.playAnim("scared");
	boyfriend.specialAnim = true;
	gf.playAnim("scared");
	gf.specialAnim = true;
	var timer = 0.06 / game.playbackRate;
	new FlxTimer().start(timer, function() for (i in lighBG) i.alpha = 0);
	new FlxTimer().start(timer*2, function() 
		for (i in lighBG) {
			i.alpha = 1;
			FlxTween.tween(i,{alpha: 0}, timer*25);
		}
	);
}