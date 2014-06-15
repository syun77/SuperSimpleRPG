package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;

/**
 * タイトル画面
 */
class MenuState extends FlxState {

    private var _txTitle:FlxText;
    private var _txPresskey:FlxText;
    private var _txCopyright:FlxText;

    private var _timer:Int = 0;
    /**
	 * 生成
	 */
    override public function create():Void {
        super.create();

        // セーブデータをロード
        Reg.load();

        _txTitle = new FlxText(0, 80, FlxG.width, 16);
        _txTitle.alignment = "center";
        _txTitle.text = "Super Simple RPG";
        _txPresskey = new FlxText(0, FlxG.height/2+16, FlxG.width, 8);
        _txPresskey.alignment = "center";
        _txPresskey.text = "Start to press Z or Space";
        _txCopyright = new FlxText(0, FlxG.height-32, FlxG.width, 6);
        _txCopyright.alignment = "center";
        _txCopyright.text = "(C)2014 2dgames.jp";
        add(_txTitle);
        add(_txPresskey);
        add(_txCopyright);
    }

    /**
	 * 破棄
	 */
    override public function destroy():Void {
        super.destroy();
    }

    /**
	 * 更新
	 */
    override public function update():Void {
        super.update();

        _timer++;
        _txPresskey.visible = (_timer%80 < 60);

        if(FlxG.keys.anyJustPressed(["Z", "SPACE"])) {
            FlxG.switchState(new PlayState());
        }
    }
}