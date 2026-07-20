import haxe.Json;
import flixel.effects.FlxFlicker;
import backend.Difficulty;
import objects.BGSprite;
import flixel.math.FlxAngle;
import backend.Song;

var tankmonArrau = [];
var animationNotes = [];
var littank = [];
var tankmonGroup:FlxSpriteGroup;
var isErect = PlayState.curStage == "tankmanBattlefieldErect";
function onCreate() {
	tankmonGroup = new FlxSpriteGroup();
	insert(members.indexOf(gfGroup), tankmonGroup);
	
	var path = PlayState.SONG.song;
	if (PlayState.SONG.variant != null && PlayState.SONG.variant != "") path += "/" + PlayState.SONG.variant;
	if (!Paths.fileExists("data/" + path + "/picospeaker.json")) return;
	var js = Song.loadFromJson("picospeaker" + Difficulty.getSongPrefix(null, true), path);
	for (i in js.notes) {
		for (b in i.sectionNotes) {
			animationNotes.push(b);
		if (FlxG.random.bool(1 / 16 * 100)) littank.push({time: b[0], flip: (b[1] == 2 || b[1] == 3) ? true : false, speed: FlxG.random.float(0.6, 1), end: FlxG.random.float(50, 200)});
		}
	}
}
var beenUpdate = false;
function onUpdate(){
	if (animationNotes.length > 0) {
		if (Conductor.songPosition >= animationNotes[0][0]) {
			if (gf != null) {
				gf.playAnim("shoot" + (animationNotes[0][1] + 1), true);
				gf.specialAnim = true;
			}
			game.callOnScripts("onShooting", [animationNotes[0][1]]);
			animationNotes.shift();
			
		}
	}
	if (tankmonGroup.length > 0){
		for (i in tankmonGroup){
			if (tankmonArrau[i.ID].id == 1) {
				if (i.animation.curAnim.name == "run") {
					if (Conductor.songPosition > tankmonArrau[i.ID].time){ 
						i.animation.play("shot");
						i.offset.y = 200;
						i.offset.x = 300;
					}
					var runFactor = ((Conductor.songPosition - tankmonArrau[i.ID].time) * tankmonArrau[i.ID].speed);
					i.x = i.flipX ? ((FlxG.width * 0.02 - tankmonArrau[i.ID].ending) + runFactor) : ((FlxG.width * 0.74 + tankmonArrau[i.ID].ending) - runFactor);
				}
				if (i.animation.curAnim.name == "shot" && i.animation.curAnim.curFrame >= 10) {
					tankmonArrau[i.ID].id = 0;
					FlxFlicker.flicker(i, 0.3, 1 / 10, true, true, function(_) {
						FlxFlicker.flicker(i, 0.3, 1 / 20, false, true, function(_) {
							i.kill();
						});
					});
				}
			}
		}
	}
	var cutoff:Float = Conductor.songPosition + (1000 * 3);
	if (littank.length == 0) return;
	for (i in littank) {
		if (i.time < cutoff) {
			var yPos = isErect ? 325 : (200 + FlxG.random.int(50, 100));
			createTank(yPos, i);
			littank.remove(i);
		}
	}
}
var ID = 0;
function createTank(y,data){
	var yankmon = new BGSprite("stages/tankmanBattlefield/tankmanKilled1", 9999, y, 1, 1, [""]);
	yankmon.animation.addByPrefix('run', 'tankman running', 24, true);
	yankmon.animation.addByPrefix('shot', 'John Shot ' + FlxG.random.int(1, 2), 24, false);
	yankmon.animation.play("run");
	yankmon.offset.set();
	yankmon.flipX = data.flip;
	if (isErect) {
		yankmon.scale.set(1.1, 1.1);
		updateCharacterShader(yankmon);
	}
	yankmon.ID = ID;
	tankmonGroup.add(yankmon);
	ID += 1;
	tankmonArrau.push({id: 1, time: data.time, speed: data.speed, ending: data.end});
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
	shader.setFloat("ang", 135 * FlxAngle.TO_RAD);
	shader.setFloat("thr", 0.1);
	shader.setFloat("thr2", 1);
	shader.setFloat("str", 1);
	if (char.isAnimate) char.useRenderTexture = true;
	char.animation.onFrameChange.add(function(){
		shader.setFloatArray("uFrameBounds", [char.frame.uv.left, char.frame.uv.top, char.frame.uv.right, char.frame.uv.bottom]);
		shader.setFloat("angOffset", char.frame.angle * FlxAngle.TO_RAD);
	});
	char.shader = shader;
}