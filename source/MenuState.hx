package;

import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.FlxState;
import flixel.text.FlxText;

/**
 * タイトル画面
 */
class MenuState extends FlxState {

    private var _txTitle:FlxText;
    private var _txPresskey:FlxText;
    private var _txCopyright:FlxText;
    private var _txSelect:FlxText;

    private var _timer:Int = 0;
    private var _max:Int = 0;
    private var _bSelect:Bool = false;
    /**
	 * 生成
	 */
    override public function create():Void {

        FlxG.sound.volume = 1;

        super.create();

        bgColor = FlxColor.BLACK;

        // セーブデータをロード
        Reg.load();
        Reg.stage = Reg.stageMax;

        var bg = new FlxSprite(0, 0);
        bg.loadGraphic("assets/images/title.png");
        add(bg);
        _txPresskey = new FlxText(0, FlxG.height/2+48, FlxG.width, 12);
        _txPresskey.alignment = "center";
        _txPresskey.color = FlxColor.WHITE;
        _txPresskey.borderStyle = FlxText.BORDER_OUTLINE;
        _txPresskey.text = "Start to press Z or Space";
        _txCopyright = new FlxText(0, FlxG.height-16, FlxG.width, 8);
        _txCopyright.alignment = "center";
        _txCopyright.color = FlxColor.WHITE;
        _txCopyright.borderStyle = FlxText.BORDER_OUTLINE;
        _txCopyright.text = "(C)2014 2dgames.jp";
        add(_txPresskey);
        add(_txCopyright);

        _max = Reg.stageMax;
        if(_max > 1) {
            // ステージ2以上をクリアしている
            _bSelect = true; // ステージセレクト可能
            _txSelect = new FlxText(0, FlxG.height/2+16, FlxG.width, 12);
            _txSelect.alignment = "center";
            _txSelect.borderStyle = FlxText.BORDER_OUTLINE;
            _txSelect.color = FlxColor.YELLOW;
            add(_txSelect);
        }
        else {
            _bSelect = false;
        }
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

        if(_bSelect) {
            _txSelect.text = "SELECT STAGE < " + Reg.stage + "/" + Reg.stageMax + " >";
            if(FlxG.keys.justPressed.LEFT) {
                FlxG.sound.play("pi");
                Reg.stage--;
                if(Reg.stage <= 0) {
                    Reg.stage = Reg.stageMax;
                }
            }
            if(FlxG.keys.justPressed.RIGHT) {
                FlxG.sound.play("pi");
                Reg.stage++;
                if(Reg.stage > Reg.stageMax) {
                    Reg.stage = 1;
                }
            }
        }

        _timer++;
        _txPresskey.visible = (_timer%80 < 60);

        if(FlxG.keys.anyJustPressed(["Z", "SPACE"])) {
            FlxG.sound.play("push");
            if(_bSelect) {

            }
            else {
                // ステージ数を初期化
                Reg.resetStage();
            }
            FlxG.switchState(new PlayState());
        }
    }
}