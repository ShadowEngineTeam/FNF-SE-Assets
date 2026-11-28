var muzzleFlash:FlxSprite;
function onCreate() {
	// I'm good thank your
	game.startHScriptsNamed("characters/nene-tankmen");
	muzzleFlash = new FlxSprite();
	muzzleFlash.frames = Paths.getSparrowAtlas("characters/otis/muzzle-flashes/otis_flashes");
	muzzleFlash.animation.addByPrefix('shoot1', 'shoot back0', 24, false);
	muzzleFlash.animation.addByPrefix('shoot2', 'shoot back low0', 24, false);
	muzzleFlash.animation.addByPrefix('shoot3', 'shoot forward0', 24, false);
	muzzleFlash.animation.addByPrefix('shoot4', 'shoot forward low0', 24, false);
	insert(members.indexOf(gfGroup) + 1, muzzleFlash);
	muzzleFlash.animation.onFrameChange.add(function() {
		updateMuzzle();
	});
}
function updateMuzzle() {
	if (muzzleFlash.animation.curAnim.curFrame > 1)
		muzzleFlash.blend = 10;
	muzzleFlash.visible = !muzzleFlash.animation.curAnim.finished;
}
function onShooting(direction: Int) {
	if (gf == null) return;
	muzzleFlash.blend = 0;
	switch (direction) {
		case 0:
			muzzleFlash.setPosition(gf.x + 950, gf.y);
			muzzleFlash.animation.play('shoot1', true);
		case 1:
			muzzleFlash.setPosition(gf.x + 950, gf.y - 50);
			muzzleFlash.animation.play('shoot2', true);
		case 2:
			muzzleFlash.setPosition(gf.x - 350, gf.y - 50);
			muzzleFlash.animation.play('shoot3', true);
		case 3:
			muzzleFlash.setPosition(gf.x - 350, gf.y - 100);
			muzzleFlash.animation.play('shoot4', true);
	}
	// sorry, I'm too lazy
	muzzleFlash.x -= 300;
}