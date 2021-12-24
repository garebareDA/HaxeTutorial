package;

import flixel.text.FlxText;
import flixel.FlxState;

class PlayState extends FlxState
{
	override public function create()
	{
		super.create();
		var text = new FlxText(10, 10, 100, "Hello World!");
		add(text);
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}
