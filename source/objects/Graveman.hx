package objects;

import Main.Direction;
import states.PlayState;

class Graveman extends AbstractSprite
{
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

	override function createSprite()
	{
		loadGraphic("assets/images/skel.png", true, Main.SPRITE_SIZE, Main.SPRITE_SIZE);
		animation.add("md", [0, 1, 2, 3], 4);
		animation.add("ml", [4, 5, 6, 7], 4);
		animation.add("mu", [8, 9, 10, 11], 4);
		animation.add("mr", [12, 13, 14, 15], 4);
		animation.add("sd", [0], 4);
		animation.add("sl", [4], 4);
		animation.add("su", [8], 4);
		animation.add("sr", [12], 4);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if ((parent is PlayState))
		{
			var s = cast(parent, PlayState);
		}
	}
}
