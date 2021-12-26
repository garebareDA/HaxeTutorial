package;

import flixel.FlxG;
import flixel.util.FlxSave;
import flixel.FlxGame;
import openfl.display.Sprite;

class Main extends Sprite
{
	public function new()
	{
		super();
		addChild(new FlxGame(320, 240, PlayState));
		var save = new FlxSave();
		save.bind("TurnBasedRPG");
		#if desktop
		if (save.data.fullscreen != null)
		{
			startFullscreen = save.data.fullscreen;
		}
		#end
		if (save.data.volume != null)
		{
			FlxG.sound.volume = save.data.volume;
		}
		save.close();
	}
}
