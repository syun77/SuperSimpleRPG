package ;

import flixel.addons.editors.tiled.TiledMap;
import flixel.tile.FlxTilemap;
import flixel.group.FlxGroup;

/**
 * TiledMapの読み込みクラス
 **/
class TiledLevel extends TiledMap {
    private static inline var C_PATH_LEVEL_TILESHEETS = "assets/levels/";

    public var foregroundTiles:FlxGroup; // 前面レイヤー（描画用）

    private var collisionTileLayers:Array<FlxTilemap>; // コリジョンレイヤー

    /**
     * コンストラクタ
     * @param tileLevel *.tmxファイルパス
     **/
    public function new(tiledLevel:Dynamic) {

        // *.tmxファイルのロード
        super(tiledLevel);

        // 前面レイヤー作成
        foregroundTiles = new FlxGroup();

        // TMXファイルをレイヤーに展開する
        // "layers"にレイヤー情報が格納されている
        for(tileLayer in layers) {

            // タイルセットとして扱う名前を取得
            var tileSheetName:String = tileLayer.properties.get("tileset");
        }

    }
}
