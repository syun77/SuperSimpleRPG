package ;
import flixel.group.FlxTypedGroup;
import flixel.util.FlxColor;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.FlxG;

/**
 * リトライメニュー
 **/
class MenuRetry extends FlxSprite{

    public static inline var SEL_RETRY = 0; // リトライする
    public static inline var SEL_TITLE = 1; // タイトルへ戻る
    public static inline var SEL_CANCEL = 2; // キャンセル

    private var POS_Y = 64;
    private var POS_DY = 12;

    private var _txCursor:FlxText;
    private var _texts:FlxTypedGroup<FlxText>;
    private var _cursor:Int;

    public function new() {
        var w = 64;
        super(0, FlxG.height/2 - w/2);
        var dispW = FlxG.width/4*3;
        makeGraphic(cast dispW, w, FlxColor.BLACK);
        alpha = 0.5;

        _texts = new FlxTypedGroup<FlxText>();
        var x = 64;
        var y = POS_Y;
        var dy = POS_DY;
        for(msg in ["RETRY", "BACK TO TITLE", "CANCEL"]) {
            var tx = new FlxText(x, y);
            tx.text = msg;
            _texts.add(tx);
            y += dy;
        }
        // カーソル
        _txCursor = new FlxText(x-12, 0);
        _txCursor.text = ">";
        _texts.add(_txCursor);

        // 非表示にする
        disappear();
    }

    /**
     * 子要素を登録
     **/
    public function addChild():Void {
        FlxG.state.add(_texts);
    }

    public function appear():Void {
        _texts.visible = true;
        _txCursor.visible = true;
        _cursor = SEL_CANCEL;
        revive();
    }

    public function disappear():Void {
        _texts.visible = false;
        _txCursor.visible = false;
        kill();
    }

    public function getSelected():Int {
        return _cursor;
    }

    override public function update():Void {
        super.update();

        if(FlxG.keys.justPressed("UP") {
            _cursor--;
            if(_cursor < 0) {
                _cursor = SEL_CANCEL;
            }
        }

        if(FlxG.keys.justPressed("DOWN")) {
            _cursor++;
            if(_cursor >= SEL_CANCEL) {
                _cursor = 0;
            }
        }

        _txCursor.y = POS_Y + POS_DY * _cursor;

        if(FlxG.keys.anyJustPressed(["SPACE", "Z"])) {
            disappear();
        }

        if(FlxG.keys.anyJustPressed(["SHIFT", "X"])) {
            _cursor = SEL_CANCEL;
            disappear();
        }

    }
}
