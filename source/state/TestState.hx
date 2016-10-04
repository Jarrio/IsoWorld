package state;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.math.FlxMath;
import flixel.util.FlxColor;
import flixel.util.FlxCollision;
import system.entities.Player;
import flixel.system.FlxSound;


class TestState extends FlxState {
	public var player:Player;
	public var floor:FlxSprite;
	public var sound:FlxSound = new FlxSound();
	
	override public function create():Void {
		super.create();
		this.bgColor = FlxColor.fromString("#777777");
        player = new Player();
		add(player);


		sound.loadEmbedded(AssetPaths.tone__ogg, true, false);
		sound.loopTime = 10.0;
		sound.play(true);		
		
	}

	override public function update(elapsed:Float):Void {
		super.update(elapsed);

	}
}
