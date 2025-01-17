package objects;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.editors.tiled.TiledObject;
import flixel.math.FlxPoint;
import states.AbstractGameState;
import states.MenuState;
import states.PlayState;

class Door extends AbstractSprite
{
	private var isOpen = false;
	private var key = "<none>";
	private var target:Array<Float> = null;
	private var targetName = "<none>";

	public static function fromTiledObject(o:TiledObject, parent:AbstractGameState)
	{
		var X = Std.int((o.x + Main.SPRITE_SIZE_HALF) / Main.SPRITE_SIZE);
		var Y = Std.int((o.y - Main.SPRITE_SIZE_HALF) / Main.SPRITE_SIZE);

		var door = new Door(X, Y, parent);

		if (o.properties.contains("target"))
			door.targetName = o.properties.get("target");
		if (o.properties.contains("open"))
			door.isOpen = o.properties.get("open") == "true" ? true : false;
		if (o.properties.contains("key"))
			door.key = o.properties.get("key");

		return door;
	}

	override function createSprite()
	{
		loadGraphic("assets/images/door.png", true, 32, 32);
		animation.add("open", [0, 1, 2, 3, 4], false);
		animation.add("slowopen", [0, 0, 0, 0, 0, 1, 2, 3, 4], 5, false);

		if (isOpen)
			animation.play("open");
		if ((parent is MenuState))
			animation.play("slowopen");
	}

	public function tryOpen(keys:Array<String>):Bool
	{
		if (!isOpen && keys.indexOf(key) >= 0)
		{
			isOpen = true;
			animation.play("open");
			return true;
		}
		return false;
	}

	public function stepOn(c:Character)
	{
		if (this.getHitbox().containsPoint(c.getMidpoint()))
		{
			if (StringTools.startsWith(targetName, "menu:") && !(parent is MenuState)) {}
			else if (!(parent is PlayState) && StringTools.startsWith(targetName, "play:")) {}
			else
			{
				parent.teleport(target[0], target[1]);
			}
		}
	}

	public function isClosed()
		return !isOpen;

	public function getTargetName()
		return targetName;

	public function updateTarget(t:Array<Float>)
	{
		target = new Array<Float>();
		target[0] = t[0];
		target[1] = t[1];
	}

	public function getTarget():Array<Float>
		return target;
}
