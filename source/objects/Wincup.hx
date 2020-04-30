package objects;

import flixel.FlxSprite;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;

class Wincup extends FlxSprite
{
	public function new(x:Float, y:Float)
	{
		super(x, y);
		loadGraphic("assets/images/win.png");
		alpha = 1;
		scale.set(1, 1);
	}

	public function animateWin(complete:Void->Void)
	{
		FlxTween.tween(this, {"scale.x": 4.0, "scale.y": 4.0, "alpha": 0.2}, 2.0, {
			ease: FlxEase.cubeOut,
			type: ONESHOT,
			onComplete: (tw) ->
			{
				complete();
			}
		});
	}
}
