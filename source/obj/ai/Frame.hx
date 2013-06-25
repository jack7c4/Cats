package obj.ai;

import org.flixel.*;
import tmx.*;
import map.*;

class Frame {

	public var animation:String;
	public var duration:Int;
	public var action:Void -> Void;

	public function new(animation:String, duration:Int, action:Void -> Void):Void {

		this.animation = animation;
		this.duration = duration;
		this.action = action;
	}

}