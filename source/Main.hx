package;

import flixel.FlxGame;
import openfl.Lib;
import openfl.display.Sprite;
import state.MenuState;
import state.TestState;
// #if (debug && cpp)
// import debugger.HaxeRemote;
// #end


class Main extends Sprite {
	public function new() {
		super();		
		// #if (debug && cpp)
		// 	new debugger.HaxeRemote(false, "localhost");
		// #end

		addChild(new FlxGame(1280, 720, MenuState, 1, 60, 60, true));
	}
}
