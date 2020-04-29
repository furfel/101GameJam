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

	override public function create()
	{
		super.create();

		coffins = new FlxTypedGroup<Coffin>();
		add(coffins);

		new GameMap("assets/data/dungeon.tmx", this);
		FlxG.camera.zoom = 2;

		gravemen = new FlxTypedGroup<Graveman>();
		add(gravemen);

		postCreateTrigger();
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

	public function getCharacter():Character
	{
		return character;
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
