import objects.BGSprite;
function onCreate(){
	var wallBackground = new FlxSprite(-500, -1000).makeGraphic(1, 1, 0xFF23062D);
	wallBackground.scale.set(2400, 2000);
	wallBackground.updateHitbox();
	insert(members.indexOf(gfGroup), wallBackground);
	
	var mallBG = new BGSprite("stages/christmas/evilBG", -400, -500, 0.2, 0.2);
	mallBG.scale.set(0.8, 0.8);
	mallBG.updateHitbox();
	insert(members.indexOf(gfGroup), mallBG);
	
	var mallTree = new BGSprite("stages/christmas/evilTree", 300, -300, 0.2, 0.2);
	insert(members.indexOf(gfGroup), mallTree);
	
	var mallSnow = new BGSprite("stages/christmas/evilSnow", -500, 700);
	insert(members.indexOf(gfGroup), mallSnow);
}