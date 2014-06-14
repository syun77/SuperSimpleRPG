package ;

import flixel.FlxSprite;

/**
 * ゴール
 **/
class Goal extends FlxSprite {
    public function new(px:Float, py:Float) {
        super(px, py);
        loadGraphic("assets/images/goal.png", true);
        animation.add("play", [0, 1, 2, 3], 6);
        animation.play("play");
    }
}
