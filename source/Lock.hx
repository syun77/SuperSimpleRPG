package ;

import flixel.FlxG;
import flixel.group.FlxTypedGroup;
import flixel.FlxSprite;

/**
 * カギで壊すことができるロック
 **/
class Lock extends FlxSprite {
    public static var s_effects:FlxTypedGroup<ParticleLock>;

    public function new() {
        super(-100, -100);
        loadGraphic("assets/images/lock.png");
    }

    /**
     * 生成
     **/
    public function init(px:Float, py:Float):Void {
        x = px;
        y = py;
    }

    /**
     * 消滅する
     **/
    public function vanish():Void {
        var p:ParticleLock = s_effects.recycle(ParticleLock);
        p.init(x, y);
//        p.init(x+width/2, y+height/2);

        kill();
        FlxG.sound.play("destroy");
    }
}
