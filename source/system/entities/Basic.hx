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
    public var HeightZ:Float;    

    public var Top:Float;
    public var Bottom:Float;
    public var FrontX:Float;
    public var FrontY:Float;
    
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
    public var AltDepth:Float;
    public var IsoSpritesBehind:Array<Basic> = new Array<Basic>();
    public var IsoVisitedFlag:Bool;

    public var PositionChanged:Bool = true;
    
    
    public function new() {
        super();

    }

    public function set_iso_coords(_x:Null<Int> = null, _y:Null<Int> = null, _z:Null<Int> = null):Void {
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