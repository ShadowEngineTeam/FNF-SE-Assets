


var snewBehind:FlxSpriteGroup;
var snewFront:FlxSpriteGroup;
var snowWidth:Float = FlxG.width;
var snowHeight:Float = FlxG.height;
var timePerSnew:Float = 0.05;
var timer:Float = 0;
var graphic = Paths.image("stages/philly/particle");
function onCreate() {
	snewBehind = new FlxSpriteGroup();
	insert(members.indexOf(gfGroup), snewBehind);
	
	snewFront = new FlxSpriteGroup();
	add(snewFront);
}
function onUpdate(e){
	timer += e;
	if (timer > timePerSnew){
		createSnewParticle();
		timer -= timePerSnew;

	}
	snewBehind.forEachAlive(function(f:FlxSprite){
		if (f.y > snewBehind.y + snowHeight){
			f.kill();
			snewBehind.remove(f);
		}
	});
	snewFront.forEachAlive(function(f:FlxSprite){
		if (f.y > snewFront.y + snowHeight){
			f.kill();
			snewFront.remove(f);
		}
	});
}
function createSnewParticle(){
	var particle = new FlxSprite().loadGraphic(graphic);
	particle.x = FlxG.random.int(0, snowWidth);
	particle.y = snewFront.y;
	particle.scale.x = particle.scale.y = FlxG.random.float(0.5, 2);
	particle.acceleration.y = FlxG.random.int(200, 400);
	particle.velocity.set(FlxG.random.int(-150, 150), FlxG.random.int(100, 200));
	particle.active = true;
	particle.color = 0xFFF3F4F5;
	if (FlxG.random.bool()) snewBehind.add(particle);
	else snewFront.add(particle);
}
function getSnowEmitter() {
	return {front: snewFront, behind: snewBehind};
}
function setSnowEmitterPosition(?x:Int = 0, ?y:Int = 0) {
	snewFront.x = snewBehind.x = x;
	snewFront.y = snewBehind.y = y;
	return getSnowEmitter();
}
function setSnowEmitterSize(?x:Int = 1280, ?y:Int = 720) {
	snowWidth = x;
	snowHeight = y;
	return getSnowEmitter();
}