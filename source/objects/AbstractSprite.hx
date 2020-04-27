package objects;

import flixel.FlxSprite;
import flixel.util.FlxColor;
import states.AbstractGameState;

class AbstractSprite extends FlxSprite
{
	private var logicalX:Int;
	private var logicalY:Int;
	private var parent:AbstractGameState;

	public function new(X:Int, Y:Int, parent:AbstractGameState)
	{
		super(X * Main.SPRITE_SIZE, Y * Main.SPRITE_SIZE);
		logicalX = X;
		logicalY = Y;
		this.parent = parent;

		makeGraphic(Main.SPRITE_SIZE, Main.SPRITE_SIZE, FlxColor.BLUE);
		createSprite();
	}

	@:abstract
	function createSprite() {}
}
