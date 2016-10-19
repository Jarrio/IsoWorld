package system.entities;

//import system.constants.BasicTypes;
import system.constants.Map;
import system.helpers.Isometric;
import flixel.math.FlxPoint;
import flixel.FlxSprite;
import flixel.FlxG;
import haxe.ds.Vector;
import hxmath.math.Vector3;


class Basic extends FlxSprite {

    public var id:Int;
    //public var type:BasicTypes;

    public var WidthX:Float = 0;
    public var WidthY:Float = 0;    
    public var HeightZ:Float = 0;    

    public var Top:Float = 0;
    public var Bottom:Float = 0;
    public var FrontX:Float = 0;
    public var FrontY:Float = 0;
    
//    @:isVar
    public var BackX(default, set):Float;
  //  @:isVar
    public var BackY(default, set):Float;

    function set_BackX(value:Float) {

        if (value >= this.FrontX) {
            this.WidthX = 0;
        } else {
            this.WidthX = (this.FrontX - value);
        }

        return this.BackX = value;
    }

    function set_BackY(value:Float) {
        if (value >= this.FrontY) {
            this.WidthY = 0;
        } else {
            this.WidthY = (this.FrontY - value);
        }

        return this.BackY = value;
    }    


    public var CheckX:Float;
    public var CheckY:Float; 
    public var CheckZ:Float;

    public var Anchor:FlxPoint = new FlxPoint(0.5, 0);  
    
    public var HalfWidthX:Int;
    public var HalfWidthY:Int;

    public var Moved:Bool = true;

    //New Implementation
    public var z:Float = 0;

    public var IsoX:Float;
    public var IsoY:Float;
    public var IsoZ:Float;

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
    public var AltDepth:Float;
    public var IsoSpritesBehind:Array<Basic> = new Array<Basic>();
    public var IsoVisitedFlag:Bool;

    public var ToggleCollision:Bool = false;
    public var Colliding:Bool = false;

    public var PositionChanged:Bool = true;
    
    
    public function new() {
        super();

    }

    public var collide_int:Int = 0; 
    public function set_iso_coords(_x:Null<Float> = null, _y:Null<Float> = null, _z:Null<Float> = null):Void {
        Moved = true;
        
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

    public function check_overlap_vector(object:Vector3):Bool {
        if (object.x < this.FrontX && object.y < this.BackY && object.z < this.Top) {
            return true;
        }

        return false;        
    }

    public function check_overlap_basic(object:Basic):Bool {
        if (object.BackX < this.FrontX && object.BackY < this.FrontY && object.IsoZ < this.Top) {
            trace('Collided: ${Entity} - ${collide_int++}');
            return true;
        }

        return false;
    }


    public function return_debug_values(?_class:String):String {
        var array:Array<String> = new Array<String>();
        // array.push('MinXRelative: ${MinXRelative}');
        // array.push('MaxXRelative: ${MaxXRelative}');
        // array.push('MinYRelative: ${MinYRelative}');
        // array.push('MaxYRelative: ${MaxYRelative}');
        // array.push('MinZRelative: ${MinZRelative}');
        // array.push('MaxZRelative: ${MaxZRelative}');

        // array.push('MinX: ${MinX}');
        // array.push('MaxX: ${MaxX}');
        // array.push('MinY: ${MinY}');
        // array.push('MaxY: ${MaxY}');
        // array.push('MinZ: ${MinZ}');
        // array.push('MaxZ: ${MaxZ}');        
        
        // array.push('IsoDepth: ${IsoDepth}');
        // array.push('IsoVisitedFlag: ${IsoVisitedFlag}');

        array.push('WidthX: ${WidthX}');
        array.push('WidthY: ${WidthY}');
        array.push('HeightZ: ${HeightZ}');
        array.push('Top: ${Top}');
        array.push('Bottom: ${Bottom}');
        array.push('FrontX: ${FrontX}');
        array.push('FrontY: ${FrontY}');
        array.push('BackX: ${BackX}');
        array.push('BackY: ${BackY}');
        array.push('HalfWidthX: ${HalfWidthX}');
        array.push('HalfWidthY: ${HalfWidthY}');
        
        array.push('CheckX: ${CheckX}');
        array.push('CheckY: ${CheckY}');
        array.push('CheckZ: ${CheckZ}');

        var data:String = _class + "\n";
        for (i in 0...array.length) {
            data += array[i] + "\n";
        }

        return data;
    }
}