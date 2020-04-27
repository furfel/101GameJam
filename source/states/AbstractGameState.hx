package states;

import flixel.FlxBasic;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxPoint;

class AbstractGameState extends FlxState
{
	private var obstructs:FlxTypedGroup<FlxObject> = new FlxTypedGroup<FlxObject>(100);
	private var obstructArray:Array<Array<Bool>> = null;

	override function create()
	{
		super.create();
		add(obstructs);
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
		FlxG.camera.follow(char, TOPDOWN, 1.0);
	}
}
