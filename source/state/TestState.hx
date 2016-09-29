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


class TestState extends FlxState {
	public var player:Player;
	public var floor:FlxSprite;

	override public function create():Void {
		super.create();
        player = new Player();
		player.visible = true;

        floor = new FlxSprite(100, 400);
		floor.loadGraphic(AssetPaths.test_slope__png);
		floor.immovable = true;
		add(floor);
		add(player);
		
	}

	override public function update(elapsed:Float):Void {
		super.update(elapsed);

		if (FlxG.pixelPerfectOverlap(floor, player)) {
			FlxG.collide(floor, player);
		}
	}
}
