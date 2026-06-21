var cameraTween:FlxTween;

function onCreate()
{
	if (game.isErect)
		game.opponentCameraOffset = [-50, 0];
}

function onSongStart()
{
	if (game.isErect)
		game.camZooming = true;
}

function opponentNoteHit(note:Note)
{
	if (game.isErect)
		return;

	game.camZooming = false;
}

function onMoveCamera(focus:String)
{
	if (game.isErect) 
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
