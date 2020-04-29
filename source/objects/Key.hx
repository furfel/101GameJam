package objects;

import flixel.FlxSprite;
import flixel.addons.editors.tiled.TiledObject;

class Key extends FlxSprite
{
	public var name:String;

	public function new(o:TiledObject)
	{
		super(o.x, o.y);
		loadGraphic("assets/images/key.png", false);
		name = o.name;
	}
}
