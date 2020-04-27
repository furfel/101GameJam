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

	function updateMovement(elapsed:Float, speed:Float):Bool
	{
		var movementOccured = false;
		if (logicalX * Main.SPRITE_SIZE < x)
		{
			if (x - logicalX * Main.SPRITE_SIZE > speed * elapsed)
				x -= speed * elapsed;
			else
				x = logicalX * Main.SPRITE_SIZE;
			movementOccured = true;
		}
		else if (logicalX * Main.SPRITE_SIZE > x)
		{
			if (logicalX * Main.SPRITE_SIZE - x > speed * elapsed)
				x += speed * elapsed;
			else
				x = logicalX * Main.SPRITE_SIZE;
			movementOccured = true;
		}

		if (logicalY * Main.SPRITE_SIZE < y)
		{
			if (y - logicalY * Main.SPRITE_SIZE > speed * elapsed)
				y -= speed * elapsed;
			else
				y = logicalY * Main.SPRITE_SIZE;
			movementOccured = true;
		}
		else if (logicalY * Main.SPRITE_SIZE > y)
		{
			if (logicalY * Main.SPRITE_SIZE - y > speed * elapsed)
				y += speed * elapsed;
			else
				y = logicalY * Main.SPRITE_SIZE;
			movementOccured = true;
		}

		return movementOccured;
	}

	public function getLogicalX()
		return logicalX;

	public function getLogicalY()
		return logicalY;

	@:abstract
	function createSprite() {}
}
