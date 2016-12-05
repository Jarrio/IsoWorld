
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
import flixel.ui.FlxButton;

import flixel.addons.text.FlxTextField;
import flixel.addons.ui.FlxInputText;

import system.world.World;

class MenuState extends FlxState {
	public var depth:Depth;
	public var generate:Generate;

	public var group:FlxTypedSpriteGroup<IsoSprite> = new FlxTypedSpriteGroup<IsoSprite>();
	public var text:FlxText;
	
	public var game:World;

	public var player:Player;
	public var width_int:Int = 100;

	public var test:Null<Int> = null;

	public var thread_pool:ThreadPool;

	public var label_x:FlxTextField;
	public var label_y:FlxTextField;
	public var label_z:FlxTextField;

	public var text_x:FlxInputText;
	public var text_y:FlxInputText;
	public var text_z:FlxInputText;

	public var blocks_x:Int = 2;
	public var blocks_y:Int = 2;
	public var blocks_z:Int = 2;

	public var blocks_btn:FlxButton;

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
		generate.chunk();
		

		player = new Player(0, 0, -1, null, this);
		
		label_x = new FlxTextField(0, 0, 32, "x: ", 26);		
		label_x.color = FlxColor.BLACK;

		label_y = new FlxTextField(0, 0, 32, "y: ", 26);
		label_y.color = FlxColor.BLACK;

		label_z = new FlxTextField(0, 0, 32, "z: ", 26);
		label_z.color = FlxColor.BLACK;

		text_x = new FlxInputText(0, 0, 100, Std.string(this.blocks_x), 26, FlxColor.BLACK, FlxColor.TRANSPARENT);
		text_y = new FlxInputText(0, 0, 100, Std.string(this.blocks_y), 26, FlxColor.BLACK, FlxColor.TRANSPARENT);
		text_z = new FlxInputText(0, 0, 100, Std.string(this.blocks_z), 26, FlxColor.BLACK, FlxColor.TRANSPARENT);
		
		blocks_btn = new FlxButton(0, 0, "Reset", this.reset_blocks);

		// player.visible = false;
// 

		this.camera.follow(player, FlxCameraFollowStyle.LOCKON);		

		// for (i in 0...generate.members.length) {
		// 	var member = generate.members[i];
		// 	member.ID = i;
		// 	member.world = this;

		// 	group.add(member);
		// }

		for (i in 0...generate.chunks_array.length) {
			for (y in 0...generate.chunks_array[i].blocks.length) {
				var block = generate.chunks_array[i].blocks[y];
				block.world = this;
				group.add(block);
			}
		}

		// for (y in 0...this.blocks_y) {
		// 	for (x in 0...this.blocks_x) {
		// 		for (z in 0...blocks_z) {
		// 			var member = new Block(x, y,z, AssetPaths.new_water_cube__png);
		// 			member.world = this;
		// 			group.add(member);
		// 		}
		// 	}
		// }

		group.add(player);
		add(group);		

		add(label_x);
		add(label_y);
		add(label_z);

		add(text_x);
		add(text_y);
		add(text_z);

		add(blocks_btn);
		camera.zoom = 1;

		
		this.init();
//		FlxG.cameras.add()
	}

	public function reset_blocks() {
		this.blocks_x = Std.parseInt(this.text_x.text);
		this.blocks_y = Std.parseInt(this.text_y.text);
		this.blocks_z = Std.parseInt(this.text_z.text);

		this.group.destroy();
		group = new FlxTypedSpriteGroup<IsoSprite>();
		for (y in 0...this.blocks_y) {
			for (x in 0...this.blocks_x) {
				for (z in 0...blocks_z) {
					var member = new Block(x, y, z, AssetPaths.new_water_cube__png);
					member.world = this;
					group.add(member);
				}
			}
		}
		player = new Player(0, 0, -1, null, this);
		player.visible = false;
		group.add(player);
		add(group);

		this.camera.follow(player, FlxCameraFollowStyle.LOCKON);		
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

	public var speed:Float = 30;

	public var tab_index:Int = -1;
	public var tab_active:Bool = false;
	override public function update(elapsed:Float):Void	{	
		for (i in 0...group.length) {
			this.group.members[i].iso_bounds.PreUpdate(); 
		}

		for (i in 0...group.length) {
			this.depth.update_bounding_cube(group.members[i]);
		}
		
		this.game.Collide(this.player, this.group.members); 
		super.update(elapsed);	

		label_x.y = (this.player.y - 290);
		label_x.x = (this.player.x - 600);

		label_y.y = (this.player.y - 260);
		label_y.x = (this.player.x - 600);

		label_z.y = (this.player.y - 230);
		label_z.x = (this.player.x - 600);

		text_x.y = (this.player.y - 290);
		text_x.x = (this.player.x - 600) + 40;

		text_y.y = (this.player.y - 260);
		text_y.x = (this.player.x - 600) + 40;

		text_z.y = (this.player.y - 230);
		text_z.x = (this.player.x - 600) + 40;		
		
		blocks_btn.y = 120;
		blocks_btn.x = 16;

		this.update_phase = true;

		if (this.first_run) {
			this.thread_pool.addTask(sort_members(x), null, this.thread_back(x));
			this.first_run = false;
		}
		

		// this.sort_members();
		
		if (FlxG.keys.justPressed.TAB) {
			if (this.tab_index > -1 && this.tab_index < 2) {
				this.tab_index++;
			} else {
				this.tab_index = 0;
			}
		}
		
		switch(tab_index) {
			case -1:
				this.text_x.hasFocus = false;
				this.text_y.hasFocus = false;
				this.text_z.hasFocus = false;
			case 0: 
				this.text_x.hasFocus = true;
				this.text_y.hasFocus = false;
				this.text_z.hasFocus = false;
			case 1: 
				this.text_x.hasFocus = false;
				this.text_y.hasFocus = true;
				this.text_z.hasFocus = false;

			case 2: 
				this.text_x.hasFocus = false;
				this.text_y.hasFocus = false;
				this.text_z.hasFocus = true;
								
				
		}

		if (FlxG.keys.justPressed.ENTER) {
			if (this.text_x.hasFocus || this.text_y.hasFocus || this.text_z.hasFocus) {
				this.reset_blocks();
				this.tab_index = -1;		
			}
		}
		
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
		FlxG.watch.addQuick("Player Chunk:", 'x: ${Math.fceil(player.iso_x / 3)} y: ${Math.fceil(player.iso_y / 3)}');
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
		// #if debug
		// var commands = new CustomCommands(this);

		// var trackers = new TrackerProfiles();

		// for (i in 0...trackers.profiles.length) {
		// 	FlxG.debugger.addTrackerProfile(trackers.profiles[i]);
		// }

		// FlxG.console.autoPause = false;

		// FlxG.console.registerFunction("sprite", commands.sprite);
		// FlxG.console.registerFunction("group", commands.group);

		// var window = FlxG.debugger.track(player, "Player sprite");
		// window.reposition(0, 0);
		// FlxG.debugger.track(player.iso_bounds, "Player body").reposition(0, window.height);
		
		// FlxG.debugger.track(group.members[0], "Block sprite").reposition(window.width, 0);
		// FlxG.debugger.track(group.members[0].iso_bounds, "Block body").reposition(window.width, window.height);
		// #end		
	}
}