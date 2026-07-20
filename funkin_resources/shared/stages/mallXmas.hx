import objects.BGSprite;

var bopperShit;
function onCreate() {
	var mallWall = new BGSprite("stages/christmas/bgWalls", -726, -566, 0.2, 0.2);
	mallWall.scale.set(0.8, 0.8);
	mallWall.updateHitbox();
	insert(members.indexOf(gfGroup), mallWall);
	
	var mallUpperBopper = new BGSprite("stages/christmas/upperBop", -396, -98, 0.28, 0.28, ["Upper Crowd Bob"]);
	mallUpperBopper.scale.set(0.85, 0.85);
	mallUpperBopper.updateHitbox();
	insert(members.indexOf(gfGroup), mallUpperBopper);
	
	var mallEscalator = new BGSprite("stages/christmas/bgEscalator", -1100, -540, 0.3, 0.3);
	mallEscalator.scale.set(0.9, 0.9);
	mallEscalator.updateHitbox();
	insert(members.indexOf(gfGroup), mallEscalator);
	
	var mallTree = new BGSprite("stages/christmas/christmasTree", 370, -250, 0.4, 0.4);
	insert(members.indexOf(gfGroup), mallTree);
	
	var mallBottomBopper = new BGSprite("stages/christmas/bottomBop", -300, 120,0.9,0.9,["Bottom Level Boppers"]);
	insert(members.indexOf(gfGroup), mallBottomBopper);
	
	
	var snowLayer = new BGSprite("stages/christmas/fgSnow", -1150, 680);
	insert(members.indexOf(gfGroup), snowLayer);
	
	var snowFloor = new FlxSprite(-1200, 800).makeGraphic(1,1,0xFFF3F4F5);
	snowFloor.scale.set(5400, 3000);
	snowFloor.updateHitbox();
	insert(members.indexOf(gfGroup), snowFloor);
	
	var santa = new BGSprite("stages/christmas/santa", -840, 150, 1, 1, ["santa idle in fear"]);
	santa.updateHitbox();
	add(santa);
	setVar("satan", santa);
	bopperShit = () -> {
		mallBottomBopper.dance(true);
		mallUpperBopper.dance(true);
		santa.dance(true);
	};
	
	bopperShit();
	
	game.startHScriptsNamed("stages/props/SnowEmitter");
	game.callOnHScript("setSnowEmitterPosition", [-1100, -100]);
	game.callOnHScript("setSnowEmitterSize", [FlxG.width * 3.5, FlxG.height * 1.5]);
	
}
function onBeatHit(){
	bopperShit();
}
function onCountdownTick(){
	bopperShit();
}