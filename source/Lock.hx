package ;

import flixel.FlxSprite;

/**
 * カギで壊すことができる錠
 **/
class Lock extends FlxSprite {
    public function new() {
        super(-100, -100);
        loadGraphic("assets/images/lock.png");
        kill();
    }

    /**
     * 生成
     **/
    public function init(px:Float, py:Float) {
        x = px;
        y = py;
    }
}
