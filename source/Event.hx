package;

import org.flixel.*;

class Event extends FlxSprite {

    public var name:String;
    public var tag:Int;
    public var gid:Int;
    public var state:Int;
    public var action:String;
    public var method:String;
    public var repeat:Bool;

    override private function new(x, y, o) {

        gid = o.gid;
        
        MjE.switchProperties(this, o.custom.data);
        
        active = false;
        alive = false;
        exists = false;
        immovable = true;

        super(x, y);
    }

    public function activate(state:Int = 0):Void {};

    override public function kill():Void {

        alive = false;
        exists = false;
        active = false;
    }
}