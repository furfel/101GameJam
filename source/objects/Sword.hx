package objects;

import flixel.FlxG;
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
	private var startW = 0.0;
	private var startH = 0.0;
	private var tipCenterX = 0.0;
	private var tipCenterY = 0.0;
	private var tipRadius = 1.0;

	public function new(c:Character)
	{
		super(c.x + c.width / 2, c.y + c.height / 2);
		loadGraphic("assets/images/sword.png", false);
		x = startX = c.x + c.width / 2;
		y = startY = c.y + c.height / 2;
		tipCenterX = c.getMidpoint().x;
		tipCenterY = c.getMidpoint().y;
		tip.copyFrom(c.getMidpoint());
		tipRadius = width - 2;

		radius = c.width / 2;
		startW = width;
		startH = height;
		alive = false;
		setFlip(c.facing);
		alive = true;
	}

	private function updateCosinePosition()
	{
		var cosx = Math.cos(DEG_TO_RAD * angle);
		var siny = Math.sin(DEG_TO_RAD * angle);

		var x = startX + cosx * radius;
		var y = startY + siny * radius;
		tip.set(tipCenterX + cosx * tipRadius, tipCenterY + siny * tipRadius);
		if (angle >= 70 && angle <= 110 || angle >= 260 && angle <= 290)
		{
			x -= width / 2;
		}
		else
			y -= startH / 2;
		setPosition(x, y);
	}

	private function setFlip(dir:Int)
	{
		if (dir == FlxObject.RIGHT)
		{
			angle = 20.0;
			endAngle = -20.0;
			startX -= radius / 2;
			updateCosinePosition();
		}
		else if (dir == FlxObject.LEFT)
		{
			angle = 200.0;
			endAngle = 160.0;
			startX -= 3 * radius / 2;
			updateCosinePosition();
		}
		else if (dir == FlxObject.UP)
		{
			width = startH;
			height = startW;
			centerOffsets();
			startY -= 3 * radius / 2;
			angle = 290.0;
			endAngle = 260.0;
			updateCosinePosition();
		}
		else if (dir == FlxObject.DOWN)
		{
			width = startH;
			height = startW;
			centerOffsets();
			startY -= radius / 2;
			angle = 110.0;
			endAngle = 70.0;
			updateCosinePosition();
		}
		else
		{
			kill();
		}
	}

	override function destroy()
	{
		super.destroy();
		tip.put();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		if (exists)
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

	private var tip:FlxPoint = FlxPoint.get(0, 0);

	public function getTip()
		return tip;
}
