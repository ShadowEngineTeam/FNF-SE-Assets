import backend.HapticUtil;
import objects.BGSprite;
import shaders.RuntimePostEffectShader;
import flixel.addons.display.FlxBackdrop;
import flixel.math.FlxBasePoint;
var scrollingSky;
var light, lightning, forego, sky;
function onCreate(){
	scrollingSky = new FlxBackdrop(Paths.image("stages/phillyStreets/phillyBlazin/skyBlur"));
	insert(members.indexOf(gfGroup),scrollingSky);
	scrollingSky.setPosition(-600,-175);
	scrollingSky.scrollFactor.set();
	scrollingSky.scale.set(1.75,1.75);
	// FlxBackdrop floors each tile's position but sizes tiles by frameWidth * scale.x.
	// 1387 * 1.75 = 2427.25, so the fraction leaves a 1px seam at the tile boundary that
	// shows the dark background through and drifts left as the sky scrolls. Pad the
	// spacing until the scaled tile lands on a whole pixel.
	var skyTileW = scrollingSky.frameWidth * scrollingSky.scale.x;
	scrollingSky.spacing.set((Math.ceil(skyTileW) - skyTileW) / scrollingSky.scale.x, 0);
	
	sky = new BGSprite("stages/phillyStreets/phillyBlazin/skyBlur", -600, -175, 0,0);
	sky.scale.set(1.75,1.75);
	sky.updateHitbox();
	sky.blend = 0;
	sky.alpha = 0;
	insert(members.indexOf(gfGroup),sky);
	
	lightning = new BGSprite("stages/phillyStreets/phillyBlazin/lightning", 50, 0, 1,1, ["lightning"]);
	lightning.visible = false;
	lightning.scale.set(1.75,1.75);
	lightning.updateHitbox();
	insert(members.indexOf(gfGroup),lightning);
	
	var street = new BGSprite("stages/phillyStreets/phillyBlazin/streetBlur", -600, -175, 0,0);
	street.scale.set(1.75,1.75);
	street.updateHitbox();
	insert(members.indexOf(gfGroup),street);
	
	forego = new BGSprite("stages/phillyStreets/phillyBlazin/streetBlur", -600, -175, 0,0);
	forego.scale.set(1.75,1.75);
	forego.updateHitbox();
	forego.blend = 9;
	insert(members.indexOf(gfGroup),forego);
	forego.alpha = 0;
	
	light = new FlxSprite(-600, -175).makeGraphic(1,1);
	light.scale.set(2500, 2000);
	light.updateHitbox();
	light.blend = 0;
	light.scrollFactor.set();
	light.alpha = 0.001;
	insert(members.indexOf(gfGroup),light);
	
	game.startHScriptsNamed("stages/props/rainShader");
	game.characterPlayingAsDad = false;
}
function onCreatePost(){
	boyfriend.color = dad.color = 0xFFDEDEDE;
	gf.color = 0xFF888888;
	boyfriend.skipDance = dad.skipDance = true;
}
var lightningTimer = 3;
function onUpdatePost(elap){
	scrollingSky.x -= elap * 35;
	game.triggerEvent("Camera Follow Pos", game.gf.getMidpoint().x, game.gf.getMidpoint().y - 140);
	FlxG.camera.snapToTarget();
	lightningTimer -= FlxG.elapsed;
	if (lightningTimer <= 0 && !game.inCutscene)
	{
		applyLightning();
		lightningTimer = FlxG.random.float(7, 15);
	}
	// absolute, not -= : this runs every frame, so subtracting drifts them a further
	// 999px every tick instead of just parking them off-screen once
	for (i in opponentStrums)i.x = -999;
	for (i in 0...playerStrums.length){
		var stru = playerStrums.members[i];
		var startX = FlxG.width/2 - Note.swagWidth*(playerStrums.length/2);
		stru.x = startX + Note.swagWidth * i;
	}
}
function applyLightning(){
	sky.alpha = 0.7;
	// the bolt has to be hidden again once the flash is over, otherwise it just sits
	// there on its last frame for the rest of the song
	FlxTween.tween(sky, {alpha: 0.0}, 1.5, {onComplete: function(_) {
		lightning.visible = false;
	}});
	forego.alpha = 0.64;
	FlxTween.tween(forego, {alpha: 0.0}, 1.5);
	
	light.alpha = 0.3;
	FlxTween.tween(light, {alpha: 0.0}, 0.3);

	lightning.visible = true;
	lightning.dance();

	if (FlxG.random.bool(65))
		lightning.x = FlxG.random.int(-250, 280);
	else
		lightning.x = FlxG.random.int(780, 900);

	FlxTween.color(boyfriend, 0.3, 0xFF606060, 0xFFDEDEDE);
	FlxTween.color(dad, 0.3, 0xFF606060, 0xFFDEDEDE);

	FlxTween.color(gf, 0.3, 0xFF606060, 0xFF888888);
	FlxG.sound.play(Paths.sound("phillyStreets/Lightning" + FlxG.random.int(1,3)));
	triggerLightningHaptics();
}
// Darnell reacts first, then Pico, like Funkin's darnell-blazin and pico-blazin scripts
function goodNoteHit(note) noteHit(note);
function opponentNoteHit(note) noteHit(note);
var cantUppercut = false;
function noteHit(note){
	if (!StringTools.startsWith(note.noteType, "weekend-1-")) return;
	darnellNoteHit(note);
	picoNoteHit(note);
}
function darnellNoteHit(note) {
	if (wasNoteHitPoorly(note.rating) && isPlayerLowHealth() && FlxG.random.bool(30)) {
		playUppercutPrepAnim(dad);
		return;
	}
	switch (note.noteType) {
		case "weekend-1-punchlow":
			playHitLowAnim(dad);
		case "weekend-1-punchhigh":
			playHitHighAnim(dad);
		case "weekend-1-punchlowblocked", "weekend-1-punchhighblocked":
			playBlockAnim(dad);
		case "weekend-1-punchlowdodged", "weekend-1-punchhighdodged":
			playDodgeAnim(dad);
		case "weekend-1-punchlowspin", "weekend-1-punchhighspin":
			playSpinAnim(dad);
		case "weekend-1-blockhigh", "weekend-1-blockspin", "weekend-1-dodgehigh", "weekend-1-dodgespin", "weekend-1-hithigh", "weekend-1-hitspin":
			playPunchHighAnim(dad);
		case "weekend-1-blocklow", "weekend-1-dodgelow", "weekend-1-hitlow":
			playPunchLowAnim(dad);
		case "weekend-1-picouppercut":
			playUppercutHitAnim(dad);
		case "weekend-1-darnelluppercutprep":
			playUppercutPrepAnim(dad);
		case "weekend-1-darnelluppercut":
			playUppercutAnim(dad, true);
		case "weekend-1-idle":
			playIdleAnim(dad);
		case "weekend-1-fakeout":
			playCringeAnim(dad);
		case "weekend-1-taunt":
			playPissedConditionalAnim(dad);
		case "weekend-1-tauntforce":
			playPissedAnim(dad);
		case "weekend-1-reversefakeout":
			playFakeoutAnim(dad);
	}
}
function picoNoteHit(note) {
	if (wasNoteHitPoorly(note.rating) && isPlayerLowHealth() && isDarnellPreppingUppercut()) {
		playPunchHighAnim(boyfriend);
		return;
	}
	if (cantUppercut) {
		playBlockAnim(boyfriend);
		cantUppercut = false;
		return;
	}
	switch (note.noteType) {
		case "weekend-1-punchlow", "weekend-1-punchlowblocked", "weekend-1-punchlowdodged", "weekend-1-punchlowspin":
			playPunchLowAnim(boyfriend);
		case "weekend-1-punchhigh", "weekend-1-punchhighblocked", "weekend-1-punchhighdodged", "weekend-1-punchhighspin":
			playPunchHighAnim(boyfriend);
		case "weekend-1-blockhigh", "weekend-1-blocklow", "weekend-1-blockspin":
			playBlockAnim(boyfriend);
		case "weekend-1-dodgehigh", "weekend-1-dodgelow", "weekend-1-dodgespin":
			playDodgeAnim(boyfriend);
		case "weekend-1-hithigh":
			playHitHighAnim(boyfriend);
		case "weekend-1-hitlow":
			playHitLowAnim(boyfriend);
		case "weekend-1-hitspin":
			playSpinAnim(boyfriend);
		case "weekend-1-picouppercutprep":
			playUppercutPrepAnim(boyfriend);
		case "weekend-1-picouppercut":
			playUppercutAnim(boyfriend, true);
		case "weekend-1-darnelluppercutprep", "weekend-1-idle", "weekend-1-reversefakeout":
			playIdleAnim(boyfriend);
		case "weekend-1-darnelluppercut":
			playUppercutHitAnim(boyfriend);
		case "weekend-1-fakeout":
			playFakeoutAnim(boyfriend);
		case "weekend-1-taunt":
			playTauntConditionalAnim(boyfriend);
		case "weekend-1-tauntforce":
			playTauntAnim(boyfriend);
	}
}
function noteMiss(note) {
	if (!StringTools.startsWith(note.noteType, "weekend-1-")) return;
	darnellNoteMiss(note);
	picoNoteMiss(note);
}
function darnellNoteMiss(note) {
	if (isDarnellPreppingUppercut()) {
		playUppercutAnim(dad, true);
		return;
	}
	if (willMissBeLethal()) {
		playPunchLowAnim(dad);
		return;
	}
	switch (note.noteType) {
		case "weekend-1-punchlow", "weekend-1-punchlowblocked", "weekend-1-punchlowdodged", "weekend-1-punchlowspin", "weekend-1-blocklow", "weekend-1-dodgelow", "weekend-1-hitlow":
			playPunchLowAnim(dad);
		case "weekend-1-punchhigh", "weekend-1-punchhighblocked", "weekend-1-punchhighdodged", "weekend-1-punchhighspin", "weekend-1-blockhigh", "weekend-1-blockspin", "weekend-1-dodgehigh", "weekend-1-dodgespin", "weekend-1-hithigh", "weekend-1-hitspin":
			playPunchHighAnim(dad);
		case "weekend-1-picouppercutprep":
			playHitHighAnim(dad);
		case "weekend-1-picouppercut":
			playDodgeAnim(dad);
		case "weekend-1-darnelluppercutprep":
			playUppercutPrepAnim(dad);
		case "weekend-1-darnelluppercut":
			playUppercutAnim(dad, true);
		case "weekend-1-idle":
			playIdleAnim(dad);
		case "weekend-1-fakeout":
			playCringeAnim(dad);
		case "weekend-1-taunt":
			playPissedConditionalAnim(dad);
		case "weekend-1-tauntforce":
			playPissedAnim(dad);
		case "weekend-1-reversefakeout":
			playFakeoutAnim(dad);
	}
}
function picoNoteMiss(note) {
	if (isDarnellInUppercut()) {
		playUppercutHitAnim(boyfriend);
		return;
	}
	if (willMissBeLethal()) {
		playHitLowAnim(boyfriend);
		return;
	}
	if (cantUppercut) {
		playHitHighAnim(boyfriend);
		return;
	}
	switch (note.noteType) {
		case "weekend-1-punchlow", "weekend-1-punchlowblocked", "weekend-1-punchlowdodged", "weekend-1-blocklow", "weekend-1-dodgelow", "weekend-1-hitlow":
			playHitLowAnim(boyfriend);
		case "weekend-1-punchhigh", "weekend-1-punchhighblocked", "weekend-1-punchhighdodged", "weekend-1-blockhigh", "weekend-1-dodgehigh", "weekend-1-hithigh", "weekend-1-fakeout":
			playHitHighAnim(boyfriend);
		case "weekend-1-punchlowspin", "weekend-1-punchhighspin", "weekend-1-blockspin", "weekend-1-dodgespin", "weekend-1-hitspin":
			playSpinAnim(boyfriend);
		case "weekend-1-picouppercutprep":
			playPunchHighAnim(boyfriend);
			cantUppercut = true;
		case "weekend-1-picouppercut":
			playUppercutAnim(boyfriend, false);
		case "weekend-1-darnelluppercutprep", "weekend-1-idle", "weekend-1-reversefakeout":
			playIdleAnim(boyfriend);
		case "weekend-1-darnelluppercut":
			playUppercutHitAnim(boyfriend);
		case "weekend-1-taunt":
			playTauntConditionalAnim(boyfriend);
		case "weekend-1-tauntforce":
			playTauntAnim(boyfriend);
	}
}
function noteMissPress() {
	if (willMissBeLethal()) {
		playPunchLowAnim(dad);
		playHitLowAnim(boyfriend);
	} else {
		if (FlxG.random.bool()) playDodgeAnim(dad);
		else playBlockAnim(dad);
		playPunchHighAnim(boyfriend);
	}
}
var picoAlternate:Bool = false;
var darnellAlternate:Bool = false;
function doAlternate(char) {
	if (char == boyfriend) {
		picoAlternate = !picoAlternate;
		return picoAlternate ? '1' : '2';
	}
	darnellAlternate = !darnellAlternate;
	return darnellAlternate ? '1' : '2';
}
function curAnimName(char) {
	return char.anim.curAnim != null ? char.anim.curAnim.name : "";
}
function isDarnellPreppingUppercut() {
	return curAnimName(dad) == "uppercutPrep";
}
function isDarnellInUppercut() {
	return curAnimName(dad) == "uppercut" || curAnimName(dad) == "uppercut-hold";
}
// Front/back is about Pico's layer, so Darnell's front is Pico's back
function setLayer(char, front:Bool) {
	if ((char == boyfriend) == front) moveToFront();
	else moveToBack();
}
function playBlockAnim(char) {
	char.playAnim('block', true);
	FlxG.camera.shake(0.002, 0.1);
	setLayer(char, false);
}
function playCringeAnim(char) {
	char.playAnim('cringe', true);
	setLayer(char, false);
}
function playDodgeAnim(char) {
	char.playAnim('dodge', true);
	setLayer(char, false);
}
function playIdleAnim(char) {
	char.playAnim('idle');
	setLayer(char, false);
}
function playFakeoutAnim(char) {
	char.playAnim('fakeout', true);
	setLayer(char, false);
}
function playPissedConditionalAnim(char) {
	if (curAnimName(char) == "cringe") playPissedAnim(char);
	else playIdleAnim(char);
}
function playTauntConditionalAnim(char) {
	if (curAnimName(char) == "fakeout") playTauntAnim(char);
	else playIdleAnim(char);
}
function playPissedAnim(char) {
	char.playAnim('pissed', true);
	setLayer(char, false);
}
function playUppercutPrepAnim(char) {
	char.playAnim('uppercutPrep', true);
	setLayer(char, true);
}
function playUppercutAnim(char, hit:Bool) {
	char.playAnim('uppercut', true);
	if (hit && char == boyfriend) FlxG.camera.shake(0.005, 0.25);
	setLayer(char, true);
}
function playUppercutHitAnim(char) {
	char.playAnim('uppercutHit', true);
	if (char == boyfriend) FlxG.camera.shake(0.005, 0.25);
	setLayer(char, false);
}
function playHitHighAnim(char) {
	char.playAnim('hitHigh', true);
	FlxG.camera.shake(0.0025, 0.15);
	setLayer(char, false);
}
function playHitLowAnim(char) {
	char.playAnim('hitLow', true);
	FlxG.camera.shake(0.0025, 0.15);
	setLayer(char, false);
}
function playPunchHighAnim(char) {
	char.playAnim('punchHigh' + doAlternate(char), true);
	setLayer(char, true);
}
function playTauntAnim(char) {
	char.playAnim('taunt', true);
	setLayer(char, false);
}
function playPunchLowAnim(char) {
	char.playAnim('punchLow' + doAlternate(char), true);
	setLayer(char, true);
}
function playSpinAnim(char) {
	// Pico's spin plays reversed in Funkin
	char.playAnim('hitSpin', true, char == boyfriend);
	FlxG.camera.shake(0.0025, 0.15);
	setLayer(char, false);
}
function willMissBeLethal() {
	return game.health <= 0.0 && !game.practiceMode;
}
function wasNoteHitPoorly(rating) {
	return (rating == "bad" || rating == "shit");
}
function isPlayerLowHealth() {
	return game.health <= 0.3 * 2;
}
function moveToBack() {
	var dadPos = FlxG.state.members.indexOf(dadGroup);
	var bfPos = FlxG.state.members.indexOf(boyfriendGroup);
	if (dadPos < bfPos) return;
	FlxG.state.members[bfPos] = dadGroup;
	FlxG.state.members[dadPos] = boyfriendGroup;
}
function moveToFront() {
	var dadPos = FlxG.state.members.indexOf(dadGroup);
	var bfPos = FlxG.state.members.indexOf(boyfriendGroup);
	if (dadPos > bfPos) return;

	FlxG.state.members[bfPos] = dadGroup;
	FlxG.state.members[dadPos] = boyfriendGroup;
}

var doPostShockHaptics:Bool = false;
var postShockCounter:Int = 0;
var counterTargetNum:Int = 10;

function triggerLightningHaptics()
{
	HapticUtil.vibrate(0, 0.05, 1, 1);

	doPostShockHaptics = true;
}

function onStepHit()
{
	if (doPostShockHaptics)
	{
		postShockCounter++;

		var postShockAmplitude:Float = 0.05 * (counterTargetNum - postShockCounter) * 2.5;
		HapticUtil.vibrate(0, 0.01, postShockAmplitude, 0);

		if (postShockCounter == counterTargetNum)
		{
			doPostShockHaptics = false;
			postShockCounter = 0;
		}
	}
}
