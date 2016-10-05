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

import system.constants.Map;

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
		player = new Player(0, 0);
		player.camera = grid.map_camera;
		
		

		info = new FlxText(400, 20);
		info.color = FlxColor.WHITE;		

		grid.map_camera.follow(player, FlxCameraFollowStyle.NO_DEAD_ZONE);
		ObjectGroup.camera = grid.map_camera;
		FlxG.cameras.reset(grid.map_camera);
		add(ObjectGroup);
		
		LoadGroup();
		
	}
	
	public function LoadGroup() {

		for (i in 0...grid.chunks.length) {
			for (j in 0...grid.chunks[i].members.length) {
				ObjectGroup.add(grid.chunks[i].members[j]);
			}
		}
		ObjectGroup.add(player);		
		add(info);
	}	
	//New Method
	public function UpdateModels() {
		for (i in 0...ObjectGroup.length) {
			var sprite:Basic = ObjectGroup.members[i];
        	//sprite.x = ((sprite.IsoX - sprite.IsoY) * Map.BASE_TILE_HALF_WIDTH);
        	//sprite.y = ((sprite.IsoY + sprite.IsoX - (sprite.IsoZ * Map.BASE_TILE_HALF_HEIGHT)) * Map.BASE_TILE_HALF_HEIGHT); 
			
			sprite.MinX = sprite.IsoX + sprite.MinXRelative;
			sprite.MaxX = sprite.IsoX + sprite.MaxXRelative;
			
			sprite.MinY = sprite.IsoY + sprite.MinYRelative;
			sprite.MaxY = sprite.IsoY + sprite.MaxYRelative;

			sprite.MinZ = sprite.IsoZ + sprite.MinZRelative;
			sprite.MaxZ = sprite.IsoZ + sprite.MaxZRelative;
		}

		var a:Basic;
		var b:Basic;
		
		var sprites_length:Int = ObjectGroup.length;
		var behind_index:Int;
		for (i in 0...sprites_length) {
			a = ObjectGroup.members[i];
			behind_index = 0;
			for (j in 0...sprites_length) {
				if (i != j) {
					b = ObjectGroup.members[j];
					if ((b.MinX < a.MaxX) && (b.MinX < a.MaxY) && (b.MinZ < a.MaxZ)) {
						a.IsoSpritesBehind[behind_index++] = b;
					}
				}
			}
			a.IsoVisitedFlag = 0;
		}
		
		for (i in 0...sprites_length) {
			visitNode(ObjectGroup.members[i]);
			//if (i == sprites_length-1) _sortDepth = 0;
		}

		
	}
	
	public var _sortDepth = 0;

	private function visitNode(sprite:Basic):Void {
		if (sprite.IsoVisitedFlag == 0) {
			sprite.IsoVisitedFlag = 1;

			var spritesBehindLength:Int = sprite.IsoSpritesBehind.length;
			for (i in 0...spritesBehindLength) {
				if (sprite.IsoSpritesBehind[i] == null) {
					break;
				} else {
					visitNode(sprite.IsoSpritesBehind[i]);
					sprite.IsoSpritesBehind[i] = null;
				}
			}

			sprite.IsoDepth = _sortDepth++;
		}
		
	}
//https://mazebert.com/2013/04/18/isometric-depth-sorting/




	override public function update(elapsed:Float):Void {
		UpdateModels();		
		ObjectGroup.sort(SortBy3d);		


		if (FlxG.keys.justPressed.PLUS) {
			camera.zoom += 1;
		} else if (FlxG.keys.justPressed.MINUS) {
			camera.zoom -= 1;
		}

		var mousePos = new FlxPoint(FlxG.mouse.x, FlxG.mouse.y);
		var mouseTile = grid.GetChunkPoint(mousePos);
		info.text = ('Mouse X: ${mousePos.x} | Mouse Y: ${mousePos.y} \n') +
					('Tile Y: ${mouseTile.y} | Tile X: ${mouseTile.x}');
		info.x = player.x - 80;
		info.y = player.y - 145;		

		super.update(elapsed);
	}

	private function SortBy3d(order:Int, a:Basic, b:Basic):Int {
		if (a.IsoDepth > b.IsoDepth) {
			return order;
		} else if (a.IsoDepth < b.IsoDepth) {
			return -order;
		}

		return 0;
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
}
