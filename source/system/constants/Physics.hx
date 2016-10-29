package system.constants;

class AllowCollisions {
    public var none:Bool = false;
    public var any:Bool = true;
    public var up:Bool = true;
    public var down:Bool = true;
    public var frontX:Bool = true;
    public var frontY:Bool = true;
    public var backX:Bool = true;
    public var backY:Bool = true;
    
    public function new(){}
}

class Touching {
    public var none:Bool = true;
    public var up:Bool = false;
    public var down:Bool = false;
    public var frontX:Bool = false;
    public var frontY:Bool = false;
    public var backX:Bool = false;
    public var backY:Bool = false;

    public function new(){}
}

class PreviousTouching {
    public var none:Bool = true;
    public var up:Bool = false;
    public var down:Bool = false;
    public var frontX:Bool = false;
    public var frontY:Bool = false;
    public var backX:Bool = false;
    public var backY:Bool = false;

    public function new(){}
}

class Blocked {
    public var up: Bool = false;
    public var down: Bool = false;
    public var frontX: Bool = false;
    public var frontY: Bool = false;
    public var backX: Bool = false;
    public var backY: Bool = false;

    public function new(){}
}