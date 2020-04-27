package objects;

import Main.Direction;
import flixel.FlxG;
import flixel.FlxObject;
import states.PlayState;

class Graveman extends AbstractSprite
{
	public static final VISIONDISTANCE = 128;
	public static final SPEED = 96;
	public static final DIAGSPEED = SPEED / Math.sqrt(2);

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

		animation.play("sd");
	}

	private function setAnimation()
	{
		var anim = "s";
		if (logicalX * Main.SPRITE_SIZE != x || logicalY * Main.SPRITE_SIZE != y)
			anim = "m";

		if (facing == FlxObject.UP)
			anim += "u";
		else if (facing == FlxObject.DOWN)
			anim += "d";
		else if (facing == FlxObject.LEFT)
			anim += "l";
		else
			anim += "r";

		animation.play(anim);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		setAnimation();

		var speed = (logicalX * Main.SPRITE_SIZE != x && logicalY * Main.SPRITE_SIZE != y) ? DIAGSPEED : SPEED;
		var movementOccured = updateMovement(elapsed, speed);

		if (!movementOccured)
		{
			if ((parent is PlayState))
			{
				var s = cast(parent, PlayState);
				if (!s.getCharacter().invisibleCloak() && getMidpoint().distanceTo(s.getCharacterMidpoint()) <= VISIONDISTANCE)
				{
					var playerpos = s.getCharacterPosition();
					stepTowardsPlayer(playerpos[0], playerpos[1]);
				}
				else
				{
					randomStep();
				}
			}
		}
	}

	function randomStep()
	{
		var dice = FlxG.random.float();
		if (dice < 0.25)
			move(UP);
		else if (dice < 0.5)
			move(DOWN);
		else if (dice < 0.75)
			move(LEFT);
		else
			move(RIGHT);
	}

	function stepTowardsPlayer(X:Int, Y:Int)
	{
		if (logicalX < X - 1)
			move(RIGHT);
		else if (logicalX > X + 1)
			move(LEFT);

		if (logicalY < Y - 1)
			move(DOWN);
		else if (logicalY > Y + 1)
			move(UP);
	}
}
