package hud;

import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;

class Healthbar extends FlxTypedGroup<FlxSprite>
{
	private var healthbarBg:FlxSprite;
	private var healthbar:FlxSprite;

	public function new()
	{
		super();
		add(healthbarBg = new FlxSprite(0, 0).makeGraphic(24, 9, FlxColor.BLACK));
		add(healthbar = new FlxSprite(2, 2).makeGraphic(20, 5, FlxColor.WHITE));
	}

	public function setHealth(percent:Float)
	{
		healthbar.origin.set(0, healthbar.height / 2);
		healthbar.scale.set(Math.max(0, percent / 100), 1);
		if (percent >= 66)
			healthbar.color = FlxColor.LIME;
		else if (percent >= 33)
			healthbar.color = FlxColor.YELLOW;
		else
			healthbar.color = FlxColor.RED;
	}

	public function placeOnObject(midpoint:FlxPoint)
	{
		healthbarBg.last.set(midpoint.x - Main.SPRITE_SIZE_HALF + 4, midpoint.y - Main.SPRITE_SIZE_HALF - 9);
		healthbarBg.setPosition(healthbarBg.last.x, healthbarBg.last.y);
		healthbar.setPosition(healthbarBg.x + 2, healthbarBg.y + 2);
	}
}
