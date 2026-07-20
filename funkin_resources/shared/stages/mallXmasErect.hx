import objects.BGSprite;
import animate.FlxAnimate;
import shaders.AdjustColorShader;
var bopperShit;
function onCreate() {
	var shader = new AdjustColorShader();
	shader.hue = 5;
	shader.brightness = 20;
	var mallWall = new BGSprite("stages/christmas/erect/bgWalls", -726, -566, 0.2, 0.2);
	mallWall.scale.set(0.8, 0.8);
	mallWall.updateHitbox();
	insert(members.indexOf(gfGroup), mallWall);
	
	var mallUpperBopper = new BGSprite("stages/christmas/erect/upperBop", -374, -98, 0.28, 0.28, ["upperBop"]);
	mallUpperBopper.scale.set(0.85, 0.85);
	mallUpperBopper.updateHitbox();
	insert(members.indexOf(gfGroup), mallUpperBopper);
	
	var mallEscalator = new BGSprite("stages/christmas/erect/bgEscalator", -1100, -540, 0.3, 0.3);
	mallEscalator.scale.set(0.9, 0.9);
	mallEscalator.updateHitbox();
	insert(members.indexOf(gfGroup), mallEscalator);
	
	var mallTree = new BGSprite("stages/christmas/erect/christmasTree", 370, -250, 0.4, 0.4);
	insert(members.indexOf(gfGroup), mallTree);
	
	var whiteThingIdk = new BGSprite("stages/christmas/erect/white", -1000, 100, 0.85, 0.85);
	whiteThingIdk.scale.set(0.9, 0.9);
	whiteThingIdk.updateHitbox();
	insert(members.indexOf(gfGroup), whiteThingIdk);
	
	var mallBottomBopper = new FlxAnimate(-300, -130);
	mallBottomBopper.frames = Paths.getTextureAtlas("stages/christmas/erect/bottomBop");
	mallBottomBopper.anim.addBySymbol("idle", "BOPPERS_EXPORT", 24, false);
	mallBottomBopper.applyStageMatrix = true;
	mallBottomBopper.scrollFactor.set(0.9, 0.9);
	mallBottomBopper.scale.set(0.9, 0.9);
	mallBottomBopper.updateHitbox();
	mallBottomBopper.shader = shader;
	insert(members.indexOf(gfGroup), mallBottomBopper);
	
	
	var snowLayer = new BGSprite("stages/christmas/fgSnow", -1350, 680);
	snowLayer.scale.set(1.1, 1);
	snowLayer.updateHitbox();
	insert(members.indexOf(gfGroup), snowLayer);
	
	var snowFloor = new FlxSprite(-1500, 800).makeGraphic(1,1,0xFFF3F4F5);
	snowFloor.scale.set(5700, 3000);
	snowFloor.updateHitbox();
	insert(members.indexOf(gfGroup), snowFloor);
	
	var santa = new BGSprite("stages/christmas/santa", -840, 100, 1, 1, ["santa idle in fear"]);
	santa.updateHitbox();
	add(santa);
	// for cutscene
	setVar("satan", santa);
	bopperShit = () -> {
		mallBottomBopper.anim.play("idle", true);
		mallUpperBopper.dance(true);
		santa.dance(true);
	};
	santa.shader = shader;
	bopperShit();
	
	game.startHScriptsNamed("stages/props/SnowEmitter");
	game.callOnHScript("setSnowEmitterPosition", [-726, -100]);
	game.callOnHScript("setSnowEmitterSize", [FlxG.width * 3, FlxG.height * 1.5]);
}
function onCreatePost(){
	if (!ClientPrefs.data.shaders) return;
	for (i in [boyfriend, dad, gf]){
		var sh = new AdjustColorShader();
		sh.hue = 15;
		sh.saturation = 20;
		i.shader = sh;
	}
}
function onBeatHit(){
	bopperShit();
}
function onCountdownTick(){
	bopperShit();
}