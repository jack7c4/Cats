package; // not in map, because no idea

import org.flixel.*;
import org.flixel.util.*;
import map.*;
import obj.*;

class MjM {
    // yes, its name is a tribute to ZDooM


    static public var currentScene:Int = 1;
 	static public var currentMap:Int = 1;

    static private var counter:Int;

    static public function initialise():Void { // called at end of playstate

    	//FlxG.log("Reading MapInfo...");

    	// Find out what level
    	if (currentMap==0) currentMap = 1;

    	// Reset all variables
    	counter = 0;
    }

    static public function nextLevel():Void {

        currentMap++;
        restartLevel();
    }

    static public function prevLevel():Void {

        currentMap--;
        restartLevel();
    }

    static public function getCurrentScene():String {

        if (currentScene==0 || currentScene==44) return 't1';

        return 's${currentScene}';
    }

    static public function getCurrentMap():String {

        if (currentScene==0) currentScene = 44;
    	if (currentMap==0) currentMap = 1;

        if (currentScene==44) return 't1s${currentMap}';

    	return 's${currentScene}m${currentMap}';
    }

    static public function restartLevel():Void {

    	FlxG.switchState(new PlayState());
    }

    static public function startEvents():Void {

       // if (currentMap==3) T1M3_start();
    }

	static public function activateEvents(?tag:Int):Void {

		if (currentMap==1) T1M1_active();
		if (currentMap==2) T1M2_active(tag);
	}


    // Map scripts

    static private function T1M3_start():Void {
       
    }

	static private function T1M2_active(tag:Int):Void {

        if (tag==21) MjG.activateEvents(11, 2);

        if (tag==22) MjG.activateEvents(11, 1);

        if (tag==1 && counter==0) {

            counter++;
            MjG.getEventByTag(21).active = false;
            MjG.getEventByTag(22).active = false;
            MjG.activateEvents(11, 2);
            MjG.activateEvents(12, 2);
            var delay = new FlxTimer();
            delay.start(7, 1,
                function (x) {

                    MjG.getEventByTag(21).active = true;
                    MjG.getEventByTag(22).active = true;
                    MjG.getEventByTag(1).reset_event();
                    MjG.activateEvents(11, 1);
                    MjG.activateEvents(12, 1);
                    counter--;
                }
            );
        }
	}

	static private function T1M1_active():Void {

		counter++;
		if (counter==2) {

			MjG.activateEvents(3);
            MjG.getEvent("exit").active = true;
		}
	}
}