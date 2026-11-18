// Nene raises her knife when the player is low on health, and her hair blows while a train passes.
// Shared by every Nene, like Funkin's NeneBaseCharacter and NenePixelCharacter.

var STATE_DEFAULT:Int = 0;
var STATE_PRE_RAISE:Int = 1;
var STATE_RAISE:Int = 2;
var STATE_READY:Int = 3;
var STATE_LOWER:Int = 4;
var STATE_HAIR_BLOWING:Int = 5;
var STATE_HAIR_FALLING:Int = 6;
var STATE_HAIR_BLOWING_RAISE:Int = 7;
var STATE_HAIR_FALLING_RAISE:Int = 8;

var VULTURE_THRESHOLD:Float = 0.25 * 2;
var MIN_BLINK_DELAY:Int = 3;
var MAX_BLINK_DELAY:Int = 7;

var currentState:Int = STATE_DEFAULT;
var blinkCountdown:Int = MIN_BLINK_DELAY;
var trainPassing:Bool = false;
var animationFinished:Bool = false;
var lastAnim:String = '';
var lastFrame:Int = -1;
var wasFinished:Bool = false;
var pixel:Bool = false;

// Called by stages, as Funkin sets trainPassing on Nene.
function setTrainPassing(value:Bool)
{
	trainPassing = value;
}

// Otis loads Nene's scripts for his A-Bot, but has no knife.
function isNene():Bool
{
	return game.gf != null && StringTools.startsWith(game.gf.curCharacter, 'nene');
}

function isNeneState():Bool
{
	return currentState != STATE_DEFAULT;
}

function playNeneAnim(name:String)
{
	game.gf.playAnim(name, true);
	lastAnim = name;
	lastFrame = -1;
	wasFinished = false;
	animationFinished = false;
}

function onBeatHit()
{
	var gf = game.gf;
	if (!isNene() || curBeat % Math.round(game.gfSpeed * gf.danceEveryNumBeats) != 0)
		return;

	if (currentState == STATE_PRE_RAISE)
	{
		if (gf.getAnimationName() != 'danceLeft' || gf.isAnimationFinished())
		{
			gf.playAnim('danceLeft');
			lastAnim = 'danceLeft';
			lastFrame = -1;
			wasFinished = false;
			animationFinished = false;
		}
		gf.danced = true;
	}
	else if (currentState == STATE_READY)
	{
		if (blinkCountdown == 0)
		{
			playNeneAnim(pixel ? 'idleKnifeBlink' : 'idleKnife');
			blinkCountdown = FlxG.random.int(MIN_BLINK_DELAY, MAX_BLINK_DELAY);
		}
		else
			blinkCountdown--;
	}
	else if (currentState == STATE_LOWER && !pixel && gf.getAnimationName() != 'lowerKnife')
		playNeneAnim('lowerKnife');
}

function onUpdatePost(elapsed:Float)
{
	var gf = game.gf;
	if (!isNene() || gf.isAnimationNull() || game.boyfriend?.curCharacter == 'pico-blazin')
		return;

	pixel = gf.curCharacter == 'nene-pixel';
	var name:String = gf.getAnimationName();
	// Something else played an animation (a Hey! event, a combo reaction): follow it, so its end
	// counts like Funkin's onAnimationFinished and the state can pick its animation back up.
	if (name != lastAnim)
	{
		lastAnim = name;
		lastFrame = -1;
		wasFinished = false;
	}
	if (name == lastAnim)
	{
		// Only the frame it gets there, like Funkin's animation callbacks.
		var finished:Bool = gf.isAnimationFinished();
		if (currentState == STATE_PRE_RAISE && name == 'danceLeft' && lastFrame < 13 && gf.anim.curAnim.curFrame >= 13)
			animationFinished = true;
		else if (finished && !wasFinished)
			animationFinished = true;
		lastFrame = gf.anim.curAnim.curFrame;
		wasFinished = finished;
	}

	transitionState();

	gf.skipDance = isNeneState();
}

function checkTrainPassing(raised:Bool)
{
	if (!trainPassing || pixel)
		return;

	currentState = raised ? STATE_HAIR_BLOWING_RAISE : STATE_HAIR_BLOWING;
	playNeneAnim(raised ? 'hairBlowKnife' : 'hairBlow');
}

function transitionState()
{
	var health:Float = game.health;
	switch (currentState)
	{
		case STATE_DEFAULT:
			if (health <= VULTURE_THRESHOLD)
			{
				currentState = STATE_PRE_RAISE;
				lastAnim = game.gf.getAnimationName();
				lastFrame = game.gf.anim.curAnim.curFrame;
				wasFinished = game.gf.isAnimationFinished();
				animationFinished = false;
			}
			checkTrainPassing(false);
		case STATE_PRE_RAISE:
			if (health > VULTURE_THRESHOLD)
				currentState = STATE_DEFAULT;
			else if (animationFinished && lastAnim == 'danceLeft')
			{
				currentState = STATE_RAISE;
				playNeneAnim('raiseKnife');
			}
			checkTrainPassing(false);
		case STATE_RAISE:
			if (animationFinished)
			{
				currentState = STATE_READY;
				animationFinished = false;
			}
			checkTrainPassing(true);
		case STATE_READY:
			if (health > VULTURE_THRESHOLD)
			{
				currentState = STATE_LOWER;
				if (pixel)
					playNeneAnim('lowerKnife');
			}
			else if (pixel && animationFinished)
				playNeneAnim('idleKnife');
			checkTrainPassing(true);
		case STATE_LOWER:
			if (animationFinished && lastAnim == 'lowerKnife')
			{
				currentState = STATE_DEFAULT;
				animationFinished = false;
			}
			checkTrainPassing(false);
		case STATE_HAIR_BLOWING:
			if (!trainPassing)
			{
				currentState = STATE_HAIR_FALLING;
				playNeneAnim('hairFall');
			}
			else if (animationFinished)
				playNeneAnim('hairBlow');
		case STATE_HAIR_FALLING:
			if (animationFinished)
			{
				currentState = STATE_DEFAULT;
				animationFinished = false;
			}
		case STATE_HAIR_BLOWING_RAISE:
			if (!trainPassing)
			{
				currentState = STATE_HAIR_FALLING_RAISE;
				playNeneAnim('hairFallKnife');
			}
			else if (animationFinished)
				playNeneAnim('hairBlowKnife');
		case STATE_HAIR_FALLING_RAISE:
			if (animationFinished)
			{
				currentState = STATE_READY;
				animationFinished = false;
			}
		default:
			currentState = STATE_DEFAULT;
	}
}
