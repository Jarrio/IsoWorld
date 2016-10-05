package system.entities;
import flixel.FlxSprite;
import system.constants.BasicTypes;
import haxe.ds.Vector;


class Basic extends FlxSprite {
    public var z:Int;
    public var id:Int;
    public var type:BasicTypes;
    public var depth:Float;

    //New Implementation
    public var IsoX:Float;
    public var IsoY:Float;
    public var IsoZ:Float;

    public var MinX:Float;
    public var MaxX:Float;
    public var MinY:Float;
    public var MaxY:Float;
    public var MinZ:Float;
    public var MaxZ:Float;
    
    public var MinXRelative:Float;
    public var MaxXRelative:Float;
    public var MinYRelative:Float;
    public var MaxYRelative:Float;
    public var MinZRelative:Float;
    public var MaxZRelative:Float;

    //Sorting Variables
    public var IsoDepth:Int;
    public var IsoSpritesBehind:Array<Basic> = new Array<Basic>();
    public var IsoVisitedFlag:Int;

    public function set_iso_coords(x:Float, y:Float, z:Float) {
        this.IsoX = x;
        this.IsoY = y;
        this.IsoZ = z;
    }
}