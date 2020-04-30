package states;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxPoint;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import hud.Healthbar;
import objects.*;

class PlayState extends AbstractGameState
{
	override public function create()
	{
		super.create();

		keys = new FlxTypedGroup<Key>();
		healthbars = new FlxTypedGroup<Healthbar>();

		coffins = new FlxTypedGroup<Coffin>();
		add(coffins);

		new GameMap("assets/data/dungeon.tmx", this);
		FlxG.camera.zoom = 2;

		add(keys);
		add(potions);

		add(gravemen = new FlxTypedGroup<Graveman>());
		add(stones = new FlxTypedGroup<Stone>());
		add(healthbars);

		postCreateTrigger();
	}

	override function destroy()
	{
		if (character != null)
			remove(character);

		if (gravemen != null)
			remove(gravemen);

		gravemen = null;

		if (keys != null)
			remove(keys);
		keys = null;

		if (coffins != null)
			remove(coffins);
		coffins = null;

		if (healthbars != null)
			remove(healthbars);
		healthbars = null;

		super.destroy();
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		if (gameOver)
			return;

		FlxG.overlap(character, potions, (c, p) ->
		{
			if ((p is Potion) && cast(p, Potion).alive)
			{
				cast(p, Potion).addHp(character);
			}
		});

		FlxG.overlap(character, stones, (c, stone) ->
		{
			if ((stone is Stone) && cast(stone, Stone).alive)
				cast(stone, Stone).takeHp(character);
		});

		if (character.health <= 0)
		{
			gameOver = true;
			endGame();
			return;
		}

		FlxG.overlap(character, keys, (c, key) ->
		{
			if ((key is Key) && cast(key, Key).alive)
			{
				FlxG.sound.play("assets/sounds/key.ogg");
				character.addKey(cast(key, Key).name);
				cast(key, Key).kill();
			}
		});

		if (!winned && winCup != null && winCup.getHitbox().containsPoint(character.getMidpoint()))
			winGame();

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

	override function addCharacter(char:Character)
	{
		super.addCharacter(char);
		this.character = char;
		this.healthbars.add(char.getHealthbar());
	}

	private var healthbars:FlxTypedGroup<Healthbar>;

	public function removeHealthbar(hb:Healthbar)
		healthbars.remove(hb);

	private var doors:FlxTypedGroup<Door>;

	public function addDoors(doors:Array<Door>)
	{
		this.doors = new FlxTypedGroup<Door>();
		for (d in doors)
			this.doors.add(d);
		add(this.doors);
	}

	private var coffins:FlxTypedGroup<Coffin>;

	public function addCoffin(coffin:Coffin)
		coffins.add(coffin);

	private var keys:FlxTypedGroup<Key>;

	public function addKey(key:Key)
		keys.add(key);

	private var gravemen:FlxTypedGroup<Graveman>;

	public function getGravemen():FlxTypedGroup<Graveman>
		return gravemen;

	public function addGraveman(graveman:Graveman)
	{
		gravemen.add(graveman);
		healthbars.add(graveman.getHealthbar());
	}

	public function removeGraveman(g:Graveman)
		gravemen.remove(g);

	private var winCup:Wincup;

	public function addWin(w:Wincup)
		add(winCup = w);

	private var stones:FlxTypedGroup<Stone>;

	public function addStone(st:Stone)
		if (stones != null)
			stones.add(st);

	public function removeStone(st:Stone)
		if (st != null && stones != null)
			stones.remove(st);

	private var potions:FlxTypedGroup<Potion> = new FlxTypedGroup<Potion>();

	public function addPotion(p:Potion)
		potions.add(p);

	private var winned = false;

	public function winGame()
	{
		winned = true;
		character.lock();
		remove(winCup);
		insert(members.length, winCup = new Wincup(winCup.x, winCup.y));
		winCup.animateWin(onCompleteWin);
	}

	private var gameOver = false;

	public function endGame()
	{
		gameOver = true;
		character.lock();
		FlxG.camera.fade(FlxColor.BLACK, 0.4, () ->
		{
			new FlxTimer().start(0.9, (_) ->
			{
				FlxG.switchState(new MenuState());
			});
		});
	}

	public function onCompleteWin()
	{
		new FlxTimer().start(2.0, (tmr) ->
		{
			FlxG.camera.fade(FlxColor.BLACK, 1.0, () ->
			{
				FlxG.switchState(new WinState());
			});
		});
	}
}
