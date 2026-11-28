import flixel.addons.effects.FlxTrail;
var trail;
function onCreatePost() {
	trail = new FlxTrail(dad, null, 4, 0.4, 0.3, 0.069);
	insert(game.members.indexOf(dadGroup), trail);
}