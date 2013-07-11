package;

import openfl.Assets;
import flash.geom.Rectangle;
import flash.net.SharedObject;
import org.flixel.*;
import tmx.*;
import map.*;
import obj.*;

class PlayState extends FlxState {

	override public function create():Void {

		#if !neko
		FlxG.bgColor = 0xff131c1b;
		#else
		//FlxG.camera.bgColor = {rgb: 0x131c1b, a: 0xff};
		#end		
		#if !FLX_NO_MOUSE
		//FlxG.mouse.show();
		#end

		super.create();

		MjM.initialise();		// Map
		MjE.initialise();		// Entities
		MjG.initialise();		// Game
	}
	
	override public function destroy():Void {

		super.destroy();
	}

	override public function update():Void {

		if (FlxG.keys.justPressed("ENTER")) 	MjM.level_restart();
		else if (FlxG.keys.justPressed("P")) 	MjM.level_next();
		else if (FlxG.keys.justPressed("O")) 	MjM.level_prev();

		super.update();
		MjG.update();
	}
}