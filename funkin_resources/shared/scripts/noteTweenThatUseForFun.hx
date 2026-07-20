
import psychlua.LuaUtils;
function onUpdatePost(e) {
	game.notes.forEachAlive(function(note:Note) {
		var strum = note.mustPress ? playerStrums: opponentStrums;
		if (strum.length == 0) return;
		strum = strum.members[note.noteData];
		if (strum == null) return;
		var pixel = PlayState.daPixelZoom;
		var time = Math.max(0, Conductor.songPosition - (note.strumTime - 2000)) / 2000;

		var dir = strum.direction * Math.PI/180;
		var ease = FlxEase.linear;
		if (time >= 1) ease = FlxEase.linear;
		time = ease(time);
		var distance = FlxMath.lerp(-2000, 0, time);
		distance *= 0.45 * (game.songSpeed / game.playbackRate) * note.multSpeed;
		if (!strum.downScroll) distance *= -1;
		note.copyY = false;
		note.copyX = false;
		note.copyAlpha = false;
		note.x = strum.x + note.offsetX + Math.cos(dir) * distance;
		note.y = strum.y + note.offsetY + note.correctionOffset + Math.sin(dir) * distance;
		if (strum.downScroll && note.isSustainNote) {
			if (PlayState.isPixelStage.priorityBool(note.usePixelTextures)) {
				note.y -= (pixel / 6) * 9.5;
			}
			note.y -= (note.frameHeight * note.scale.y) - (Note.swagWidth / 2);
		}
	});
}