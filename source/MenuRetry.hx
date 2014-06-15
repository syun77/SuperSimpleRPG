package ;
import flixel.group.FlxGroup;
import flixel.group.FlxSpriteGroup;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.FlxG;
import flixel.FlxState;

/**
 * リトライメニュー
 **/
class MenuRetry extends FlxGroup {

    public function new() {
        super();

        var text:FlxText = new FlxText(0, 0);
        text.text = "Retry Menu";
        add(text);

    }

    override public function update():Void {
        super.update();

        if(FlxG.keys.anyJustPressed(["SPACE", "Z"])) {
            kill();
            return;
        }

        if(FlxG.keys.anyJustPressed(["SHIFT", "X"])) {
            kill();
        }
    }
}
