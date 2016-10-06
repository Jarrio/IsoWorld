package state;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.math.FlxMath;
import flixel.util.FlxColor;
import flixel.math.FlxPoint;

using flixel.util.FlxSpriteUtil;

class LightState extends FlxState {

	public var mouse_track:FlxSprite = new FlxSprite();

	public var polygon1:FlxSprite = new FlxSprite();
	public var polygon2:FlxSprite = new FlxSprite();
	public var ray_line:FlxSprite = new FlxSprite();
	public var ray_line1:FlxSprite = new FlxSprite();

	public var polygon4:FlxSprite = new FlxSprite();
	public var polygon5:FlxSprite = new FlxSprite();
	public var lineStyle:LineStyle = { color: FlxColor.RED, thickness: 1 };
	public var lineStyle1:LineStyle = { color: FlxColor.WHITE, thickness: 1 };
	override public function create():Void {
		super.create();	

		
		var drawStyle:DrawStyle = { smoothing: true };

		polygon1 = new FlxSprite(50, 210);
		polygon1.makeGraphic(FlxG.width, FlxG.height, FlxColor.TRANSPARENT, true);
		add(polygon1);

		var vertices = new Array<FlxPoint>();
		vertices[0] = new FlxPoint(100, 150);
		vertices[1] = new FlxPoint(120, 50);
		vertices[2] = new FlxPoint(120, 50);
		vertices[3] = new FlxPoint(200, 80);
		vertices[4] = new FlxPoint(200, 80);
		vertices[5] = new FlxPoint(140, 210);
		vertices[6] = new FlxPoint(140, 210);
		vertices[7] = new FlxPoint(100, 150);		
		polygon1.drawPolygon(vertices, FlxColor.WHITE, lineStyle, drawStyle);

		polygon2 = new FlxSprite();
		polygon2.makeGraphic(FlxG.width, FlxG.height, FlxColor.TRANSPARENT, true);
		add(polygon2);

		var vertices1 = new Array<FlxPoint>();
		vertices1[0] = new FlxPoint(100, 200);
		vertices1[1] = new FlxPoint(120, 250);
		vertices1[2] = new FlxPoint(120, 250);
		vertices1[3] = new FlxPoint(60, 300);
		vertices1[4] = new FlxPoint(60, 300);
		vertices1[5] = new FlxPoint(100, 200);	
		polygon2.drawPolygon(vertices1, FlxColor.WHITE, lineStyle, drawStyle);	

		ray_line = new FlxSprite();
		ray_line.makeGraphic(FlxG.width, FlxG.height, FlxColor.TRANSPARENT, true);
		add(ray_line);

		ray_line1 = new FlxSprite();
		ray_line1.makeGraphic(FlxG.width, FlxG.height, FlxColor.TRANSPARENT, true);
		add(ray_line1);		

		ray_line.drawLine(FlxG.width / 2, FlxG.height / 2, FlxG.mouse.x, FlxG.mouse.y, lineStyle);

		mouse_track.loadGraphic(AssetPaths.cursor2__png);
		add(mouse_track);			
	}

	override public function update(elapsed:Float):Void {
		super.update(elapsed);
		mouse_track.x = FlxG.mouse.x;
		mouse_track.y = FlxG.mouse.y;

		var closestIntersect = null;

		var intersect = getIntersection(point(FlxG.mouse.x, FlxG.mouse.y),point(polygon1.x, polygon1.y));
		if (closestIntersect == null || intersect[2] < closestIntersect[2]){
			closestIntersect = intersect;
		}

		ray_line1.drawLine(FlxG.width / 2, FlxG.height / 2, closestIntersect[0], closestIntersect[1], lineStyle);
	}

	public function point(x:Float, y:Float):FlxPoint {
		return new FlxPoint(x, y);
	}

	function getIntersection(ray:FlxPoint, segment:FlxPoint){
		// RAY in parametric: Point + Direction*T1
		var r_px = ray.x;
		var r_py = ray.y;
		var r_dx = ray.x-ray.x;
		var r_dy = ray.y-ray.y;
		// SEGMENT in parametric: Point + Direction*T2
		var s_px = segment.x;
		var s_py = segment.y;
		var s_dx = segment.x-segment.x;
		var s_dy = segment.y-segment.y;
		// Are they parallel? If so, no intersect
		var r_mag = Math.sqrt(r_dx*r_dx+r_dy*r_dy);
		var s_mag = Math.sqrt(s_dx*s_dx+s_dy*s_dy);
		if(r_dx/r_mag==s_dx/s_mag && r_dy/r_mag==s_dy/s_mag){ // Directions are the same.
			return null;
		}
		// SOLVE FOR T1 & T2
		// r_px+r_dx*T1 = s_px+s_dx*T2 && r_py+r_dy*T1 = s_py+s_dy*T2
		// ==> T1 = (s_px+s_dx*T2-r_px)/r_dx = (s_py+s_dy*T2-r_py)/r_dy
		// ==> s_px*r_dy + s_dx*T2*r_dy - r_px*r_dy = s_py*r_dx + s_dy*T2*r_dx - r_py*r_dx
		// ==> T2 = (r_dx*(s_py-r_py) + r_dy*(r_px-s_px))/(s_dx*r_dy - s_dy*r_dx)
		var T2 = (r_dx*(s_py-r_py) + r_dy*(r_px-s_px))/(s_dx*r_dy - s_dy*r_dx);
		var T1 = (s_px+s_dx*T2-r_px)/r_dx;
		// Must be within parametic whatevers for RAY/SEGMENT
		if(T1<0) return null;
		if(T2<0 || T2>1) return null;
		// Return the POINT OF INTERSECTION
		var array:Array<Float> = new Array<Float>();
		array[0] = r_px+r_dx*T1; // x
		array[1] = r_py+r_dy*T1; // y
		array[2] = T1;

		return array;

	}	
}
