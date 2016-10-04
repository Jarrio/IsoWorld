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
    public var IsoX:Int;
    public var IsoY:Int;
    public var IsoZ:Int;

    public var MinX:Int;
    public var MaxX:Int;
    public var MinY:Int;
    public var MaxY:Int;
    public var MinZ:Int;
    public var MaxZ:Int;
    
    public var MinXRelative:Int;
    public var MaxXRelative:Int;
    public var MinYRelative:Int;
    public var MaxYRelative:Int;
    public var MinZRelative:Int;
    public var MaxZRelative:Int;

    //Sorting Variables
    public var IsoDepth:Int;
    public var IsoSpritesBehind:Vector<Basic>;
    public var IsoVisitedFlag:Int;

    public function new(x:Float, y:Float, graphic:String) {
        super(x, y, graphic);
    }

    public function set_iso_coords(x:Int, y:Int, z:Int) {
        this.IsoX = x;
        this.IsoY = y;
        this.IsoZ = z;
    }
}