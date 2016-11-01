package system.constants;

class AllowCollisions {
    public var none:Bool = false;
    public var any:Bool = true;
    public var up:Bool = true;
    public var down:Bool = true;
    public var front_x:Bool = true;
    public var front_y:Bool = true;
    public var back_x:Bool = true;
    public var back_y:Bool = true;
    
    public function new(){}
}

class Touching {
    public var none:Bool = true;
    public var up:Bool = false;
    public var down:Bool = false;
    public var front_x:Bool = true;
    public var front_y:Bool = true;
    public var back_x:Bool = true;
    public var back_y:Bool = true;

    public function new(){}
}

class PreviousTouching {
    public var none:Bool = true;
    public var up:Bool = false;
    public var down:Bool = false;
    public var front_x:Bool = true;
    public var front_y:Bool = true;
    public var back_x:Bool = true;
    public var back_y:Bool = true;

    public function new(){}
}

class Blocked {
    public var up: Bool = false;
    public var down: Bool = false;
    public var front_x:Bool = true;
    public var front_y:Bool = true;
    public var back_x:Bool = true;
    public var back_y:Bool = true;

    public function new(){}
}