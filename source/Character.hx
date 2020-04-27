package;

import Main.Direction;
import flixel.FlxG;
import flixel.FlxSprite;
import objects.AbstractSprite;

class Character extends AbstractSprite
{
	public static final SPEED = 128.0;
	public static final DIAGSPEED = SPEED / Math.sqrt(2);

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		var movementOccured = false;
		var speed = (logicalX * Main.SPRITE_SIZE != x && logicalY * Main.SPRITE_SIZE != y) ? DIAGSPEED : SPEED;

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

		if (!movementOccured)
		{
			handleMovement();
		}
	}

	private function handleMovement()
	{
		var keyS = FlxG.keys.anyPressed([S, DOWN]);
		var keyW = FlxG.keys.anyPressed([W, UP]);
		var keyA = FlxG.keys.anyPressed([A, LEFT]);
		var keyD = FlxG.keys.anyPressed([D, RIGHT]);

		if (!(keyS && keyW))
			if (keyS)
				move(DOWN);
			else if (keyW)
				move(UP);

		if (!(keyA && keyD))
			if (keyA)
				move(LEFT);
			else if (keyD)
				move(RIGHT);
	}

	public function move(dir:Direction)
	{
		switch (dir)
		{
			case LEFT:
				if (!parent.isObstructing(logicalX - 1, logicalY))
					logicalX -= 1;

			case RIGHT:
				if (!parent.isObstructing(logicalX + 1, logicalY))
					logicalX += 1;

			case DOWN:
				if (!parent.isObstructing(logicalX, logicalY + 1))
					logicalY += 1;

			case UP:
				if (!parent.isObstructing(logicalX, logicalY - 1))
					logicalY -= 1;
		}
	}

	public function getLogicalPosition():Array<Int>
	{
		return [logicalX, logicalY];
	}
}
