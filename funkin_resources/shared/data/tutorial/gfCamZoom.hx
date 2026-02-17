var cameraTween:FlxTween;

function opponentNoteHit(note:Note)
{
	game.camZooming = false;
}

function onMoveCamera(focus:String)
{
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