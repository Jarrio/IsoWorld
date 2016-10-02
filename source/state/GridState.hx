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
import system.entities.GrassBlock;
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
		/*
		var gblock11 = new GrassBlock(12, 6);
		var gblock12 = new GrassBlock(12, 6, -1);
		var gblock13 = new GrassBlock(12, 6, -2);
		var gblock14 = new GrassBlock(12, 6, -3);
		add(gblock14);
		add(gblock13);
		add(gblock12);
		add(gblock11);
		


		var gblock = new GrassBlock(-1, -1);
		var gblock2 = new GrassBlock(-1, -1, 1);
		var gblock3 = new GrassBlock(-1, -1, 2);
		var gblock4 = new GrassBlock(-1, -1, 3);
		var gblock5 = new GrassBlock(-1, -1, 4);
		var gblock6 = new GrassBlock(-1, 2, 0);
		var gblock7 = new GrassBlock(-1, 6);
		var gblock8 = new GrassBlock(-1, 6, 1);
		var gblock9 = new GrassBlock(-1, 6, 2);
		
		add(gblock);
		add(gblock2);
		add(gblock3);
		add(gblock4);
		add(gblock5);
		add(gblock6);
		add(gblock7);
		add(gblock8);
		add(gblock9);*/

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
