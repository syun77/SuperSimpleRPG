package ;

import flixel.util.FlxColor;
import flixel.text.FlxText;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;

/**
 * 全ステージクリア画面
 **/
class EndingState extends FlxState {

    private var _spr:FlxSprite;
    private var _text:FlxText;
    private var _text2:FlxText;

    /**
     * 生成
     **/
    override public function create():Void {

        bgColor = FlxColor.BLACK;

        _spr = new FlxSprite(-32, FlxG.height/2);
        _spr.loadGraphic("assets/images/miku.png", true);
        _spr.animation.add("play", [0, 1], 9);
        _spr.animation.play("play");
        _spr.velocity.x = 100;
        add(_spr);

        _text = new FlxText(0, FlxG.height/2-12*4, FlxG.width, 24);
        _text.alignment = "center";
        _text.text = "Congratulation!!";
        add(_text);
        _text2 = new FlxText(0, FlxG.height/2+24, FlxG.width, 12);
        _text2.alignment = "center";
        _text2.text = "All stage clear";
        add(_text2);


        super.create();
    }

    /**
     * 破棄
     **/
    override public function destroy():Void {
        super.destroy();
    }

    /**
     * 更新
     **/
    override public function update():Void {
        super.update();

        if(_spr.x > FlxG.width) {
            // おしまい
            FlxG.switchState(new MenuState());
        }
    }
}
