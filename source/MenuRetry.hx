package ;
import flixel.util.FlxColor;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.FlxG;

/**
 * リトライメニュー
 **/
class MenuRetry extends FlxSprite{

    private var _text:FlxText;
    private var _text2:FlxText;
    // リトライするかどうか
    private var _bRetry:Bool;

    public function new() {
        var w = 64;
        super(0, FlxG.height/2 - w/2);
        var dispW = FlxG.width/4*3;
        makeGraphic(cast dispW, w, FlxColor.BLACK);
        alpha = 0.5;

        _text = new FlxText(0, FlxG.height/2 - w/4, dispW);
        _text.alignment = "center";
        _text.size = 10;
        _text.text = "Give up to press Z or Space.";
        _text2 = new FlxText(0, FlxG.height/2 + w/4, dispW);
        _text2.alignment = "center";
        _text2.text = "(cancel to press X or Shift.)";

        _bRetry = false;

        // 非表示にする
        disappear();
    }

    public function isRetry():Bool { return _bRetry; }

    /**
     * 子要素を登録
     **/
    public function addChild():Void {
        FlxG.state.add(_text);
        FlxG.state.add(_text2);
    }

    public function appear():Void {
        _text.visible = true;
        _text2.visible = true;
        _bRetry = false;
        revive();
    }

    public function disappear():Void {
        _text.visible = false;
        _text2.visible = false;
        kill();
    }

    override public function update():Void {
        super.update();

        if(FlxG.keys.anyJustPressed(["SPACE", "Z"])) {
            disappear();
            _bRetry = true; // リトライする
        }

        if(FlxG.keys.anyJustPressed(["SHIFT", "X"])) {
            disappear();
            _bRetry = false; // リトライしない
        }
    }
}
