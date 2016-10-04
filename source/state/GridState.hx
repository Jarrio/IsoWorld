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
import flixel.util.FlxSort;

import system.grid.Grid;
import system.entities.Player;
import system.entities.GrassBlock;
import system.constants.BasicTypes;
import system.entities.Basic;
import system.helpers.Isometric;
import flixel.system.FlxLinkedList;
import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;

import flixel.group.FlxGroup;

class GridState extends FlxState {
	public var player:Player;
	public var grid:Grid;
	public var info:FlxText;

	public var ObjectGroup:FlxTypedSpriteGroup<Basic> = new FlxTypedSpriteGroup<Basic>();
	public var ChunkRadius:FlxLinkedList;
	public var game_camera:FlxCamera;
	
	override public function create():Void { 
		super.create();
		grid = new Grid();
		grid.LoadChunks();
		player = new Player();
		
		

		info = new FlxText(400, 20);
		info.color = FlxColor.WHITE;
		add(info);

		grid.map_camera.follow(player, FlxCameraFollowStyle.NO_DEAD_ZONE);
		ObjectGroup.camera = grid.map_camera;
		FlxG.cameras.reset(grid.map_camera);
		add(ObjectGroup);
		
		CheckLocations();
		
	}
	
	public function CheckLocations() {
		ObjectGroup.add(player);
		for (i in 0...grid.chunks.length) {
			for (j in 0...grid.chunks[i].members.length) {
				ObjectGroup.add(grid.chunks[i].members[j]);
			}
		}
		
	}

	private var distance = 128;
	/*
	public function UnloadChunks() {
		for (i in 0...grid.chunks.members.length) {
			var chunk = grid.chunks.members[i];
			for (tiles in 0...chunk.chunk_tiles.length) {
				var tiles = chunk.chunk_tiles.members[tiles];
				var sum = tiles.x + tiles.y + tiles.z;
				var playersum = player.x + player.y + player.z;
				if (playersum < sum) {
					var point = Isometric.TwoDToIso(new FlxPoint(player.x, player.y), player.z);
					player.reset(point.x, point.y);
				}
			}
			
			if (Math.abs(chunk.x - player.x) > distance || Math.abs(chunk.y - player.y) > distance || Math.abs(chunk.y - player.y) < -distance || Math.abs(chunk.y - player.y) < -distance)  {
				chunk.kill();
			} else {
				chunk.revive();
			}
		}
	}*/

	override public function update(elapsed:Float):Void {
		super.update(elapsed);

		if (FlxG.keys.justPressed.PLUS) {
			camera.zoom += 1;
		} else if (FlxG.keys.justPressed.MINUS) {
			camera.zoom -= 1;
		}
		FlxG.watch.addQuick("Player Z: ", 'x: ${player.x} - y: ${player.y} - z: ${player.z}');
		FlxG.watch.addQuick("Player Depth: ", player.depth);
		

		var mousePos = new FlxPoint(FlxG.mouse.x, FlxG.mouse.y);
		var mouseTile = grid.GetChunkPoint(mousePos);
		info.text = ('Mouse X: ${mousePos.x} | Mouse Y: ${mousePos.y} \n') +
					('Tile Y: ${mouseTile.y} | Tile X: ${mouseTile.x}');
		info.x = player.x - 80;
		info.y = player.y - 145;		
		//UnloadChunks();
		ObjectGroup.sort(SortBy3d, FlxSort.DESCENDING);
	}

	private function SortBy3d(order:Int, a:Basic, b:Basic):Int {
		var a_sum = (a.depth);
		var b_sum = (b.depth);	
		
		if (a_sum == b_sum) {
			return (a_sum != 0) ? 0 : Math.floor(a_sum);
		}
		if (a_sum > b_sum) return Math.floor(a_sum);
		
		return -1;
	}
}
