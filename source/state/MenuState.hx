
package state;

import haxe.ds.Vector;
import flixel.FlxSprite;
import flixel.FlxG;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.FlxCamera;
import flixel.group.FlxGroup.FlxTypedGroup;
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



class MenuState extends FlxState {
	public var depth:Depth;
	public var generate:Generate;

	public var group:FlxTypedSpriteGroup<IsoSprite> = new FlxTypedSpriteGroup<IsoSprite>();
	public var text:FlxText;
	
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
		
		depth = new Depth();
		generate = new Generate();
		generate.Terrain();

		camera.zoom = 0.5;
		for (i in 0...generate.members.length) {
			var member = generate.members[i];
			member.ID = i;
			group.add(member);
		}
		player = new Player(0, 0, 1);
		//group.add(player);
		add(group);
		
		text = new FlxText(400, 100, 150);
		text.color = FlxColor.WHITE;
		add(text);

		this.init();
//		FlxG.cameras.add()
	}

	public var index_behind:Int = 0;
	
	override public function update(elapsed:Float):Void	{
		super.update(elapsed);	

		group.forEach(function(sprite) {
			depth.update_bounding_cube(sprite);
		});

		var camera_speed = 20;
		if(FlxG.keys.pressed.I) {
			FlxG.camera.scroll.y -= camera_speed;
		} else if(FlxG.keys.pressed.K) {
			FlxG.camera.scroll.y += camera_speed;
		} else if(FlxG.keys.pressed.J) {
			FlxG.camera.scroll.x -= camera_speed;
		} else if(FlxG.keys.pressed.L) {
			FlxG.camera.scroll.x += camera_speed;
		}

		if(FlxG.keys.pressed.U) {
			FlxG.camera.zoom -= 0.1;
		} else if(FlxG.keys.pressed.O) {
			FlxG.camera.zoom += 0.1;
		}

		for (i in 0...group.length) {
			var a = group.members[i];
			index_behind = 0;

			var a_vector = new Vector<Float>(3);
			a_vector[0] = a.iso_bounds.front_x;
			a_vector[1] = a.iso_bounds.front_y;
			a_vector[2] = a.iso_bounds.top;
			
			for (j in 0...group.length) {
				if (i != j) {
					var b = group.members[j];
					var b_vector = new Vector<Float>(3);
					b_vector[0] = b.iso_bounds._x;
					b_vector[1] = b.iso_bounds._y;
					b_vector[2] = b.iso_bounds._z;			

					if(depth.find_overlaps(a_vector, b_vector)) {
						//a.iso_sprites_behind[index_behind++] = b;
					}
				}
			}
			a.iso_visited = false;
		}

		depth.sort_depth = 0;
		for (i in 0...group.length) {
			//depth.visit_node(group.members[i]);
		}
		
		//group.sort(SortBy3d, FlxSort.DESCENDING);
	}

	private function SortBy3d(order:Int, a:IsoSprite, b:IsoSprite):Int {
		//return FlxSort.byValues(order, a.IsoDepth, b.IsoDepth);
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
		FlxG.debugger.addTrackerProfile(new TrackerProfile(FlxSprite, [""]));
		for (i in 0...trackers.profiles.length) {
			var clname = Type.getClassName(trackers.profiles[i].objectClass);
			trace('${i} - ${clname}');
			FlxG.debugger.addTrackerProfile(trackers.profiles[i]);
		}

		FlxG.console.autoPause = false;

		FlxG.console.registerFunction("sprite", commands.sprite);
		FlxG.console.registerFunction("group", commands.group);

		var window = FlxG.debugger.track(player, "Player sprite");
		window.reposition(0, 0);
		var player_height = window.height; 
		FlxG.debugger.track(player.iso_bounds, "Player body").reposition(0, player_height);
		#end		
	}
}

