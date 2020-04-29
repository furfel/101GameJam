package states;

import flixel.FlxBasic;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;
import objects.*;

class AbstractGameState extends FlxState
{
	private var obstructs:FlxTypedGroup<FlxObject> = new FlxTypedGroup<FlxObject>(100);
	private var obstructArray:Array<Array<Bool>> = null;

	public var teleportPointsArray:Map<String, Array<Float>> = new Map<String, Array<Float>>();

	var character:Character;

	private var teleportIn:String = null;

	public function new(?teleport:String = null, ?maxSize:Int = 0)
	{
		super(maxSize);

		if (teleport != null)
			teleportIn = teleport;
	}

	override function create()
	{
		super.create();
		add(obstructs);
	}

	public function postCreateTrigger()
	{
		if (teleportIn != null)
		{
			teleportInByName(teleportIn);
			FlxG.camera.fade(FlxColor.BLACK, 0.6, true);
		}
	}

	public function doAction(logicalX:Int, logicalY:Int):Bool
	{
		return false;
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
	}

	public function isObstructing(logicalX:Int, logicalY:Int)
	{
		if (logicalX >= 0 && logicalX < obstructArray.length)
			if (logicalY >= 0 && logicalY < obstructArray[logicalX].length)
				return obstructArray[logicalX][logicalY];

		// out of range!
		return true;
	}

	public function resizeObstructs(width:Int, height:Int)
	{
		obstructArray = [for (x in 0...width) [for (y in 0...height) false]];
	}

	public function setBlocking(x:Int, y:Int, b:Bool)
	{
		obstructArray[x][y] = b;
	}

	public function addObstructing(ob:FlxObject)
	{
		obstructs.add(ob);
	}

	public function addCharacter(char:Character)
	{
		add(char);
		FlxG.camera.follow(char, TOPDOWN, 0.5);
	}

	public var teleporting = false;

	public function teleportByName(n:String)
	{
		var parts = n.split(":");
		teleporting = true;
		FlxG.camera.fade(FlxColor.BLACK, 0.6, false, () ->
		{
			if (parts[0] == "menu")
				FlxG.switchState(new MenuState(parts[1]));
			else if (parts[0] == "play")
				FlxG.switchState(new PlayState(parts[1]));
			else
				FlxG.camera.fade(FlxColor.BLACK, 0.6, true);
			teleporting = false;
		});
	}

	public function teleportInByName(n:String):AbstractGameState
	{
		if (teleportPointsArray.exists(n) && teleportPointsArray.get(n) != null && teleportPointsArray.get(n).length > 1)
		{
			teleport(teleportPointsArray.get(n)[0], teleportPointsArray.get(n)[1]);
			FlxG.camera.focusOn(character.getMidpoint());
		}
		FlxG.camera.fade(FlxColor.BLACK, 0.6, true);
		return this;
	}

	// Teleport within this state
	public function teleport(tox:Float, toy:Float)
	{
		teleporting = true;
		FlxG.camera.fade(FlxColor.BLACK, 0.6, false, () ->
		{
			character.last.set(tox, toy);
			character.setPosition(tox, toy);
			character.setXY(Std.int((tox + Main.SPRITE_SIZE_HALF) / Main.SPRITE_SIZE), Std.int((toy + Main.SPRITE_SIZE_HALF) / Main.SPRITE_SIZE));
			FlxG.camera.focusOn(character.getMidpoint());
			FlxG.camera.fade(FlxColor.BLACK, 0.6, true);
			teleporting = false;
		});
	}
}
