package ;
import flixel.util.FlxRandom;
import flixel.FlxSprite;

/**
 * ロックの破壊エフェクト
 **/
class ParticleLock extends FlxSprite {

    private static inline var TIMER_DESTROY = 90;
    private var _timer:Int;

    public function new() {
        super();
        loadGraphic("assets/images/lock.png");
    }

    public function init(px:Float, py:Float) {
        x = px;
        y = py;
        angle = 0;
        _timer = TIMER_DESTROY;
        velocity.set(FlxRandom.floatRanged(-50, 50), -50);
        acceleration.y = 100;
    }

    override public function update():Void {
        super.update();

        velocity.x *= 0.98;
        angle += 3;

        _timer--;
        visible = (_timer%4 < 2);

        if(_timer < 1) {
            kill();
        }
    }
}
