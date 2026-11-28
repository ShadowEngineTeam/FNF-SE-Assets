import objects.Subtitles;

// j-hope's Hangul, above the English
var hangul:Subtitles;

function onCreatePost()
{
	var main = game.subtitles;
	if (main == null)
		return;

	var top:Bool = main.alignment == 'top';
	hangul = new Subtitles(0, top ? 89 : 189, main.alignment, Paths.font('NotoSansKR-Bold.otf'));
	hangul.cameras = [game.camOther];
	add(hangul);
}

function onSongStart()
{
	if (hangul != null)
		hangul.assignSubtitles('spaghetti/subtitles/song-lyrics-hangul', FlxG.sound.music);
}

function onEndSong()
{
	// The results music plays on FlxG.sound.music too
	if (hangul != null)
		hangul.assignSubtitles(null, null);
}

// The stage's intro cutscene, which has Japanese and Korean lines too
function onSpaghettiCutscene(sound)
{
	if (hangul != null)
		hangul.assignSubtitles('spaghetti/subtitles/start-cutscene-original', sound);
}
