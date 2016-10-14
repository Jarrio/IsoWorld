package;

import flixel.FlxGame;
import openfl.Lib;
import openfl.display.Sprite;
import state.MenuState;
import state.GridState;
#if (debug && cpp)
import debugger.HaxeRemote;
#end


class Main extends Sprite {
	public function new() {
		super();		
		#if (debug && cpp)
			new debugger.HaxeRemote(false, "localhost");
		#end
		var game = new FlxGame(640, 480, MenuState);
		addChild(game);
	}
}
