package state;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxBasic;
import flixel.FlxState;
import flixel.FlxCamera;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;

import system.grid.Grid;
import system.entities.Player;
import system.helpers.Isometric;

import flixel.group.FlxGroup;

class GridState extends FlxState {
	public var player:Player;
	public var grid:Grid;
	public var info:FlxText;

	public var ChunkGroup:FlxGroup = new FlxGroup();

	override public function create():Void { 
		super.create();
		grid = new Grid();
		grid.LoadChunks();
		add(grid.chunks);
		
		player = new Player();
		add(player);

		info = new FlxText(400, 20);
		info.color = FlxColor.WHITE;
		add(info);

		FlxG.cameras.reset(grid.map_camera);
	}

	/*public function chunk(distance:Int) {
		grid.chunks.forEach(function(sprite:FlxBasic) {
			sprite.destroy();
		});

		grid.chunk_render_distance = distance;
		grid.LoadChunks();
		for (i in 0...grid.chunks.length) {
			var chunk = grid.chunks[i];
			ChunkGroup.add(chunk);				
		}
	}*/

	override public function update(elapsed:Float):Void {
		super.update(elapsed);

		var mousePos = new FlxPoint(FlxG.mouse.screenX, FlxG.mouse.screenY);
		var mouseTile = Isometric.GridCordsFromScreen(mousePos);
		info.text = ('Mouse X: ${mousePos.x} | Mouse Y: ${mousePos.y} \n') +
					('Tile Y: ${mouseTile.y} | Tile X: ${mouseTile.x}');
		
		
	}
}
