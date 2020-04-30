package;

import flash.events.Event;
import flixel.addons.display.FlxPieDial;
import flixel.system.FlxBasePreloader;
import flixel.util.FlxColor;
import openfl.Lib;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.Sprite;

@:keep @:bitmap("assets/images/preloader.jpg")
private class PreloaderBitmap extends BitmapData {}

class Preloader extends FlxBasePreloader
{
	public function new()
	{
		super(MIN_TIME);
	}

	var _buffer:Sprite;
	var bitmap:Bitmap;
	var pieDial:Sprite;

	private var startTime:Float = 0.0;
	private var endTime:Float = 1.0;

	public static final MIN_TIME = 5;

	override function create()
	{
		_buffer = new Sprite();
		addChild(_buffer);
		_buffer.addChild(new Bitmap(new BitmapData(800, 600, 0x000000)));

		bitmap = createBitmap(PreloaderBitmap, (bbitmap) ->
		{
			var aspect = bbitmap.width / bbitmap.height;
			bbitmap.width = Lib.current.stage.stageWidth;
			bbitmap.height = bbitmap.width / aspect;
			bbitmap.x = 0;
			bbitmap.y = Lib.current.stage.stageHeight / 2 - bbitmap.height / 2;
		});
		bitmap.smoothing = true;
		bitmap.alpha = 0;
		_buffer.addChild(bitmap);

		startTime = Date.now().getTime();
		endTime = MIN_TIME * 1000;

		super.create();
	}

	override function destroy()
	{
		if (_buffer != null)
			removeChild(_buffer);
		_buffer = null;
		bitmap = null;
		super.destroy();
	}

	private inline function calculatePercentOfTime():Float
	{
		return (Date.now().getTime() - startTime) / endTime;
	}

	override function onEnterFrame(E:Event)
	{
		super.onEnterFrame(E);
		var percentTime = calculatePercentOfTime();
		if (percentTime > 0.9 && bitmap != null)
		{
			bitmap.alpha = Math.max(0, 1.0 - (percentTime - 0.9) * 10);
		}
		else if (percentTime <= 0.1 && bitmap != null)
		{
			bitmap.alpha = Math.min(1, percentTime * 10);
		}
	}

	override function update(Percent:Float)
	{
		super.update(Percent);
	}
}
