var bloodMyAss:Bool = false;
function onEvent(n,v1)
	if (n == "Play Animation" && v1 == "redheadsAnim") {
		bloodMyAss = true;
		dad.idleSuffix = "-bloody";
	}
function opponentNoteHitPre(n) if (bloodMyAss && !game.characterPlayingAsDad) n.animSuffix = "-bloody";
function goodNoteHitPre(n) if (bloodMyAss && game.characterPlayingAsDad) n.animSuffix = "-bloody";