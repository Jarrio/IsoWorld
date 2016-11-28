package state;


import flixel.FlxG;
import flixel.FlxState;

class DebugState extends FlxState {

	public var label_x:FlxText;
	public var label_y:FlxText;
	public var label_z:FlxText;

	public var text_x:FlxTextField;
	public var text_y:FlxTextField;
	public var text_z:FlxTextField;

	public var blocks_x:Int = 1;
	public var blocks_y:Int = 1;
	public var blocks_z:Int = 1;
        
    override public function create():Void {
        super.create();
        

    }

    override public function update(elapsed:Float):Void {
        super.update(elapsed);
        

    }
}