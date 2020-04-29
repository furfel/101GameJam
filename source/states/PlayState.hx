package states;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;
import objects.*;

class PlayState extends AbstractGameState
{
	private var coffins:FlxTypedGroup<Coffin>;
	private var gravemen:FlxTypedGroup<Graveman>;
	private var keys:FlxTypedGroup<Key>;
	private var doors:FlxTypedGroup<Door>;

	override public function create()
	{
		super.create();

		keys = new FlxTypedGroup<Key>();

		coffins = new FlxTypedGroup<Coffin>();
		add(coffins);

		new GameMap("assets/data/dungeon.tmx", this);
		FlxG.camera.zoom = 2;

		add(keys);

		gravemen = new FlxTypedGroup<Graveman>();
		add(gravemen);

		postCreateTrigger();
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		FlxG.overlap(character, keys, (c, key) ->
		{
			if ((key is Key) && cast(key, Key).alive)
			{
				FlxG.sound.play("assets/sounds/key.ogg");
				character.addKey(cast(key, Key).name);
				cast(key, Key).kill();
			}
		});

		if (!teleporting)
			FlxG.overlap(character, doors, (c, door) ->
			{
				if ((door is Door))
				{
					var doorD = cast(door, Door);
					if (!doorD.isClosed())
					{
						teleport(doorD.getTarget()[0], doorD.getTarget()[1]);
					}
				}
			});
	}

	public function addCoffin(coffin:Coffin)
	{
		coffins.add(coffin);
	}

	override function addCharacter(char:Character)
	{
		super.addCharacter(char);
		this.character = char;
	}

	public function addGraveman(graveman:Graveman)
	{
		gravemen.add(graveman);
	}

	public function addDoors(doors:Array<Door>)
	{
		this.doors = new FlxTypedGroup<Door>();
		for (d in doors)
			this.doors.add(d);
		add(this.doors);
	}

	public function getCharacterPosition():Array<Int>
	{
		if (character != null)
			return character.getLogicalPosition();

		return [-1, -1];
	}

	public function getCharacterMidpoint():FlxPoint
	{
		if (character != null)
			return character.getMidpoint();
		return FlxPoint.weak(-1, -1);
	}

	public function getCharacter():Character
	{
		return character;
	}

	public function addKey(key:Key)
	{
		keys.add(key);
	}

	override function doAction(logicalX:Int, logicalY:Int):Bool
	{
		var iter = doors.iterator();
		while (iter.hasNext())
		{
			var d = iter.next();
			if (d.getHitbox()
				.containsPoint(FlxPoint.weak(logicalX * Main.SPRITE_SIZE + Main.SPRITE_SIZE_HALF, logicalY * Main.SPRITE_SIZE + Main.SPRITE_SIZE_HALF)))
			{
				if (d.tryOpen(character.getKeys()))
					return true;
				return false;
			}
		}
		return false;
	}

	override function isObstructing(logicalX:Int, logicalY:Int):Bool
	{
		if (super.isObstructing(logicalX, logicalY))
			return true;

		var git = gravemen.iterator();
		while (git.hasNext())
		{
			var next = git.next();
			if (next.alive && next.getLogicalX() == logicalX && next.getLogicalY() == logicalY)
				return true;
		}

		if (character.getLogicalX() == logicalX && character.getLogicalY() == logicalY)
			return true;

		return false;
	}

	public function getGravemen():FlxTypedGroup<Graveman>
	{
		return gravemen;
	}

	public function removeGraveman(g:Graveman)
	{
		gravemen.remove(g);
	}
}
