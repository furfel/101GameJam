package objects;

import Main.Direction;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import objects.AbstractSprite;

class Character extends AbstractSprite
{
	public static final SPEED = 128.0;
	public static final DIAGSPEED = SPEED / Math.sqrt(2);

	private var sword:Sword = null;

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		var speed = (logicalX * Main.SPRITE_SIZE != x && logicalY * Main.SPRITE_SIZE != y) ? DIAGSPEED : SPEED;
		var movementOccured = updateMovement(elapsed, speed);

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
		var keySp = FlxG.keys.anyPressed([SPACE]);

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

		if (keySp)
		{
			if (sword == null || sword.alive == false)
			{
				if (sword != null)
					parent.remove(sword);
				sword = new Sword(this);
				parent.add(sword);
			}
		}
	}

	public function move(dir:Direction)
	{
		switch (dir)
		{
			case LEFT:
				if (!parent.isObstructing(logicalX - 1, logicalY))
					logicalX -= 1;
				facing = FlxObject.LEFT;

			case RIGHT:
				if (!parent.isObstructing(logicalX + 1, logicalY))
					logicalX += 1;
				facing = FlxObject.RIGHT;

			case DOWN:
				if (!parent.isObstructing(logicalX, logicalY + 1))
					logicalY += 1;
				facing = FlxObject.DOWN;

			case UP:
				if (!parent.isObstructing(logicalX, logicalY - 1))
					logicalY -= 1;
				facing = FlxObject.UP;
		}
	}

	public function getLogicalPosition():Array<Int>
	{
		return [logicalX, logicalY];
	}

	public function invisibleCloak():Bool
	{
		return false;
	}
}
