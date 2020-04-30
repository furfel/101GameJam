package states;

import flixel.FlxG;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import lime.app.Application;
import objects.*;

class MenuState extends AbstractGameState
{
	private var labels:FlxTypedGroup<Sign> = new FlxTypedGroup<Sign>();
	private var logo:FlxText;

	override function create()
	{
		super.create();

		logo = new FlxText(0, 0, FlxG.width, "Gravey's Dungeon", 64);
		logo.setFormat("assets/Almendra.ttf", 64, FlxColor.WHITE, CENTER, OUTLINE_FAST, FlxColor.WHITE);
		logo.y = 120;
		logo.screenCenter(X);
		logo.alpha = 0;
		logo.scrollFactor.set(0, 0);

		new GameMap("assets/data/menu.tmx", this);

		add(labels);
		add(logo);

		animateLogo();

		postCreateTrigger();
	}

	private function animateLogo()
	{
		new FlxTimer().start(1.0, (t) ->
		{
			FlxTween.tween(logo, {alpha: 1}, 0.5, {
				type: ONESHOT,
				ease: FlxEase.quadIn,
				onComplete: (tw) ->
				{
					FlxTween.color(logo, 0.5, FlxColor.WHITE, FlxColor.fromRGB(30, 30, 30), {
						type: ONESHOT,
						ease: FlxEase.cubeOut
					});
				}
			});
		});

		new FlxTimer().start(0.5, _ ->
		{
			FlxTween.num(1.0, 1.5, 0.9, {type: ONESHOT, ease: FlxEase.cubeOut}, (f) ->
			{
				FlxG.camera.zoom = f;
			});
		});
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (goPlay || goExit)
			return;

		FlxG.overlap(character, playDoor, (c, d) ->
		{
			if ((d is Door))
			{
				goPlay = true;
				playGame();
			}
		});

		FlxG.overlap(character, exitDoor, (c, d) ->
		{
			if ((d is Door))
			{
				goExit = true;
				exitGame();
			}
		});
	}

	override function destroy()
	{
		if (playDoor != null)
			remove(playDoor);

		playDoor = null;

		if (exitDoor != null)
			remove(exitDoor);

		exitDoor = null;

		super.destroy();
	}

	private var goExit = false;

	private function exitGame()
	{
		FlxG.camera.fade(FlxColor.BLACK, 0.5, false, () ->
		{
			Application.current.window.close();
		});
	}

	private var goPlay = false;

	private function playGame()
	{
		FlxG.camera.fade(FlxColor.BLACK, 0.5, false, () ->
		{
			new FlxTimer().start(1.0, (t) ->
			{
				FlxG.camera.follow(null);
				FlxG.switchState(new PlayState());
			});
		});
	}

	private var playDoor:Door;
	private var exitDoor:Door;

	public function addPlayDoor(d:Door)
	{
		add(playDoor = d);
		labels.add(new Sign(d.getMidpoint().x, d.getMidpoint().y, "Play"));
	}

	public function addExitDoor(d:Door)
	{
		add(exitDoor = d);
		labels.add(new Sign(d.getMidpoint().x, d.getMidpoint().y, "Exit"));
	}
}
