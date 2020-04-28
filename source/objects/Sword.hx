package objects;

import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.math.FlxPoint;

class Sword extends FlxSprite
{
	public static final SPEED = 240;
	public static final ANGLE_TO_MOVE = 60;
	public static final DEG_TO_RAD = Math.PI / 180;

	private var endAngle = 0.0;
	private var startX = 0.0;
	private var startY = 0.0;
	private var radius = 1.0;

	public function new(c:Character)
	{
		super(-10, -10);
		loadGraphic("assets/images/sword.png", false);
		startX = c.x + c.width / 2;
		startY = c.y + c.height / 2;
		radius = c.width / 2;
		setFlip(c.facing);
	}

	private function updateCosinePosition()
	{
		x = startX + Math.cos(DEG_TO_RAD * angle) * radius;
		y = startY + Math.sin(DEG_TO_RAD * angle) * radius;
		if (angle >= 60 && angle <= 120 || angle >= 240 && angle <= 300)
		{
			x -= width / 2;
		}
		else
			y -= height / 2;
	}

	private function setFlip(dir:Int)
	{
		if (dir == FlxObject.RIGHT)
		{
			angle = 30.0;
			endAngle = -30.0;
			startX -= radius / 2;
			updateCosinePosition();
		}
		else if (dir == FlxObject.LEFT)
		{
			angle = 220.0;
			endAngle = 150.0;
			startX -= 3 * radius / 2;
			updateCosinePosition();
		}
		else if (dir == FlxObject.UP)
		{
			var w = width;
			width = height;
			height = w;
			centerOffsets();
			startY -= 3 * radius / 2;
			angle = 300;
			endAngle = 240;
			updateCosinePosition();
		}
		else if (dir == FlxObject.DOWN)
		{
			var w = width;
			width = height;
			height = w;
			centerOffsets();
			startY -= radius / 2;
			angle = 120;
			endAngle = 60;
			updateCosinePosition();
		}
		else
		{
			kill();
		}
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		if (alive)
		{
			if (angle < endAngle)
			{
				angle += elapsed * SPEED;
				if (angle >= endAngle)
					kill();
				else
					updateCosinePosition();
			}
			else if (angle > endAngle)
			{
				angle -= elapsed * SPEED;
				if (angle <= endAngle)
					kill();
				else
					updateCosinePosition();
			}
		}
	}
}
