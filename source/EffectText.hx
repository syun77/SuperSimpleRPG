package ;

import flixel.FlxG;
import flixel.util.FlxColor;
import flixel.text.FlxText;

enum EffectTextMode {
    LevelUp; // レベルアップ
    Damage;  // ダメージ
    Recover; // 回復
}

/**
 * テキストエフェクト
 **/
class EffectText extends FlxText {

    public static inline var TIMER_DISP = 90;

    private var _mode:EffectTextMode;
    private var _timer:Int;
    private var _startY:Float;

    public function new() {
        super(-100, -100, 16);
        alignment = "center";
        borderStyle = FlxText.BORDER_OUTLINE_FAST;
        borderColor = FlxColor.WHITE;
        kill();
    }

    public function init(mode:EffectTextMode, px:Float, py:Float, val:Int=0):Void {
        x = px;
        y = py;
        _startY = y;
        _mode = mode;
        switch(mode) {
            case EffectTextMode.LevelUp:
                text = "Level up!";
                color = FlxColor.WHITE;
                velocity.y = -1;
            case EffectTextMode.Damage:
                text = "" + val;
                color = FlxColor.RED;
                velocity.y = -1.5;
                acceleration.y = 0.1;
            case EffectTextMode.Recover:
                text = "" + val;
                color = FlxColor.GREEN;
                velocity.y = -1;
        }
        _timer = TIMER_DISP;
    }

    override public function update():Void {
        velocity.y += acceleration.y;
        y += velocity.y;

        switch(_mode) {
            case EffectTextMode.Damage:
                if(y > _startY) {
                    velocity.y = 0;
                    acceleration.y = 0;
                }
            default:
        }

        if(_timer < 30) {
            visible = _timer%6 < 3;
        }

        _timer--;
        if(_timer < 1) {
            kill();
        }
    }
}
