package;

import flixel.group.FlxGroup.FlxTypedGroup;
import haxe.Log;
import flixel.FlxG;
import flixel.tile.FlxTilemap;
import flixel.addons.editors.ogmo.FlxOgmo3Loader;
import flixel.text.FlxText;
import flixel.FlxState;

class PlayState extends FlxState
{
	var player:Player;
	var map:FlxOgmo3Loader;
	var walls:FlxTilemap;

	var coins:FlxTypedGroup<Coin>;

	override public function create()
	{
		super.create();
		map = new FlxOgmo3Loader(AssetPaths.turnBasedRPG__ogmo, AssetPaths.room_01__json);
		walls = map.loadTilemap(AssetPaths.tiles__png, "walls");
		walls.setTileProperties(1, NONE);
		walls.setTileProperties(2, ANY);
		add(walls);

		coins = new FlxTypedGroup();
		add(coins);

		player = new Player();
		add(player);

		map.loadEntities(placeEntities, "entities");

		FlxG.camera.follow(player, TOPDOWN, 1);
	}

	function placeEntities(entity:EntityData) {
		if (entity.name == "player")
		{
			player.setPosition(entity.x, entity.y);
		}
		else if(entity.name == "coin")
		{
			coins.add(new Coin(entity.x + 4, entity.y + 4));
		}
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
		FlxG.overlap(player, coins, playerTouchCoin);
		FlxG.collide(player, walls);
	}

	function playerTouchCoin(player:Player, coin:Coin) {
		if(player.alive && player.exists && coin.alive && coin.exists) coin.kill();
	}
}
