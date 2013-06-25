package obj;

import openfl.Assets;
import org.flixel.*;
import org.flixel.util.*;
import tmx.*;

class ObjT1_vdoor_bottom extends ObjMain {

    static inline public var STATE_OPEN     = 1;
    static inline public var STATE_CLOSE    = 2;
    static inline public var STATE_LOCK     = 3;

    override public function new(o:TmxObject):Void {

        super(o.x+2, o.y-4, o);

        loadGraphic("assets/sprites/t1vdoor_bottom.png", true, false, 16, 72);
        addAnimation("open", [0]);
        addAnimation("close", [1]);

        offset.x = 2;
        width = 12;
        immovable = true;

        state = STATE_OPEN;
        play("open");
        offset.y = 68;
        height = 4;

        state_close();

        //if (Std.parseInt(properties["state"])==STATE_CLOSE) state_close();
    }

    override public function activate(state:Int = 0):Void {

       // if (state==STATE_LOCK) return;

        if (state!=0) if (this.state!=state) return;

        if (this.state==STATE_OPEN) state_close();
        else state_open();
    }

    override public function reset(x:Float, y:Float):Void {

        if (state!=STATE_CLOSE) state_close();
    }

    private function state_close():Void {

        if (state==STATE_CLOSE) return;

        y -= 44;
        offset.y = 24;
        height = 48;
        play("close");
        state = STATE_CLOSE;
    }

    private function state_open():Void {
        
        if (state==STATE_OPEN) return;

        y += 44;
        offset.y = 68;
        height = 4;
        play("open");
        state = STATE_OPEN;

        if (properties["repeat"]=="1") {

            var delay = new FlxTimer();
            delay.start(5, 1, function (a:FlxTimer) { reset(x, y); });
            return;
        }
    }

    private function state_lock():Void {

        if (state==STATE_OPEN) state_close();
        state = STATE_LOCK;
    }
}