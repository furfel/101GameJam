package objects;

import Main.Direction;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import haxe.display.Display.Package;
import objects.AbstractSprite;
import states.PlayState;

class Character extends AbstractSprite
{
	public static final SPEED = 128.0;
	public static final DIAGSPEED = SPEED / Math.sqrt(2);

	private var sword:Sword = null;

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		setAnimation();

		var speed = (logicalX * Main.SPRITE_SIZE != x && logicalY * Main.SPRITE_SIZE != y) ? DIAGSPEED : SPEED;
		var movementOccured = updateMovement(elapsed, speed);

		if (!movementOccured)
		{
			handleMovement();
		}

		if ((parent is PlayState) && sword != null && sword.alive)
		{
			if (FlxG.collide(sword, cast(parent, PlayState).getGravemen(), killGraveman))
				sword.alive = false;
		}
	}

	override function createSprite()
	{
		loadGraphic("assets/images/character.png", true, 32, 32);

		animation.add("md", [0, 1, 0, 2], 8);
		animation.add("mu", [4, 5, 4, 6], 8);
		animation.add("mr", [8, 9, 8, 10], 8);
		animation.add("ml", [12, 13, 12, 14], 8);
		animation.add("sd", [0], 8);
		animation.add("su", [4], 8);
		animation.add("sr", [8], 8);
		animation.add("sl", [12], 8);
		animation.add("hd", [3, 0, 3], 10);
		animation.add("hu", [7, 4, 7], 10);
		animation.add("hr", [11, 8, 11], 10);
		animation.add("hl", [15, 12, 15], 10);

		animation.play("sd");
		facing = FlxObject.DOWN;
	}

	private function setAnimation()
	{
		var anim = "s";
		if (sword != null && sword.exists)
			anim = "h";
		else if (logicalX * Main.SPRITE_SIZE != x || logicalY * Main.SPRITE_SIZE != y)
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

	private function killGraveman(s:Dynamic, g:Dynamic):Void
	{
		if ((g is Graveman) && (parent is PlayState))
		{
			var g:Graveman = cast g;
			g.getHit();
			if (!g.alive)
				cast(parent, PlayState).removeGraveman(g);
		}
	}

	private var keySp = false;

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

		if (!keySp)
		{
			keySp = FlxG.keys.anyPressed([SPACE]);
			if (keySp)
				hitWithSword();
		}
		else
		{
			if (!FlxG.keys.anyPressed([SPACE]))
				keySp = false;
		}
	}

	private function hitWithSword()
	{
		if (sword == null || sword.alive == false)
		{
			if (sword != null)
				parent.remove(sword);
			sword = new Sword(this);
			var inx = parent.members.indexOf(this);
			if (facing == FlxObject.UP || facing == FlxObject.LEFT)
				parent.insert(inx, sword);
			else
				parent.insert(inx + 1, sword);
		}
	}

	public function move(dir:Direction)
	{
		if (sword != null && sword.exists)
			return; // When we hit we can't move lol

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
