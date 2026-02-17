import backend.Difficulty;

var cameraTween:FlxTween;

function onCreate()
{
	if (Difficulty.getString().toLowerCase() == "erect" || Difficulty.getString().toLowerCase() == "nightmare")
		game.opponentCameraOffset = [-50, 0];
}

function opponentNoteHit(note:Note)
{
	if (Difficulty.getString().toLowerCase() == "erect" || Difficulty.getString().toLowerCase() == "nightmare")
		return;

	game.camZooming = false;
}

function onMoveCamera(focus:String)
{
	if (Difficulty.getString().toLowerCase() == "erect" || Difficulty.getString().toLowerCase() == "nightmare")
		return;

	if (focus == 'boyfriend')
	{
		if (cameraTween == null && FlxG.camera.zoom != 1)
		{
			cameraTween = FlxTween.tween(FlxG.camera, {zoom: 1}, (Conductor.stepCrochet * 4 / 1000), {
				ease: FlxEase.elasticInOut,
				onComplete: function(tween:FlxTween)
				{
					cameraTween = null;
				}
			});
		}
	}
	else
	{
		if (cameraTween == null && FlxG.camera.zoom != 1.3)
		{
			cameraTween = FlxTween.tween(FlxG.camera, {zoom: 1.3}, (Conductor.stepCrochet * 4 / 1000), {
				ease: FlxEase.elasticInOut,
				onComplete: function(tween:FlxTween)
				{
					cameraTween = null;
				}
			});
		}
	}
}