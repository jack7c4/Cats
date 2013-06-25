package map;

import openfl.Assets;
import org.flixel.*;
import tmx.*;

class MapEvent extends FlxSprite {

	public var name:String;
    public var tag:Int;
    public var properties:Map<String, String>;
    public var gid:Int;
    public var state:Int;

    override private function new(x, y, o) {

        gid = o.gid;
        name = o.name;
        properties = o.custom.data;
        tag = Std.parseInt(properties["tag"]);
        
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