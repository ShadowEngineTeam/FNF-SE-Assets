import backend.Difficulty;

var cameraTween:FlxTween;
var isErect:Bool = Difficulty.getString().toLowerCase() == "erect" || Difficulty.getString().toLowerCase() == "nightmare";

function onCreate()
{
	if (isErect)
		game.opponentCameraOffset = [-50, 0];
}

function opponentNoteHit(note:Note)
{
	if (isErect)
		return;

	game.camZooming = false;
}

function onMoveCamera(focus:String)
{
	if (isErect)
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