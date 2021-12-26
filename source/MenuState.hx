package;

import flixel.FlxState;
import flixel.ui.FlxButton;
import flixel.FlxG;

class MenuState extends FlxState
{
	override public function create()
	{
		super.create();
		var playButton = new FlxButton(0, 0, "Play", clickPlay);
		playButton.screenCenter();
		add(playButton);
	}

	private function clickPlay()
	{
		FlxG.switchState(new PlayState());
	}
}
