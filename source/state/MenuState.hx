
package state;

import haxe.ds.Vector;
import flixel.FlxSprite;
import flixel.FlxG;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.FlxCamera;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxSpriteGroup;
import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;

import flixel.util.FlxSort;
import haxe.ds.ArraySort;
import flixel.system.FlxAssets;
import system.entities.IsoSprite;
import system.world.Depth;
import flixel.FlxCamera;
import flixel.system.debug.watch.Tracker;
import flixel.util.FlxColor;

import system.world.Generate;
import system.entities.Player;
import system.debug.TrackerProfiles;
import system.debug.CustomCommands;
import state.Test;
import system.entities.Block;

import openfl.Assets;
import openfl.display.Bitmap;
import hxmath.math.Vector3;

import system.world.World;

class MenuState extends FlxState {
	public var depth:Depth;
	public var generate:Generate;

	public var group:FlxTypedSpriteGroup<IsoSprite> = new FlxTypedSpriteGroup<IsoSprite>();
	public var debug:FlxSpriteGroup = new FlxSpriteGroup();
	public var text:FlxText;
	
	public var world:World = new World();

	public var player:Player;

	
	override public function create():Void {		
		super.create();		
		#if next
		FlxG.stage.window.x = 320 + 1280 - 1280;
		FlxG.stage.window.y = 30 + 720 - 720;
		FlxG.autoPause = false;
		FlxG.debugger.visible = true;
		FlxG.sound.soundTrayEnabled = false;
		
		//FlxG.sound.play("Test");
		#end
		// FlxG.log.redirectTraces = true;


		var bg = new FlxSprite(0, 0, AssetPaths.bg__jpeg);
		add(bg);
		

		depth = new Depth();
		generate = new Generate();
		generate.Terrain();



		player = new Player(2, 0, 0, null, this.world);

		for (i in 0...generate.members.length) {
			var member = generate.members[i];
			member.ID = i;
			member.world = this.world;

			group.add(member);
		}

		add(group);		
		group.add(player);



		camera.zoom = 1;

		add(debug);





		this.camera.follow(player);

		this.init();

		
//		FlxG.cameras.add()
	}

	public var index_behind:Int = 0;
	
	public var debug_length:Int = 0;
	public var show_debug:Bool = false;

	override public function update(elapsed:Float):Void	{
		super.update(elapsed);	
		
		if (FlxG.keys.justReleased.NUMPADMINUS) {
			if (this.show_debug == true) {
				this.show_debug = false;
				this.debug.kill();
				this.debug.destroy();
				
				this.debug_length = 0;

				this.debug = new FlxSpriteGroup();
				this.add(this.debug);
			} else {
				this.show_debug = true;
			}
		}

		group.forEach(function(sprite) {				
			depth.update_bounding_cube(sprite);								
		});

		this.world.Collide(player, group.members[0]);	

		for (i in 0...group.length) {
			var a = group.members[i];
			index_behind = 0;
			
			for (j in 0...group.length) {
				if (i != j) {
					var b = group.members[j];
					if(depth.find_overlaps(a.iso_bounds.a_comparison, b.iso_bounds.b_comparison)) {
						a.iso_sprites_behind[index_behind++] = b;						
					}
				}
			}
			a.iso_visited = 0;
		}

		depth.sort_depth = 0;
		for (i in 0...group.length) {
			depth.visit_node(group.members[i]);
		}

		// FlxG.watch.addQuick("Length", group.length);
		if ((this.debug_length < group.length) && this.show_debug) {
			for (i in 0...group.length) {
				var member = group.members[i].iso_bounds;		
				if (member != null) {		

					var point = this.depth.transform_to_iso(member.x, member.y, member.z, member.width_x, member.half_width_y, member.half_height);
		
					var debug_cube = new FlxSprite(point.x, point.y, AssetPaths.debug_cube__png);
					this.debug.add(debug_cube);
					this.debug_length++;
				}
			}			
		}

		// FlxG.watch.addQuick("show debug", show_debug);

		if(FlxG.keys.pressed.U) {
			FlxG.camera.zoom -= 0.1;
		} else if(FlxG.keys.pressed.O) {
			FlxG.camera.zoom += 0.1;
		}

		if (FlxG.keys.pressed.ZERO) {
			this.player.iso_x = -10;
			this.player.iso_y = 0;
			this.player.iso_z = 0;

			this.player.iso_bounds.position.x = 0;
			this.player.iso_bounds.position.y = 0;
			this.player.iso_bounds.position.z = 0;
			
			this.player.x = 0;
			this.player.y = 0;
			this.player.z = 0;

		}

		group.sort(SortBy3d, FlxSort.DESCENDING);
		
		FlxG.watch.addQuick("Total", this.world.total);		
		FlxG.watch.addQuick("Result", this.world.result);		
		// FlxG.watch.addQuick("CollisionX", collide);
		// FlxG.watch.addQuick("overlap", this.world.overlap);
		// FlxG.watch.addQuick("max overlap", this.world.max_overlap);
	}



	private function SortBy3d(order:Int, a:IsoSprite, b:IsoSprite):Int {
		//return FlxSort.byValues(order, b.iso_depth, a.iso_depth);
		if (a.iso_depth > b.iso_depth) {
			return 1;
		} else if (a.iso_depth < b.iso_depth) {
			return -1;
		}
		return 0;
	}	

	public function init() {
		#if debug
		var commands = new CustomCommands(this);

		var trackers = new TrackerProfiles();

		for (i in 0...trackers.profiles.length) {
			FlxG.debugger.addTrackerProfile(trackers.profiles[i]);
		}

		FlxG.console.autoPause = false;

		FlxG.console.registerFunction("sprite", commands.sprite);
		FlxG.console.registerFunction("group", commands.group);

		var window = FlxG.debugger.track(player, "Player sprite");
		window.reposition(0, 0);
		FlxG.debugger.track(player.iso_bounds, "Player body").reposition(0, window.height);
		
		FlxG.debugger.track(group.members[0], "Block sprite").reposition(window.width, 0);
		FlxG.debugger.track(group.members[0].iso_bounds, "Block body").reposition(window.width, window.height);
		#end		
	}
}