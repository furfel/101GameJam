package states;

import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;

class TipDebug extends FlxSprite
{
	public function new()
	{
		super(100, 100);
		loadGraphic("assets/images/npc1.png", false);
		// makeGraphic(8, 8, FlxColor.LIME, true, "tipdebug");
	}

	public function set(t:FlxPoint)
	{
		x = t.x;
		y = t.y;
	}
}
