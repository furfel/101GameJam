package;

import flixel.FlxGame;
import openfl.display.Sprite;
import states.*;

class Main extends Sprite
{
	public static final SPRITE_SIZE = 32;
	public static final SPRITE_SIZE_HALF = SPRITE_SIZE / 2;

	public function new()
	{
		super();
		// addChild(new FlxGame(0, 0, MenuState));
		addChild(new FlxGame(0, 0, PlayState));
	}
}

enum Direction
{
	LEFT;
	RIGHT;
	UP;
	DOWN;
}
