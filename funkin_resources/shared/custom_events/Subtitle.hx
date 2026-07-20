var subtileBG:FlxSprite;
var subtileText:FlxText;

function onCreate()
{
	subtileBG = new FlxSprite(0, 500).makeGraphic(1, 30, FlxColor.BLACK);
	subtileBG.cameras = [camOther];
	subtileBG.alpha = 0.3;
	subtileBG.screenCenter(0x01);
	add(subtileBG);

	subtileText = new FlxText(0, 500);
	subtileText.setFormat(Paths.font("vcr.ttf"), 30, FlxColor.WHITE, "center");
	subtileText.cameras = [camOther];
	subtileText.screenCenter(0x01);
	add(subtileText);
	subtileText.visible = false;
}

function onEvent(n:String, v1:String, v2:String)
{
	if (n == "Subtitle")
	{
		subtileText.text = Std.string(v1);
		subtileBG.scale.x = subtileText.width + 30;

		subtileBG.screenCenter(0x01);
		subtileText.screenCenter(0x01);

		subtileText.visible = subtileBG.visible = true;
		if (v2 != "" && Std.parseFloat(v2) != null)
		{
			new FlxTimer().start(Std.parseFloat(v2), function()
			{
				subtileText.visible = subtileBG.visible = false;
			});
		}
	}
}
