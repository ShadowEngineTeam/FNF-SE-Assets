// only change the icon
function onEvent(n, v1, v2)
{
	if (n != "SetHealthIcon")
		return;

	if (v1 == "dad" || v1 == "opponent" || v1 == "1") 
	{
		game.iconP2.changeIcon(v2);
		game.iconP2.visible = true;
	}
	else
	{
		game.iconP1.changeIcon(v2);
		game.iconP1.visible = true;
	}
}
