package objects;

class Loosepants extends Npc
{
	override function createSprite()
	{
		loadGraphic("assets/images/npc1.png", true, 32, 32);
		animation.add("", [0, 1], 4);
		animation.play("");
	}

	override function action() {}
}
