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
        player = new Player();
		player.visible = true;

        floor = new FlxSprite(100, 400);
		floor.loadGraphic(AssetPaths.test_slope__png);
		floor.immovable = true;
		add(floor);
		add(player);


		sound.loadEmbedded(AssetPaths.tone__ogg, true, false);
		sound.loopTime = 10.0;
		sound.play(true);		
		
	}

	override public function update(elapsed:Float):Void {
		super.update(elapsed);

		if (FlxG.pixelPerfectOverlap(floor, player)) {
			FlxG.collide(floor, player);
		}
	}
}
