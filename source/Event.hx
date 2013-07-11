package;

import org.flixel.*;
import tmx.TmxObject;

class Event extends FlxSprite {

    public var tag:Int;
    public var gid:Int;
    public var action:String;
    public var method:String;
    public var repeat:Bool;
    public var state:Int;

    override public function new(x:Float, y:Float, gid:Int, ?ps:Map<String, String>):Void {

    	super(x, y);

        this.gid = gid;
        
        properties_switch(ps);
    } 

    private function properties_switch(ps:Map<String, String>):Void {

        for (k in ps.keys()) {

            switch (k) {
                
                case "tag":     tag = Std.parseInt(ps[k]);
                case "action":  action = ps[k];
                case "method":  method = ps[k];
                case "repeat":  repeat = (ps[k]=="true") ? true : false;
                case "active":  active = (ps[k]=="true") ? true : false;
            }
        }
    }
}