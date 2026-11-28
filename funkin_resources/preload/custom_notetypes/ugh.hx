function opponentNoteHit(n)
	if (n.noteType == "ugh" && !game.characterPlayingAsDad)
	{
		dad.playAnim("ugh");
		dad.specialAnim = true;
	}

function goodNoteHit(n)
	if (n.noteType == "ugh" && game.characterPlayingAsDad)
	{
		dad.playAnim("ugh");
		dad.specialAnim = true;
	}
