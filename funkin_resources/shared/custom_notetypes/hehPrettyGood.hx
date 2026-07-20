function opponentNoteHit(n)
	if (n.noteType == "hehPrettyGood" && !game.characterPlayingAsDad)
	{
		dad.playAnim("hehPrettyGood");
		dad.specialAnim = true;
	}

function goodNoteHit(n)
	if (n.noteType == "hehPrettyGood" && game.characterPlayingAsDad)
	{
		dad.playAnim("hehPrettyGood");
		dad.specialAnim = true;
	}
