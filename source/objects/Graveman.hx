package objects;

import Main.Direction;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.util.FlxColor;
import hud.Healthbar;
import states.PlayState;

class Graveman extends AbstractSprite
{
	public static final VISIONDISTANCE = 128;
	public static final SPEED = 96;
	public static final DIAGSPEED = SPEED / Math.sqrt(2);
	public static final CREATION = .75;

	private var healthbar:Healthbar = new Healthbar();
	private var stone:Stone = null;

	public function getHealthbar()
		return healthbar;

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

	private var shock = 0.0;
	private var inCreation = CREATION;
	private var originalColor:FlxColor;

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

		health = 100;
		immovable = true;
		originalColor = color;
		color = FlxColor.fromRGB(220, 240, 250);
		alive = false;
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

	override function kill()
	{
		super.kill();
		if ((parent is PlayState))
			cast(parent, PlayState).removeHealthbar(healthbar);
	}

	public function getHit()
	{
		shock += 0.5;
		health -= 33;
		if (health <= 0)
		{
			kill();
			FlxG.sound.play("assets/sounds/death.ogg", 0.9);
		}
		else
			FlxG.sound.play("assets/sounds/hit.ogg", 0.85);
	}

	private var throwCooldown = FlxG.random.float(0.8, 1.3);

	private function throwStone(char:Character)
	{
		if (!(parent is PlayState))
			return;

		if (stone != null && !stone.alive)
			cast(parent, PlayState).removeStone(stone);

		throwCooldown = FlxG.random.float(1.2, 2.0);
		stone = new Stone(getMidpoint().x - 8.0, getMidpoint().y - 8.0, char.getMidpoint().x - 8.0, char.getMidpoint().y - 8.0);

		cast(parent, PlayState).addStone(stone);
	}

	override function destroy()
	{
		super.destroy();
	}

	private function updateStep(elapsed:Float)
	{
		if ((parent is PlayState))
		{
			var s = cast(parent, PlayState);
			if (!s.getCharacter().invisibleCloak() && getMidpoint().distanceTo(s.getCharacterMidpoint()) <= VISIONDISTANCE)
			{
				var playerpos = s.getCharacterPosition();
				stepTowardsPlayer(playerpos[0], playerpos[1]);

				if (stone == null || !stone.alive)
				{
					if (throwCooldown <= 0.0)
						throwStone(s.getCharacter());
					else
						throwCooldown -= elapsed;
				}
			}
			else
			{
				randomStep();
			}
		}
	}

	private function updateShock(elapsed:Float):Bool
	{
		if (shock > 0)
		{
			shock -= elapsed;
			if (shock <= 0)
			{
				offset.set(0, 0);
				alpha = 1;
				color = originalColor;
			}
			else
			{
				offset.set(3.0 * Math.sin(shock * 4.0), 3.0 * Math.sin(shock * 4.0 + 1.35));
				alpha = 0.6 + Math.min(0.4, 0.2 * Math.exp(Math.sin(shock * 5.0)));
				color.greenFloat = color.blueFloat = 0.8 + Math.min(0.2, 0.2 * Math.cos(shock * 3.0));
			}
			return true;
		}

		return false;
	}

	private function updateCreation(elapsed:Float):Bool
	{
		if (inCreation <= 0)
			return false;
		else
		{
			inCreation -= elapsed;

			if (inCreation <= 0)
			{
				alive = true;
				health = 100;
				alpha = 1;
				color = originalColor;
			}
			else
			{
				alpha = Math.min(1.0, 0.8 + 0.2 * Math.sin(inCreation));
				color = FlxColor.fromRGBFloat(0.75
					+ Math.sin(CREATION - inCreation) * 0.25, 0.82
					+ Math.sin(CREATION - inCreation) * .18,
					0.9
					+ Math.sin(CREATION - inCreation) * .1);
			}

			return true;
		}
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		setAnimation();

		if (updateCreation(elapsed))
			return;

		healthbar.placeOnObject(getMidpoint());
		healthbar.setHealth(health);

		var speed = (logicalX * Main.SPRITE_SIZE != x && logicalY * Main.SPRITE_SIZE != y) ? DIAGSPEED : SPEED;

		if (updateShock(elapsed))
			return;

		var movementOccured = updateMovement(elapsed, speed);

		if (!movementOccured)
		{
			updateStep(elapsed);
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
