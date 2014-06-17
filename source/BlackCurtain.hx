package ;

import flixel.group.FlxTypedGroup;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.FlxSprite;
/**
 * ゲーム開始時の暗転
 **/
class BlackCurtain extends FlxSprite {
    private var _group:FlxTypedGroup<FlxSprite>;
    public function new() {
        super();

        makeGraphic(cast FlxG.width*3/4, FlxG.height, FlxColor.BLACK);
        alpha = 0.5;

        _group = new FlxTypedGroup<FlxSprite>();
    }

    public function getGroup():FlxTypedGroup<FlxSprite> {
        return _group;
    }

    override public function update():Void {
        if(FlxG.keys.anyJustPressed(["UP", "LEFT", "DOWN", "RIGHT", "Z", "SPACE", "X", "SHIFT"])) {
            kill();
            _group.kill();
        }
    }
}
