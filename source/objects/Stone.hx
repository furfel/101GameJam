package objects;

import flixel.FlxG;
import flixel.FlxSprite;

class Stone extends FlxSprite
{
	public static final MAX_LIFE = 2.4;
	public static final MIN_LIFE = 1.3;
	public static final MAX_HIT = 8.0;
	public static final MIN_HIT = 2.0;
	public static final SPEED = 192.0;
	public static final ANGULAR_SPEED = 510.0;

	private var life = 1.0;
	private var deltaScale = 0.1;

	public function new(startX:Float, startY:Float, endX:Float, endY:Float)
	{
		super(startX, startY);
		loadGraphic("assets/images/stone.png", true);
		life = FlxG.random.float(MIN_LIFE, MAX_LIFE);
		scale.set(1, 1);
		angle = 0;
		deltaScale = (1.0 - 0.25) / life;
		velocity.set(3.0 * (endX - startX) / life, 3.0 * (endY - startY) / life);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (!alive)
			return;

		angle += ANGULAR_SPEED * elapsed;
		if (angle > 360.0)
			angle -= 360.0;

		scale.set(scale.x - deltaScale * elapsed, scale.y - deltaScale * elapsed);

		life -= elapsed;

		if (life <= 0)
			kill();
	}

	public function takeHp(c:Character)
	{
		c.health -= life * FlxG.random.float(MIN_HIT, MAX_HIT);
		FlxG.sound.play("assets/sounds/hurt.ogg");
		kill();
	}
}
