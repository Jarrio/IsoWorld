package state;

import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.tweens.FlxTween;
import openfl.Assets;
import openfl.display.BitmapData;
import openfl.display.Graphics;
import openfl.display.Sprite;

@:enum
abstract MouthFrame(Int) {
	var SMILE = 0;
	var FROWN = 1;
	var OOH = 2;
}
enum MouthExpression {
	SMILING;
	FROWNING;
	OOH;
	CLOSED;
}
class Test extends FlxSprite {
	
	public var tween(default, null):FlxTween;

	private var _currentExpression:MouthExpression;
	private var _scale:FlxPoint;
	
	public function new(x:Float, y:Float) {
		super(x, y);
		_scale = FlxPoint.get(1, 1);
		loadGraphic(AssetPaths.Mouths__png, true, 24, 12);
	
		solid = false;
		smile();
	}
	
	override public function update(elapsed:Float):Void {
		super.update(elapsed);
		multiplyScale();
	}
	
	private inline function multiplyScale() {
		scale.x *= _scale.x;
		scale.y *= _scale.y;
	}
	
	public function changeFrame(expression:MouthFrame) {
		animation.frameIndex = cast expression;
	}
	
	public function smile() {
		if (_currentExpression == SMILING) return;
		
		stopTween();
		changeFrame(SMILE);
		tweenScale(null, 1);
		_currentExpression = SMILING;
	}
	
	public function close() {
		if (_currentExpression == CLOSED) return;
		_currentExpression = CLOSED;
		stopTween();
		changeFrame(SMILE);
		
		tweenScale(1, 0.1);
	}
	
	public function frown() {
		if (_currentExpression == FROWNING) return;
		_currentExpression = FROWNING;
		stopTween();
		changeFrame(FROWN);
		tweenScale(null, -1);
	}
	
	public function ooh() {
		if (_currentExpression == OOH) return;
		_currentExpression = OOH;
		stopTween();
		changeFrame(OOH);
		scale.set(0.5, 0.5);
	}
	
	private inline function tweenScale(?x:Float, ?y:Float) {
		if (x == null && y == null) return;
		var values:Dynamic = {};
		if (x != null)
			values.x = x;
		if (y != null)
			values.y = y;
		tween = FlxTween.tween(_scale, values, 0.25);
	}
	
	private inline function stopTween() {
		if (tween != null)
			tween.cancel();
	}
	
}