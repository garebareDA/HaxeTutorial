package;

import flixel.system.FlxSound;
import lime.utils.Log;
import flixel.FlxSprite;
import flixel.FlxG;
import flixel.math.FlxPoint;

class Player extends FlxSprite
{
	static inline var SPEED:Float = 200;
	var stepSound:FlxSound;

	public function new(x:Float = 0, y:Float = 0)
	{
		super(x, y);
		stepSound = FlxG.sound.load(AssetPaths.step__wav);
		loadGraphic(AssetPaths.player__png, true, 16, 16);
		drag.x = drag.y = 1600;
		setSize(8, 8);
		offset.set(4, 4);
		setFacingFlip(LEFT, false, false);
		setFacingFlip(RIGHT, true, false);
		animation.add("lr", [3, 4, 3, 5], 6, false);
		animation.add("u", [6, 7, 6, 8], 6, false);
		animation.add("d", [0, 1, 0, 2], 6, false);
	}

	function updateMovement()
	{
		var up:Bool = false;
		var down:Bool = false;
		var left:Bool = false;
		var right:Bool = false;

		up = FlxG.keys.anyPressed([UP, W]);
		down = FlxG.keys.anyPressed([DOWN, S]);
		left = FlxG.keys.anyPressed([LEFT, A]);
		right = FlxG.keys.anyPressed([RIGHT, D]);

		if (up && down)
			up = down = false;
		if (left && right)
			left = right = false;

		var newAngle:Float = 0;
		if (up)
		{
			newAngle = -90;
			if (left)
				newAngle -= 45;
			else if (right)
				newAngle += 45;
			facing = UP;
		}
		else if (down)
		{
			newAngle = 90;
			if (left)
				newAngle += 45;
			else if (right)
				newAngle -= 45;
			facing = DOWN;
		}
		else if (left)
		{
			newAngle = 180;
			facing = LEFT;
		}
		else if (right)
		{
			newAngle = 0;
			facing = RIGHT;
		}

		if (up || down || left || right)
		{
			velocity.set(SPEED, 0);
			velocity.rotate(FlxPoint.weak(0, 0), newAngle);
		}

		if((velocity.x != 0) || (velocity.y != 0))
		{
			stepSound.play();
			switch (facing)
			{
				case LEFT, RIGHT:
					animation.play("lr");
				case UP:
					animation.play("u");
				case DOWN:
					animation.play("d");
				case _:
			}
		}
	}

	override function update(elapsed:Float)
	{
		updateMovement();
		super.update(elapsed);
	}
}
