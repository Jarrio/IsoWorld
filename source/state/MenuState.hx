package state;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.math.FlxMath;

class MenuState extends FlxState
{
	override public function create():Void {
		super.create();
		var switchToGridState = new FlxButton(20, 20, "Grid State", function() {FlxG.switchState(new GridState());});
		add(switchToGridState);

	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}
}
