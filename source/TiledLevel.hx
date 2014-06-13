package ;

import flixel.tile.FlxTile;
import haxe.io.Path;
import flixel.addons.editors.tiled.TiledPropertySet;
import flixel.addons.editors.tiled.TiledTileSet;
import flixel.addons.editors.tiled.TiledMap;
import flixel.tile.FlxTilemap;
import flixel.group.FlxGroup;

/**
 * TiledMapの読み込みクラス
 **/
class TiledLevel extends TiledMap {
    private static inline var C_PATH_LEVEL_TILESHEETS = "assets/levels/";
    // タイルセットのプロパティ名
    private static inline var PROPERTY_TILESET = "tileset";
    // コリジョン無効のプロパティ
    private static inline var PROPERTY_NOCOLLIDE = "nocollide";

    public var foregroundTiles:FlxGroup; // 前面レイヤー（描画用）
    public var backgroundTiles:FlxGroup; // 背面レイヤー（描画用）

    private var collidableTileLayers:Array<FlxTilemap>; // コリジョンレイヤー

    /**
     * コンストラクタ
     * @param tileLevel *.tmxファイルパス
     **/
    public function new(tiledLevel:Dynamic) {

        // *.tmxファイルのロード
        super(tiledLevel);

        // 前面用グループ作成
        foregroundTiles = new FlxGroup();
        // 背景用グループ作成
        backgroundTiles = new FlxGroup();

        // TMXファイルをレイヤーに展開する
        // "layers"にレイヤー情報が格納されている
        for(tileLayer in layers) {

            // タイルセットとして扱う名前を取得
            var tileSheetName:String = tileLayer.properties.get(PROPERTY_TILESET);
            if(tileSheetName == null) {
                // タイルセットの指定がない
                throw "Error: 'tileset' property not defined for the '" + tileLayer.name + "' layer. Please add the property to the layer.";
            }

            // タイルセットを探す
            var tileSet:TiledTileSet = null;
            for(ts in tilesets) {
                if(ts.name == tileSheetName) {
                    // 同名のタイルセットを見つけた
                    tileSet = ts;
                    break;
                }
            }

            if(tileSet == null) {
                // タイルセットが存在しない
                throw "Error: Tileset '" + tileSheetName + "' not found. Did you mispell the 'tilesheet' property in " + tileLayer.name + "' layer?";
            }

            // チップ画像のパスを作成
            var imagePath = new Path(tileSet.imageSource);
            var processedPath = C_PATH_LEVEL_TILESHEETS + imagePath.file + "." + imagePath.ext;

            // FlxTilemapでCSVレイヤーデータを読み込む
            var tilemap:FlxTilemap = new FlxTilemap();
            // タイルの幅を設定
            tilemap.widthInTiles = width;
            tilemap.heightInTiles = height;
            // ロード実行
            tilemap.loadMap(tileLayer.csvData, processedPath, tileSet.tileWidth, tileSet.tileHeight, FlxTilemap.OFF, 1, 1, 1);

            if(tileLayer.properties.contains(PROPERTY_NOCOLLIDE)) {

                // コリジョンなしの場合は背景レイヤー
                backgroundTiles.add(tilemap);
            }
            else {

                // コリジョンありの場合はコリジョンレイヤーに登録
                if(collidableTileLayers == null) {
                    collidableTileLayers = new Array<FlxTilemap>();
                }

                foregroundTiles.add(tilemap);
                collidableTileLayers.push(tilemap);
            }
        }


    }
}
