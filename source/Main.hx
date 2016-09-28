package;

import flixel.FlxGame;
import openfl.Lib;
import openfl.display.Sprite;
import state.MenuState;
import state.GridState;
#if debug
import debugger.HaxeRemote;
#end


class Main extends Sprite {
	public function new() {
		super();		
		#if debug
			new debugger.HaxeRemote(true, "localhost");
		#end
		
		addChild(new FlxGame(0, 0, MenuState));
	}
}
