package;

import flixel.text.FlxText;
import flixel.FlxState;
import flixel.ui.FlxButton;
import flixel.FlxG;

class MenuState extends FlxState
{
	var titleText:FlxText;
	var optionsButton:FlxButton;

	override public function create()
	{
		super.create();
		var playButton = new FlxButton(0, 0, "Play", clickPlay);
		playButton.screenCenter();
		add(playButton);

		titleText = new FlxText(20, 0, 0, "HaxeFlixel\nTutorial\nGame", 22);
		titleText.alignment = CENTER;
		titleText.screenCenter(X);
		add(titleText);

		playButton = new FlxButton(0, 0, "Play", clickPlay);
		playButton.x = (FlxG.width / 2) - playButton.width - 10;
		playButton.y = FlxG.height - playButton.height - 10;
		add(playButton);

		optionsButton = new FlxButton(0, 0, "Options", clickOptions);
		optionsButton.x = (FlxG.width / 2) + 10;
		optionsButton.y = FlxG.height - optionsButton.height - 10;
		add(optionsButton);

		playButton.onUp.sound = FlxG.sound.load(AssetPaths.select__wav);
		
	}

	private function clickPlay()
	{
		FlxG.switchState(new PlayState());
	}

	function clickOptions()
	{
		FlxG.switchState(new OptionsState());
	}
}
