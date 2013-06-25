package;

import flash.Lib;
import org.flixel.FlxGame;
	
class ProjectClass extends FlxGame {

	public function new():Void {

		super(240, 160, PlayState, 4, 60, 60); // w, h, state, pixel zoom, update (default 60), framerate (default 30)
	}
}
