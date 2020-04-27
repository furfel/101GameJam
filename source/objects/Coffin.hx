package objects;

import flixel.FlxBasic;
import flixel.FlxG;
import flixel.addons.editors.tiled.TiledObject;
import states.AbstractGameState;
import states.PlayState;

class Coffin extends FlxBasic
{
	public static final WAIT_TIME_MIN = 8;
	public static final WAIT_TIME_MAX = 11;

	private var graveman:Graveman = null;
	private var toNextSpawn:Float = FlxG.random.float(WAIT_TIME_MIN, WAIT_TIME_MAX);

	private var X:Int;
	private var Y:Int;
	private var parent:AbstractGameState;

	public function new(o:TiledObject, parent:AbstractGameState)
	{
		super();

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
				toNextSpawn -= elapsed;
				if (toNextSpawn <= 0)
				{
					spawn();
					toNextSpawn = FlxG.random.float(WAIT_TIME_MIN, WAIT_TIME_MAX);
				}
			}
	}

	private function spawn()
	{
		var freepoints = [];
		for (x in X - 1...X + 1)
			for (y in Y - 1...Y + 1)
			{
				if (!parent.isObstructing(x, y))
					freepoints.push([x, y]);
			}

		FlxG.random.shuffle(freepoints);

		cast(parent, PlayState).addGraveman(new Graveman(freepoints[0][0], freepoints[0][1], parent));
	}
}
