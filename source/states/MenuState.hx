package states;

import objects.*;

class MenuState extends AbstractGameState
{
	override function create()
	{
		super.create();
		addObstructing(new Wall(100, 100, 320, 64));
		addObstructing(new Wall(100, 100, 64, 320));
		addObstructing(new Wall(100, 420, 352, 64));
		addObstructing(new Wall(420, 100, 64, 352));
		add(new Character(3, 3, this));

		postCreateTrigger();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}
