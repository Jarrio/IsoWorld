
package state;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.math.FlxMath;
import system.helpers.Isometric;

import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;

import system.grid.Grid;
import system.entities.Basic;
import system.entities.Block;
import system.entities.Player;
import system.constants.Map;
import flixel.util.FlxSort;
import haxe.ds.ArraySort;
import flixel.system.FlxAssets;

class MenuState extends FlxState {
	public var player:Player;
	public var grid:Grid = new Grid();
	public var group:FlxTypedSpriteGroup<Basic> = new FlxTypedSpriteGroup<Basic>();


	override public function create():Void {		
		super.create();

		#if next
		FlxG.stage.window.x = 320 + 640;
		FlxG.stage.window.y = 30 + 500;
		FlxG.autoPause = false;
		FlxG.debugger.visible = true;
		FlxG.sound.soundTrayEnabled = false;
		#end

		grid.LoadChunks();
		FlxG.cameras.reset(grid.map_camera);
		

		player = new Player(9, 4, 1);
		
		add(group);
		
		for (i in 0...grid.chunks.length) {
			var object = grid.chunks[i];
			group.add(object);
		}		
		group.add(player);		
	}

	override public function draw() {
		super.draw();
		
	}

	
	override public function update(elapsed:Float):Void	{
		super.update(elapsed);
		UpdateModels();			
	}

	private function SortBy3d(order:Int, a:Basic, b:Basic):Int {
		//return FlxSort.byValues(order, a.IsoDepth, b.IsoDepth);
		if (a.IsoDepth > b.IsoDepth) {
			return 1;
		} else if (a.IsoDepth < b.IsoDepth) {
			return -1;
		}
		return 0;
	}
	
	public var _sortDepth = 0;
	public var behind_index:Int = 0;
	public var padding:Float = 0.1;

	public function UpdateModels() {
		var sprites_length = group.members.length;

		group.forEach(function(sprite) {
				
				sprite.WidthX = Math.round(Math.abs(sprite.width) * 0.5) * Math.abs(sprite.scale.x);
				sprite.WidthY = Math.round(Math.abs(sprite.width) * 0.5) * Math.abs(sprite.scale.x);
				sprite.HalfWidthX = Math.round(sprite.WidthX * 0.5);
				sprite.HalfWidthY = Math.round(sprite.WidthY * 0.5);

				sprite.HeightZ = Math.round(Math.abs(sprite.height) - (Math.abs(sprite.width) * 0.5)) * Math.abs(sprite.scale.y);

				sprite.FrontX = sprite.IsoX + 1;
				sprite.FrontY = sprite.IsoY + 1;
				sprite.Top = sprite.IsoZ + 1;

				sprite.BackX = sprite.IsoX;				
				sprite.BackY = sprite.IsoY;
		});
		
		var a;
		var b;
		var i;
		var j;

		for (i in 0...sprites_length) {
			a = group.members[i];
			behind_index = 0;
			
			for (j in 0...sprites_length) {
				if (i != j) {
					b = group.members[j];

					//if (b.MinX < a.MinX && b.MinY < a.MaxY && b.MinZ < a.MaxZ) {
					// trace('b.x: ${b.x} | a.frontX: ${a.FrontX}');
					// trace('b.y: ${b.y} | a.frontY: ${a.FrontY}');
					// trace('b.z: ${b.z} | a.Top: ${a.Top}');
					if (b.BackX + padding < a.FrontX - padding && b.BackY + padding < a.FrontY - padding && b.IsoZ + padding < a.Top - padding) {
						a.IsoSpritesBehind[behind_index++] = b;
					}
				}
			}
			a.IsoVisitedFlag = false;
		}

		_sortDepth = 0;
		
		for (i in 0...sprites_length) {
			visitNode(group.members[i]);	
		}

		group.forEach(function(basic) {
			player.check_overlap_basic(basic);
		});
		group.sort(SortBy3d, FlxSort.ASCENDING);		
	}

	

	public function visitNode(sprite:Basic):Void {
		if (sprite.IsoVisitedFlag == false) {
			sprite.IsoVisitedFlag = true;

			var spritesBehindLength = sprite.IsoSpritesBehind.length;
			
			for (i in 0...spritesBehindLength) {
				if (sprite.IsoSpritesBehind[i] == null) {
					break;
				} else {
					visitNode(sprite.IsoSpritesBehind[i]);
					sprite.IsoSpritesBehind[i] = null;
				}
			}
			//trace(sprite.return_debug_values(sprite.Entity));
			_sortDepth+=2;
			if (sprite.Moved) {
				if (sprite.Entity == "Player") {
					sprite.IsoDepth = _sortDepth - 1;
				} else {
					sprite.IsoDepth = _sortDepth;
				}
				sprite.Moved = true;				
			}	

		}
			
		
	}	
}
