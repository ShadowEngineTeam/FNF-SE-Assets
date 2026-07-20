import flixel.addons.effects.FlxSkewedSprite;
import flixel.FlxObject;
import flixel.math.FlxBasePoint;
var perspective = [];
function getData(tag){
	for (i in perspective)
		if (i[0] == tag)
			return i;
	return false;
}
function createPerspectiveSprite(tag, graphic) {
	var data = [tag, {sprite: null, top: null, bottom: null}];
	data[1].sprite = new FlxSkewedSprite().loadGraphic(Paths.image(graphic));
	data[1].sprite.matrixExposed = true;
	data[1].top = new FlxObject();
	data[1].bottom = new FlxObject();
	perspective.push(data);
	return data[1].sprite;
}
function setPerspectivePosition(tag, top, bottom){
	if (getData(tag) != false){
		var d = getData(tag);
		d[1].top.setPosition(top.x, top.y);
		d[1].bottom.setPosition(bottom.x, bottom.y);
	}
}
function setPerspectiveScrollFactor(tag, top, bottom){
	if (getData(tag) != false){
		var d = getData(tag);
		d[1].top.scrollFactor.set(top.x, top.y);
		d[1].bottom.scrollFactor.set(bottom.x,bottom.y);
	}
}
function updatePerspectiveView(){
	for (i in perspective){
		var sprite = i[1].sprite;
		var targetCam = sprite.camera;
		var bottom = i[1].bottom;
		var top = i[1].top;
		var correctedBottom = new FlxBasePoint(bottom.x + (targetCam.scroll.x * (sprite.scrollFactor.x - bottom.scrollFactor.x)), bottom.y + (targetCam.scroll.y * (sprite.scrollFactor.y - bottom.scrollFactor.y)));
		var correctedTop = new FlxBasePoint(top.x + (targetCam.scroll.x * (sprite.scrollFactor.x - top.scrollFactor.x)), top.y + (targetCam.scroll.y * (sprite.scrollFactor.y - top.scrollFactor.y)));
		var distX = correctedTop.x - correctedBottom.x;
		var distY = correctedTop.y - (correctedBottom.y - sprite.height);
		sprite.transformMatrix.a = 1;
		sprite.transformMatrix.b = 0;
		sprite.transformMatrix.c = -(distX / sprite.height);
		sprite.transformMatrix.d = 1 - (distY / sprite.height);
		sprite.transformMatrix.tx = distX / 2;
		sprite.transformMatrix.ty = distY / 2;
		sprite.x = correctedBottom.x - sprite.width / 2;
		sprite.y = correctedBottom.y - sprite.height;
	}
}