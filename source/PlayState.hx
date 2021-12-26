package;

import flixel.system.FlxSound;
import flixel.util.FlxColor;
import flixel.group.FlxGroup.FlxTypedGroup;
import haxe.Log;
import flixel.FlxG;
import flixel.tile.FlxTilemap;
import flixel.addons.editors.ogmo.FlxOgmo3Loader;
import flixel.text.FlxText;
import flixel.FlxState;

using flixel.util.FlxSpriteUtil;

class PlayState extends FlxState
{
	var player:Player;
	var map:FlxOgmo3Loader;
	var walls:FlxTilemap;

	var coins:FlxTypedGroup<Coin>;
	var enemies:FlxTypedGroup<Enemy>;

	var hud:HUD;
	var money:Int = 0;
	var health:Int = 3;

	var inCombat:Bool = false;
	var combatHud:CombatHUD;

	var ending:Bool;
	var won:Bool;

	var coinSound:FlxSound;

	#if mobile
	public static var virtualPad:FlxVirtualPad;
	#end

	override public function create()
	{
		super.create();
		#if mobile
		virtualPad = new FlxVirtualPad(FULL, NONE);
		add(virtualPad);
		#end

		coinSound = FlxG.sound.load(AssetPaths.coin__wav);

		map = new FlxOgmo3Loader(AssetPaths.turnBasedRPG__ogmo, AssetPaths.room_01__json);
		walls = map.loadTilemap(AssetPaths.tiles__png, "walls");
		walls.setTileProperties(1, NONE);
		walls.setTileProperties(2, ANY);
		add(walls);

		coins = new FlxTypedGroup();
		add(coins);

		enemies = new FlxTypedGroup<Enemy>();
		add(enemies);

		player = new Player();
		add(player);

		hud = new HUD();
		add(hud);

		combatHud = new CombatHUD();
		add(combatHud);

		map.loadEntities(placeEntities, "entities");

		FlxG.camera.follow(player, TOPDOWN, 1);
	}

	function placeEntities(entity:EntityData)
	{
		var x = entity.x;
		var y = entity.y;

		switch (entity.name)
		{
			case "player":
				player.setPosition(x, y);
			case "coin":
				coins.add(new Coin(x + 4, y + 4));
			case "enemy":
				enemies.add(new Enemy(x + 4, y, REGULAR));
			case "boss":
				enemies.add(new Enemy(x + 4, y, BOSS));
		}
	}

	override public function update(elapsed:Float)
	{
		if (inCombat)
		{
			#if mobile
			virtualPad.visible = true;
			#end
			if (!combatHud.visible)
			{
				health = combatHud.playerHealth;
				hud.updateHUD(health, money);
				if (combatHud.outcome == DEFEAT)
				{
					ending = true;
					FlxG.camera.fade(FlxColor.BLACK, 0.33, false, doneFadeOut);
				}
				else
				{
					if (combatHud.outcome == VICTORY)
					{
						combatHud.enemy.kill();
						if (combatHud.enemy.type == BOSS)
						{
							won = true;
							ending = true;
							FlxG.camera.fade(FlxColor.BLACK, 0.33, false, doneFadeOut);
						}
					}
					else
					{
						combatHud.enemy.flicker();
					}
					inCombat = false;
					player.active = true;
					enemies.active = true;
				}
			}
		}
		else
		{
			FlxG.overlap(player, coins, playerTouchCoin);
			FlxG.collide(player, walls);
			FlxG.collide(enemies, walls);
			enemies.forEachAlive(checkEnemyVision);
			FlxG.overlap(player, enemies, playerTouchEnemy);
		}
		super.update(elapsed);
		if (ending)
		{
			return;
		}
	}

	function checkEnemyVision(enemy:Enemy)
	{
		if (walls.ray(enemy.getMidpoint(), player.getMidpoint()))
		{
			enemy.seesPlayer = true;
			enemy.playerPostion = player.getMidpoint();
		}
		else
		{
			enemy.seesPlayer = false;
		}
	}

	function playerTouchCoin(player:Player, coin:Coin)
	{
		coinSound.play(true);
		if (player.alive && player.exists && coin.alive && coin.exists)
		{
			money++;
			hud.updateHUD(health, money);
			coin.kill();
		}
	}

	function playerTouchEnemy(player:Player, enemy:Enemy)
	{
		if (player.alive && player.exists && enemy.alive && enemy.exists && !enemy.isFlickering())
		{
			startCombat(enemy);
		}
	}

	function startCombat(enemy:Enemy)
	{
		#if mobile
		virtualPad.visible = false;
		#end
		inCombat = true;
		player.active = false;
		enemies.active = false;
		combatHud.initCombat(health, enemy);
	}

	function doneFadeOut()
	{
		FlxG.switchState(new GameOverState(won, money));
	}
}
