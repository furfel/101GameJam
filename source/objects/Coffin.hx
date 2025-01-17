package objects;

import flixel.FlxBasic;
import flixel.FlxG;
import flixel.addons.editors.tiled.TiledObject;
import flixel.math.FlxPoint;
import states.AbstractGameState;
import states.PlayState;

class Coffin extends FlxBasic
{
	public static final WAIT_TIME_MIN = 8;
	public static final WAIT_TIME_MAX = 11;
	public static final DISTANCE_MIN = 320;

	private var graveman:Graveman = null;
	private var toNextSpawn:Float = FlxG.random.float(WAIT_TIME_MIN, WAIT_TIME_MAX);

	private var X:Int;
	private var Y:Int;
	private var parent:AbstractGameState;
	private var centerX = 0;
	private var centerY = 0;

	public function new(o:TiledObject, parent:AbstractGameState)
	{
		super();

		centerX = Std.int(o.x + o.width / 2);
		centerY = Std.int(o.y + o.height / 2);
		X = Std.int((o.x + Main.SPRITE_SIZE_HALF) / Main.SPRITE_SIZE);
		Y = Std.int((o.y + Main.SPRITE_SIZE_HALF) / Main.SPRITE_SIZE);

		this.parent = parent;
	}

	// FlxBasic to follow the game's clock
	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if ((this.parent is PlayState))
			if (graveman == null || !graveman.alive || graveman.health <= 0)
			{
				if (cast(this.parent, PlayState).getCharacter().getMidpoint().distanceTo(FlxPoint.weak(centerX, centerY)) <= DISTANCE_MIN)
				{
					toNextSpawn -= elapsed;
					if (toNextSpawn <= 0)
					{
						spawn();
						toNextSpawn = FlxG.random.float(WAIT_TIME_MIN, WAIT_TIME_MAX);
					}
				}
			}
	}

	private function spawn()
	{
		var freepoints:Array<Array<Int>> = new Array<Array<Int>>();
		for (x in X - 1...X + 2)
			for (y in Y - 1...Y + 2)
				if (!parent.isObstructing(x, y))
					freepoints.push([x, y]);

		if (freepoints.length <= 0)
			return;

		FlxG.random.shuffle(freepoints);
		FlxG.sound.play("assets/sounds/appear" + Std.string(FlxG.random.int(1, 3)) + ".ogg", 0.75);
		cast(parent, PlayState).addGraveman(graveman = new Graveman(freepoints[0][0], freepoints[0][1], parent));
	}
}
