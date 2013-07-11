package;

import org.flixel.*;
import org.flixel.util.*;
import tmx.*;

class MjM {
    // it's name was a tribute to ZDooM's MapInfo


    static public var scene_current:Int = 1;
 	static public var map_current:Int = 1;
    static public var map_tmx:TmxMap;
    static public var map_flx:FlxTilemap;
    static public var map_events:TmxObjectGroup;

    static private var script_counter:Int;

    static public function initialise():Void {

        var fm:String = 'assets/maps/${map_fcurrent()}.tmx';            // File Map
        var ft:String = 'assets/maps/${scene_fcurrent()}-tiles.png';    // File Tiles

        map_tmx = new TmxMap(openfl.Assets.getText(fm));
        map_flx = new FlxTilemap();

        map_flx.loadMap(

            map_tmx.getLayer('main').toCsv(map_tmx.getTileSet('main')),
            ft,
            16,
            16,
            FlxTilemap.OFF,
            0,
            0,
            24
        );

        map_events = map_tmx.getObjectGroup("events");
    }

    static public function level_next():Void {

        map_current++;
        level_restart();
    }

    static public function level_prev():Void {

        map_current--;
        level_restart();
    }

    static public function level_restart():Void {

        FlxG.switchState(new PlayState());
    }

    static public function scene_fcurrent():String {

        if (scene_current==0 || scene_current==44) return 't1';

        return 's${scene_current}';
    }

    static public function map_fcurrent():String {

        if (scene_current==0) scene_current = 44;
    	if (map_current==0) map_current = 1;

        if (scene_current==44) return 't1s${map_current}';

    	return 's${scene_current}m${map_current}';
    }

    static public function map_start():Void {

        script_counter = 0;

       // if (map_current==3) T1M3_start();
    }

	static public function map_activate(?tag:Int):Void {

		if (map_current==1) T1M1_active();
		if (map_current==2) T1M2_active(tag);
	}
















    // // // // // // // // //

    //      Map scripts

    //

    static private function T1M3_start():Void {
       
    }

	static private function T1M2_active(tag:Int):Void {

        if (tag==21) null;//MjG.activateEvents(11, 2);

        if (tag==22) null;//MjG.activateEvents(11, 1);

        if (tag==1 && script_counter==0) {

            script_counter++;
            null;//MjG.getEventByTag(21).active = false;
            null;//MjG.getEventByTag(22).active = false;
            null;//MjG.activateEvents(11, 2);
            null;//MjG.activateEvents(12, 2);
            var delay = new FlxTimer();
            delay.start(7, 1,
                function (x) {

                    null;//MjG.getEventByTag(21).active = true;
                    null;//MjG.getEventByTag(22).active = true;
                    null;//MjG.getEventByTag(1).reset_event();
                    null;//MjG.activateEvents(11, 1);
                    null;//MjG.activateEvents(12, 1);
                    script_counter--;
                }
            );
        }
	}

	static private function T1M1_active():Void {

		script_counter++;
		if (script_counter==2) {

			null;//MjG.activateEvents(3);
            null;//MjG.getEvent("exit").active = true;
		}
	}
}