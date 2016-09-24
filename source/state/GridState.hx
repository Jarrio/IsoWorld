package state;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.math.FlxMath;
import system.grid.Grid;
import flixel.math.FlxPoint;

class GridState extends FlxState {
	override public function create():Void {
		super.create();
		FlxG.camera.antialiasing = false;
		var grid = new Grid();
		grid.CalculateTiles();
		for (i in 0...grid.StoredTiles.length) {
			var tile = grid.StoredTiles[i];
			add(tile);
			
		}

		
	}

	override public function update(elapsed:Float):Void {
		super.update(elapsed);
	}
}
