
package state;

import flixel.FlxG;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.group.FlxSpriteGroup;
import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;

import flixel.util.FlxSort;
import system.entities.IsoSprite;
import system.world.Depth;
import flixel.FlxCamera;
import flixel.util.FlxColor;

import system.world.Generate;
import system.entities.Player;
import system.debug.TrackerProfiles;
import system.debug.CustomCommands;
import system.entities.Block;

import system.utility.ThreadPool;

import flixel.ui.FlxBar;

import system.world.World;

class MenuState extends FlxState {
	public var depth:Depth;
	public var generate:Generate;

	public var group:FlxTypedSpriteGroup<IsoSprite> = new FlxTypedSpriteGroup<IsoSprite>();
	public var text:FlxText;
	
	public var game:World;

	public var player:Player;

	public var bar:FlxBar;
	public var width_int:Int = 100;

	public var test:Null<Int> = null;

	public var thread_pool:ThreadPool;
	
	override public function create():Void {		
		super.create();		
		this.thread_pool = new ThreadPool(8);
		game = new World();
		#if next
		FlxG.stage.window.x = 320 + 960;
		FlxG.stage.window.y = 30 + 720;
		FlxG.autoPause = false;
		FlxG.debugger.visible = true;
		FlxG.sound.soundTrayEnabled = false;
		
		//FlxG.sound.play("Test");
		#end

		this.bgColor = FlxColor.WHITE;

		
		depth = new Depth();
		generate = new Generate();
		generate.Terrain();
		

		player = new Player(0, 0, 12, null, this);

		this.camera.follow(player, FlxCameraFollowStyle.TOPDOWN);

		for (i in 0...generate.members.length) {
			var member = generate.members[i];
			member.ID = i;
			member.world = this;

			group.add(member);
		}

		var custom_1 = new Block(5, 0, 0);
		var custom_2 = new Block(-5, 0, 0);
		var custom_3 = new Block(0, 5, 0);
		var custom_4 = new Block(0, -5, 0);
		var custom_5 = new Block(0, 0, -2);
		
		custom_1.world = this;
		custom_2.world = this;
		custom_3.world = this;
		custom_4.world = this;
		custom_5.world = this;

		// group.add(custom_1);
		// group.add(custom_2);
		// group.add(custom_3);
		// group.add(custom_4);
		// group.add(custom_5);

		group.add(player);
		add(group);		




		camera.zoom = 1;



		this.init();
		
		
		
//		FlxG.cameras.add()
	}

	public var index_behind:Int = 0;
	
	public var debug_length:Int = 0;
	public var show_debug:Bool = false;

	public var update_phase:Bool = false;
	public var running:Bool = false;

	public function thread_back(x:Dynamic):Dynamic {
		if (this.update_phase) {
			this.running = true;
			this.thread_pool.addTask(sort_members(x), null, this.thread_back(x));
			
		}
		return null;
	}

	public function sort_members(x:Dynamic):Dynamic {
		if (this.update_phase) {		
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
			
			group.sort(SortBy3d, FlxSort.DESCENDING);
			this.update_phase = false;
			this.running = false;
		}
		return null;
	}
	public var first_run:Bool = true;

	
	override public function update(elapsed:Float):Void	{	
		for (i in 0...group.length) {
			this.group.members[i].iso_bounds.PreUpdate(); 
		}

		for (i in 0...group.length) {
			this.depth.update_bounding_cube(group.members[i], this);
		}
		
		this.game.Collide(this.player, this.group.members); 
		super.update(elapsed);	

		this.update_phase = true;

		if (this.first_run) {
			this.thread_pool.addTask(sort_members(x), null, this.thread_back(x));
			this.first_run = false;
		}
		

		// this.sort_members();
		

		
		// FlxG.watch.addQuick("show debug", show_debug);

		if(FlxG.keys.pressed.U) {
			FlxG.camera.zoom -= 0.1;
		} else if(FlxG.keys.pressed.O) {
			FlxG.camera.zoom += 0.1;
		}

		
		
		for (i in 0...group.length) {
			this.group.members[i].iso_bounds.PostUpdate(); 
		}
		
		//FlxG.watch.addQuick("Intersects", this.game.intersects(player.iso_bounds, group.members[0].iso_bounds));
		// FlxG.watch.addQuick("overlap", this.world.overlap);
		// FlxG.watch.addQuick("max overlap", this.world.max_overlap);

		if (!this.running) {
			this.thread_back(null);
		}
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