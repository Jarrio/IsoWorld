package system.entities;

//import system.constants.BasicTypes;
import system.constants.Map;
import system.helpers.Isometric;
import flixel.math.FlxPoint;
import flixel.FlxSprite;
import flixel.FlxG;
import haxe.ds.Vector;


class Basic extends FlxSprite {

    public var id:Int;
    //public var type:BasicTypes;

    public var WidthX:Float;
    public var WidthY:Float;    

    //New Implementation
    public var z:Float;

    public var IsoX:Int = 0;
    public var IsoY:Int = 0;
    public var IsoZ:Int = 0;

    public var Entity:String = null;

    public var MinX:Float;
    public var MaxX:Float;
    public var MinY:Float;
    public var MaxY:Float;
    public var MinZ:Float;
    public var MaxZ:Float;
    
    public var MinXRelative:Int;
    public var MaxXRelative:Int;
    public var MinYRelative:Int;
    public var MaxYRelative:Int;
    public var MinZRelative:Int;
    public var MaxZRelative:Int;

    //Sorting Variables
    public var IsoDepth:Int;
    public var IsoSpritesBehind:Array<Basic>;
    public var IsoVisitedFlag:Bool;

    public var PositionChanged:Bool = true;
    
    public function new() {
        super();

    }

    public function set_iso_coords(_x:Null<Int> = null, _y:Null<Int> = null, _z:Null<Int> = null):Void {
        if ((_x != null) && (_y != null) && (_z != null)) {
            this.IsoX = _x;
            this.IsoY = _y;
            this.IsoZ = _z;            
        }

        
        var point = Isometric.TwoDToIso(new FlxPoint(IsoX, IsoY), IsoZ);        
        this.z = (IsoZ * 2) * Map.BASE_TILE_HALF_HEIGHT;
        this.x = point.x;
        this.y = point.y;
        
    }


    public function set_z_coords() {
        var point = this.y - (IsoZ * 2);
        y = point;
    }

    public function return_debug_values(?_class:String):String {
        var array:Array<String> = new Array<String>();
        // array.push('MinXRelative: ${MinXRelative}');
        // array.push('MaxXRelative: ${MaxXRelative}');
        // array.push('MinYRelative: ${MinYRelative}');
        // array.push('MaxYRelative: ${MaxYRelative}');
        // array.push('MinZRelative: ${MinZRelative}');
        // array.push('MaxZRelative: ${MaxZRelative}');

        array.push('MinX: ${MinX}');
        array.push('MaxX: ${MaxX}');
        array.push('MinY: ${MinY}');
        array.push('MaxY: ${MaxY}');
        array.push('MinZ: ${MinZ}');
        array.push('MaxZ: ${MaxZ}');        
        
        array.push('IsoDepth: ${IsoDepth}');
        array.push('IsoVisitedFlag: ${IsoVisitedFlag}');

        var data:String = _class + "\n";
        for (i in 0...array.length) {
            data += array[i] + "\n";
        }

        return data;
    }
}