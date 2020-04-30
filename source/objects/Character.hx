package objects;

import Main.Direction;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.input.gamepad.FlxGamepad;
import flixel.math.FlxRect;
import haxe.display.Display.Package;
import hud.Healthbar;
import objects.AbstractSprite;
import states.PlayState;

class Character extends AbstractSprite
{
	public static final SPEED = 128.0;
	public static final DIAGSPEED = SPEED / Math.sqrt(2);

	private var sword:Sword = null;

	private var keysInventory = new Array<String>();

	private var healthbar:Healthbar = new Healthbar();

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		setAnimation();

		healthbar.placeOnObject(this.getMidpoint());
		healthbar.setHealth(health);

		var speed = (logicalX * Main.SPRITE_SIZE != x && logicalY * Main.SPRITE_SIZE != y) ? DIAGSPEED : SPEED;
		var movementOccured = updateMovement(elapsed, speed);

		if (!movementOccured)
		{
			handleMovement();
		}

		if ((parent is PlayState) && sword != null && sword.alive)
		{
			var iter = cast(parent, PlayState).getGravemen().iterator();
			while (iter.hasNext())
			{
				var g = iter.next();
				if (g.alive && FlxRect.weak(g.x, g.y, g.width, g.height).containsPoint(sword.getTip()))
				{
					killGraveman(sword, g);
					sword.alive = false;
					break;
				}
			}
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

		health = 100;
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
	private var keyRet = false;

	private function handleMovement()
	{
		var keyS = FlxG.keys.anyPressed([S, DOWN]);
		var keyW = FlxG.keys.anyPressed([W, UP]);
		var keyA = FlxG.keys.anyPressed([A, LEFT]);
		var keyD = FlxG.keys.anyPressed([D, RIGHT]);

		var gamepad = FlxG.gamepads.lastActive;
		var gamePadHit = false;
		var gamePadAction = false;
		if (gamepad != null)
		{
			keyA = keyA || gamepad.analog.value.LEFT_STICK_X < -0.5;
			keyD = keyD || gamepad.analog.value.LEFT_STICK_X > 0.5;
			keyW = keyW || gamepad.analog.value.LEFT_STICK_Y < -0.5;
			keyS = keyS || gamepad.analog.value.LEFT_STICK_Y > 0.5;
			gamePadHit = gamepad.pressed.A;
			gamePadAction = gamepad.pressed.B;
		}

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
			keySp = FlxG.keys.anyPressed([SPACE]) || gamePadHit;
			if (keySp)
				hitWithSword();
		}
		else
		{
			if (!(FlxG.keys.anyPressed([SPACE]) || gamePadHit))
				keySp = false;
		}

		if (!keyRet)
		{
			keyRet = FlxG.keys.anyPressed([ENTER]) || gamePadAction;
			if (keyRet)
				doAction();
		}
		else
		{
			if (!(FlxG.keys.anyPressed([ENTER]) || gamePadAction))
				keyRet = false;
		}
	}

	private function doAction()
	{
		var tx = logicalX;
		var ty = logicalY;
		if (facing == FlxObject.RIGHT)
			tx += 1;
		else if (facing == FlxObject.LEFT)
			tx -= 1;
		else if (facing == FlxObject.DOWN)
			ty += 1;
		if (parent.doAction(tx, ty))
			FlxG.sound.play("assets/sounds/action.ogg");
		else if (facing == FlxObject.UP && parent.doAction(tx, ty - 1))
			FlxG.sound.play("assets/sounds/action.ogg");
		else
			FlxG.sound.play("assets/sounds/noaction.ogg");
	}

	private function hitWithSword()
	{
		if (locked)
			return;
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
			FlxG.sound.play("assets/sounds/sword.ogg");
		}
	}

	public function move(dir:Direction)
	{
		if (locked)
			return;

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

	public function getSword():Sword
	{
		return sword;
	}

	public function addKey(k:String)
	{
		keysInventory.push(k);
	}

	public function getKeys():Array<String>
	{
		return keysInventory;
	}

	public function setXY(x:Int, y:Int)
	{
		logicalX = x;
		logicalY = y;
	}

	public function getHealthbar()
	{
		return healthbar;
	}

	private var locked = false;

	public function lock()
		locked = true;
}
