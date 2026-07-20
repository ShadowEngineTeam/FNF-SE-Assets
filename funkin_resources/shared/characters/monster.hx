
function onCreatePost(){
	game.dad.anim.onFrameChange.add(function() {
		game.dad.timeline.forEachLayer((layer) -> {
			if (StringTools.contains(layer.name.toLowerCase(),"hat")) {
				layer.visible = false;
			}
		});
	});
}
function getFramesWithKeyword(char, keyword:String) {
	if (!char.anim.hasAnimateAtlas) {
		trace('WARNING: getFramesWithKeyword() only works on texture atlases!');
		return [];
	}
	var symbolItems = [];
	var frames = [];
	for (symbol in char.library.dictionary.keys()) {
		var symbolItem=char.library.getSymbol(symbol);
		if (symbolItem == null) continue;
		if (StringTools.contains(symbolItem.name, keyword)) {
			symbolItems.push(symbolItem);
		}
	}
	for (symbolItem in symbolItems) {
		symbolItem.timeline.forEachLayer((layer) -> {
			layer.forEachFrame((frame) -> {
				frames.push(frame);
			});
		});
	}
	return frames;
}