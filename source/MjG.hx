package;

import org.flixel.FlxG;
import org.flixel.FlxState;
import org.flixel.FlxCamera;
import org.flixel.FlxBasic;

class MjG {



	static public function initialise():Void {

		FlxG.state.add(MjM.map_flx);
		FlxG.state.add(MjE.events);
		FlxG.state.add(MjE.actors);
		FlxG.state.add(MjE.players);

		for (e in MjE.events.members) {

			if (e != null && e.gid == MjE.PLAYER_START) {

				MjE.players.add(new Player(e.x, e.y));
				MjE.events.remove(e);
			}
		}

		FlxG.camera.setBounds(0, 0, MjM.map_flx.width, MjM.map_flx.height, true);
		FlxG.camera.follow(MjE.players.members[0], FlxCamera.STYLE_TOPDOWN_TIGHT);

		//trace(MjE.events);
	}

	static public function update():Void {
		
		FlxG.collide(MjE.actors, MjM.map_flx);
		FlxG.collide(MjE.players, MjM.map_flx);
		FlxG.collide(MjE.players, MjE.actors);
		FlxG.overlap(MjE.players, MjE.events, collide_player_events);
	}

	static function collide_player_events(gp:FlxBasic, ge:FlxBasic):Void {

		trace("touch");
	}
}