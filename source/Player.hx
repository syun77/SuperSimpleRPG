package ;

import flixel.FlxBasic;
import flixel.FlxObject;
import flixel.FlxG;
import flixel.FlxSprite;

/**
 * プレイヤー
 **/
class Player extends FlxSprite {

    public function new(px:Float, py:Float) {
        super(px, py);

        // 画像ファイルを読み込み
        loadGraphic("assets/images/miku.png", true);

        // アニメーションを登録
        animation.add("standby", [0, 0, 0, 0, 0, 2, 0, 0, 0, 2], 6);
        animation.add("walk", [0, 1], 6);
        animation.add("miss", [3]);

        // アニメーションを再生
        animation.play("standby");
    }

    /**
     * 更新
     **/
    override function update():Void {

        super.update();

        velocity.set(0, 0);
        var speed:Float = 30;
        if(FlxG.keys.pressed.LEFT) {
            velocity.x = -speed;
            flipX = true;
        }
        else if(FlxG.keys.pressed.UP) {
            velocity.y = -speed;
        }
        else if(FlxG.keys.pressed.RIGHT) {
            velocity.x = speed;
            flipX = false;
        }
        else if(FlxG.keys.pressed.DOWN) {
            velocity.y = speed;
        }

        if(velocity.x != 0 || velocity.y != 0) {
            animation.play("walk");
        }
        else {
            animation.play("standby");
        }
    }
}
