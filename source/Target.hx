package;

import openfl.Assets;
import org.flixel.*;
import tmx.*;

class Target extends Event {

	override public function new(o:TmxObject):Void {

		//initialise(o);
        super(o.x +6, o.y -10, o);

        makeGraphic(4, 4, 0x88000088);

        allowCollisions = 0;
	}

	override public function activate(state:Int = 0):Void {

		if (!active) return;
		
		if (action=="switch") MjG.switchTile(getMidpoint(), 1);

		kill();
	}
}