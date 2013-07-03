package;

import org.flixel.*;
import org.flixel.util.*;
import tmx.*;

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

class Actor extends Event {

    public static inline var IDLE:Int 		= 2;
    public static inline var SEEK:Int 		= 3;
    public static inline var PATROL:Int     = 5;
    public static inline var SHOOT:Int      = 7;

	var states:Array<Array<Frame>>;
    var target:Dynamic;
    var speed_walk:Int = 40;

    override public function new(x:Int, y:Int, o:TmxObject):Void {

    	super(x, y, o);
    	
        t_addTestStateData();

        target = MjG.getPlayer();

        state = IDLE;

        FlxG.watch(this, "state");
        FlxG.watch(this, "fp");
        FlxG.watch(this, "state");
    }

    var dp:Int;     // (duration pointer)   position of time against the frame's duration
    var dl:Int;     // (duration last)      the current frame's duration
                    // the current state is defined in MapEvent.state:Int (Ai extends ObjMain which extends MapEvent)
    var fp:Int;     // (frame pointer)      position of curret state's next frame
    var fl:Int;     // (frame last)         position of current state's last frame

    override public function update():Void {

        velocity.x = 0;
        velocity.y = 0;

        if (dp==dl) {

            dp = 0;
            
            move_stop();
            var f = states[state][fp];
            
            play(f.animation);
            dl = f.duration *5;

            if (fp==fl) {

                fp = 0;
                if (state==SHOOT) state_change(SEEK);
            }
            
            else fp++;

            f.action();
        }

        else dp++;

        move_update();
        super.update();
    }



    var move_target:FlxPoint;
    var move_hitCall:Void -> Void;

    function move_atTarget(distance:Int = 8):Bool {

        if (move_stopped()) return true;

        else if (FlxMath.getDistance(this.getMidpoint(), move_target) < distance) {

            if (move_hitCall==null) return true;

            move_hitCall();
            move_hitCall = null;            
            return true;
        }

        else return false;
    }

    function move_update():Void {

        if (move_stopped()) return;

        if (move_atTarget()) return;

        velocity = MjG.calculateVelocity(this.getMidpoint(), move_target, speed_walk);
    }

    function move_stopped():Bool {

        return move_target == null;
    }

    function move_stop():Void {

        move_target = null;
    }

    function t_addTestStateData():Void {

        states = [];
        states[IDLE] = [];
        states[SEEK] = [];
        states[SHOOT] = [];

        state = IDLE;
        f_add("stand", 8, idle_look);

        state = SEEK;
        f_add("walk", 8, seek_target);

        state = SHOOT;
        f_add("aim", 12, shoot_prepare);
        f_add("shoot", 8, shoot_attack);
    }

    function f_add(animation:String, duration:Int, action:Void -> Void, ?state:Null<Int>):Void {

        if (state==null) state = this.state;

        states[state].push(new Frame(animation, duration, action));
    }

    function state_change(state:Int) {

        this.state = state;
        dp = 0;
        dl = 0;
        fp = 0;
        fl = states[state].length -1;
    }




    // Action functions

    function idle_look():Void {

        if (FlxMath.getDistance(target.getMidpoint(), this.getMidpoint())<128) {

            state_change(SEEK);
        }
    }

    function seek_target():Void {

        move_target = target.getMidpoint();

        if (move_atTarget(64)) state_change(SHOOT);
    }


    var shoot_target:FlxPoint;

    function shoot_prepare():Void {
    
        shoot_target = target.getMidpoint();
    }

    function shoot_attack():Void {

        var bullet = MjG.spawnObject(MjE.PRJ_RED, this.x, this.y);
        //trace(bullet);
        bullet.velocity = MjG.calculateVelocity(this.getMidpoint(), shoot_target, 320);
    }

}