import backend.Difficulty;

var isErect:Bool = Difficulty.getString().toLowerCase() == "erect" || Difficulty.getString().toLowerCase() == "nightmare";

function onCreate()
{
	if (isErect)
	{
		game.dad.x = 0;
		game.opponentCameraOffset = [-150, 0];
	}
}