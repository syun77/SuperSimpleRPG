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
    public function init(px:Float, py:Float):Void {
        x = px;
        y = py;
    }

    /**
     * 消滅する
     **/
    public function vanish():Void {
        kill();
    }
}
