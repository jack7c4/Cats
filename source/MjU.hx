package;

import org.flixel.FlxG;
import org.flixel.FlxSprite;
import org.flixel.util.FlxPoint;

class MjU {



	static public function getDistanceV(s:FlxSprite, d:FlxSprite):Float {

		var sx:Float = s.x + s.velocity.x;
		var sy:Float = s.y + s.velocity.y;
		var dx:Float = d.x + d.velocity.x;
		var dy:Float = d.y + d.velocity.y;

		var dxv:Float = sx - dx;
		var dyv:Float = sy - dy;
		return Math.sqrt(dxv * dxv + dyv * dyv);
	}

	static public function getPosV(s:FlxSprite):FlxPoint {

		if (s == null) return null;

		var r:FlxPoint = s.getMidpoint();
		r.x += s.velocity.x;
		r.y += s.velocity.y;

		return r;
	}
}