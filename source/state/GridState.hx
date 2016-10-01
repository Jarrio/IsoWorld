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
import flixel.system.FlxLinkedList;
import flixel.group.FlxSpriteGroup;

import flixel.group.FlxGroup;

class GridState extends FlxState {
	public var player:Player;
	public var grid:Grid;
	public var info:FlxText;

	public var ChunkGroup:FlxSpriteGroup = new FlxSpriteGroup();
	public var ChunkRadius:FlxLinkedList;

	override public function create():Void { 
		super.create();
		grid = new Grid();
		grid.LoadChunks();		
		
		player = new Player();
		player.visible = true;
		

		info = new FlxText(400, 20);
		info.color = FlxColor.WHITE;
		add(info);

		grid.map_camera.follow(player, FlxCameraFollowStyle.NO_DEAD_ZONE);
		FlxG.cameras.reset(grid.map_camera);
		
		add(grid.chunks);
		add(player);		
	}
	
	private var distance = 128;

	public function UnloadChunks() {
		for (i in 0...grid.chunks.members.length) {
			var chunk = grid.chunks.members[i];
					
			if (Math.abs(chunk.x - player.x) > distance || Math.abs(chunk.y - player.y) > distance || Math.abs(chunk.y - player.y) < -distance || Math.abs(chunk.y - player.y) < -distance)  {
				chunk.kill();
			} else {
				chunk.revive();
			}
		}
	}

	override public function update(elapsed:Float):Void {
		super.update(elapsed);

		if (FlxG.keys.justPressed.PLUS) {
			camera.zoom += 0.5;
		} else if (FlxG.keys.justPressed.MINUS) {
			camera.zoom -= 0.5;
		}


		var mousePos = new FlxPoint(FlxG.mouse.x, FlxG.mouse.y);
		var mouseTile = grid.GetChunkPoint(mousePos);
		info.text = ('Mouse X: ${mousePos.x} | Mouse Y: ${mousePos.y} \n') +
					('Tile Y: ${mouseTile.y} | Tile X: ${mouseTile.x}');
		info.x = player.x - 80;
		info.y = player.y - 145;		
		UnloadChunks();
	}
}
