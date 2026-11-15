import objects.BGSprite;
import flixel.math.FlxAngle;
import flixel.addons.display.FlxBackdrop;

var tankRolling:BGSprite;
var bopDance:Void;
function onCreate(){
	var bg = new FlxSprite(-500, -1000).makeGraphic(1,1, 0xFFE3A26D);
	bg.scale.set(2400, 2000);
	bg.scrollFactor.set();
	bg.updateHitbox();
	insert(members.indexOf(gfGroup), bg);
	
	var tankSky = new BGSprite("stages/tankmanBattlefield/tankSky", -1000, -400, 0, 0);
	tankSky.scale.set(3000, 1);
	tankSky.updateHitbox();
	insert(members.indexOf(gfGroup), tankSky);
	
	var tankMountains = new BGSprite("stages/tankmanBattlefield/tankMountains", -500, -35, 0.2, 0.2);
	tankMountains.scale.set(1.2,1.2);
	tankMountains.updateHitbox();
	insert(members.indexOf(gfGroup), tankMountains);
	
	var tankClouds = new FlxBackdrop(Paths.image("stages/tankmanBattlefield/tankClouds"), 0x01);
	tankClouds.setPosition(-1100, 20);
	tankClouds.scrollFactor.set(0.25, 0.25);
	tankClouds.velocity.x = 8;
	insert(members.indexOf(gfGroup), tankClouds);
	
	var tankBuildings = new BGSprite("stages/tankmanBattlefield/tankBuildings", -260, -35, 0.3, 0.3);
	tankBuildings.scale.set(1.1,1.1);
	tankBuildings.updateHitbox();
	insert(members.indexOf(gfGroup), tankBuildings);
	
	var tankRuins = new BGSprite("stages/tankmanBattlefield/tankRuins", -200, -100, 0.35, 0.35);
	tankRuins.scale.set(1.1,1.1);
	tankRuins.updateHitbox();
	insert(members.indexOf(gfGroup), tankRuins);
	
	var smokeLeft = new BGSprite("stages/tankmanBattlefield/smokeLeft", -380,-40, 0.4, 0.4, ["SmokeBlurLeft"], true);
	insert(members.indexOf(gfGroup), smokeLeft);
	
	var smokeRight = new BGSprite("stages/tankmanBattlefield/smokeRight", 1050,-35, 0.4, 0.4, ["SmokeRight"], true);
	insert(members.indexOf(gfGroup), smokeRight);
	
	var watcher = new BGSprite("stages/tankmanBattlefield/tankWatchtower", -35, 110, 0.5, 0.5, ["watchtower gradient color"]);
	watcher.scale.set(0.85,0.85);
	watcher.updateHitbox();
	insert(members.indexOf(gfGroup), watcher);
	
	tankRolling = new BGSprite("stages/tankmanBattlefield/tankRolling", 300,300, 0.5, 0.5, ["BG tank w lighting"], true);
	insert(members.indexOf(gfGroup), tankRolling);
	
	var tankGround = new BGSprite("stages/tankmanBattlefield/tankGround", -420,-150);
	tankGround.scale.set(1.15, 1.15);
	tankGround.updateHitbox();
	insert(members.indexOf(gfGroup), tankGround);
	
	game.startHScriptsNamed("stages/props/tankmenStress");
	
	var tank0 = new BGSprite("stages/tankmanBattlefield/tank0", -500, 650, 1.7, 1.5, ["fg tankhead far right instance 1"]);
	add(tank0);
	
	var tank2 = new BGSprite("stages/tankmanBattlefield/tank2", 360, 980, 1.5, 1.5, ["foreground man 3 instance 1"]);
	add(tank2);
	
	var tank5 = new BGSprite("stages/tankmanBattlefield/tank5", 1550, 700, 1.5, 1.5, ["fg tankhead far right instance 1"]);
	add(tank5);
	
	var tank4 = new BGSprite("stages/tankmanBattlefield/tank4", 1200, 900, 1.5, 1.5, ["fg tankman bobbin 3 instance 1"]);
	add(tank4);
	
	var tank3 = new BGSprite("stages/tankmanBattlefield/tank3", 1050, 1240, 3.5, 2.5, ["fg tankhead 4 instance 1"]);
	add(tank3);
	
	var tank1 = new BGSprite("stages/tankmanBattlefield/tank1", -300, 750, 2, 0.2, ["fg tankhead 5 instance 1"]);
	add(tank1);
	
	bopDance = function() {
		tank0.dance(true);
		tank1.dance(true);
		tank2.dance(true);
		tank4.dance(true);
		tank3.dance(true);
		tank5.dance(true);
		watcher.dance(true);
	}
	moveTank();
	bopDance();
	
	var bricksGround = new BGSprite("stages/tankmanBattlefield/bricksGround", 438, 715);
	bricksGround.scale.set(1.15, 1.15);
	bricksGround.updateHitbox();
	insert(members.indexOf(gfGroup) + 1, bricksGround);
}
function onBeatHit() bopDance();
function onCountdownTick() bopDance();
function onCreatePost(){}
var tankSpeed:Float = FlxG.random.float(5, 7);
var tankX:Float = 400;
function onUpdate() {
	moveTank();
}
// The tank follows the song, so it starts over with it.
function getTankAngle():Float {
	return Conductor.songPosition / 1000 * tankSpeed;
}
function moveTank(){
	var daAngleOffset:Float = 1;
	var tankAngle:Float = getTankAngle();
	tankRolling.angle = tankAngle - 90 + 15;
	tankRolling.x = tankX + Math.cos(FlxAngle.asRadians((tankAngle * daAngleOffset) + 180)) * 1500;
	tankRolling.y = 1300 + Math.sin(FlxAngle.asRadians((tankAngle * daAngleOffset) + 180)) * 1100;
}