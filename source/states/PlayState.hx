package states;

import flixel.FlxG;
import flixel.FlxState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxPoint;
import objects.*;

class PlayState extends AbstractGameState
{
	private var character:Character;
	private var coffins:FlxTypedGroup<Coffin>;
	private var gravemen:FlxTypedGroup<Graveman>;

	override public function create()
	{
		super.create();

		coffins = new FlxTypedGroup<Coffin>();
		add(coffins);

		gravemen = new FlxTypedGroup<Graveman>();
		add(gravemen);

		new GameMap("assets/data/dungeon.tmx", this);
		FlxG.camera.zoom = 2;
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
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
}
