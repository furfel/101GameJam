package objects;

import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;

class Sign extends FlxTypedGroup<FlxSprite>
{
	private var bg1:FlxSprite;
	private var bg2:FlxSprite;
	private var text:FlxText;

	public function new(X:Float, Y:Float, t:String)
	{
		super();
		bg1 = new FlxSprite(0, 0).makeGraphic(32, 16, FlxColor.BLACK);
		bg1.setPosition(X - 16, Y - 32);
		bg2 = new FlxSprite(0, 0).makeGraphic(28, 12, FlxColor.WHITE);
		bg2.setPosition(bg1.x + 2, bg1.y + 2);
		add(bg1);
		add(bg2);
		text = new FlxText(bg2.x, bg2.y, bg2.width, t, 9);
		text.color = FlxColor.BLACK;
		add(text);
	}
}
