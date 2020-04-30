package states;

import flixel.FlxG;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

class WinState extends FlxState
{
	var text:FlxText;

	override function create()
	{
		super.create();

		text = new FlxText(FlxG.width / 2 - 150, 0, 300, "Thanks for playing!", 24);
		text.setFormat("assets/IndieFlower.ttf", 24, FlxColor.WHITE, CENTER, NONE);
		text.screenCenter();
		text.alpha = 0;
		add(text);

		FlxG.camera.fade(FlxColor.BLACK, 1.0, true, () ->
		{
			new FlxTimer().start(1.0, (t) ->
			{
				FlxG.sound.play("assets/sounds/thanks.ogg");
				text.alpha = 1;
			});

			new FlxTimer().start(4.0, (t) ->
			{
				FlxG.camera.fade(FlxColor.BLACK, 1.0, false, () ->
				{
					FlxG.switchState(new MenuState());
				});
			});
		});
	}
}
