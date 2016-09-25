package state;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;

import system.grid.Grid;
import system.entities.Player;
import system.helpers.Isometric;

class GridState extends FlxState {
	public var player:Player;
	public var grid:Grid;
	public var info:FlxText;

	override public function create():Void {
		super.create();
		FlxG.camera.antialiasing = false;
		grid = new Grid();
		grid.CalculateTiles();

		for (i in 0...grid.chunks.length) {
			var chunk = grid.chunks[i];
			add(chunk.chunk_tiles);
			add(chunk.chunk_tiles.number);			
		}
		
		player = new Player();
		add(player);

		info = new FlxText(400, 20);
		info.color = FlxColor.WHITE;
		add(info);

	}

	override public function update(elapsed:Float):Void {
		super.update(elapsed);
		var mousePos = new FlxPoint(FlxG.mouse.screenX, FlxG.mouse.screenY);
		var mouseTile = Isometric.GridCordsFromScreen(mousePos);
		info.text = ('Mouse X: ${mousePos.x} | Mouse Y: ${mousePos.y} \n') +
					('Tile Y: ${mouseTile.y} | Tile X: ${mouseTile.x}');
		
		
	}
}
