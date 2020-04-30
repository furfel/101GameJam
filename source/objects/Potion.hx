package objects;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.editors.tiled.TiledObject;

class Potion extends FlxSprite
{
	public function new(o:TiledObject)
	{
		super(o.x, o.y);
		loadGraphic("assets/images/potion.png", false);
	}

	public function addHp(c:Character)
	{
		if (alive)
		{
			c.health = Math.min(100, c.health + FlxG.random.int(10, 20));
			FlxG.sound.play("assets/sound/heal.ogg");
		}
		kill();
	}
}
