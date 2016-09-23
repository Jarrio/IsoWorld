package;

import flixel.FlxGame;
import openfl.Lib;
import openfl.display.Sprite;
import state.MenuState;

class Main extends Sprite {
	public function new() {
		super();
		new debugger.HaxeRemote(false, "localhost");
		addChild(new FlxGame(0, 0, MenuState));
	}
}
