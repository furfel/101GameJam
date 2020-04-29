package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.addons.editors.tiled.*;
import flixel.addons.tile.FlxTilemapExt;
import flixel.tile.FlxTilemap;
import objects.*;
import states.AbstractGameState;
import states.PlayState;

class GameMap
{
	public static final BLOCK_TRESHOLD = 8;

	private var map:TiledMap;

	public function new(asset:String, state:AbstractGameState)
	{
		map = new TiledMap(asset);

		state.resizeObstructs(map.width, map.height);

		insertLayer(state, cast map.getLayer("ground"), false);
		insertLayer(state, cast map.getLayer("middle"), false);

		var doors = new Array<Door>();
		var character:Character = null;

		var O:TiledObjectLayer = cast map.getLayer("O");
		for (o in O.objects)
		{
			if (o.type == "player")
				character = new Character(Std.int(o.x / map.tileWidth), Std.int(o.y / map.tileHeight), state);
			else if (o.type == "coffin" && (state is PlayState))
			{
				cast(state, PlayState).addCoffin(new Coffin(o, state));
			}
			else if (o.type == "door")
			{
				doors.push(Door.fromTiledObject(o, state));
			}
			else if (o.type == "target")
			{
				state.teleportPointsArray.set(o.name, [o.x, o.y]);
			}
			else if (o.type == "key" && (state is PlayState))
				cast(state, PlayState).addKey(new Key(o));
		}

		for (door in doors)
		{
			if (state.teleportPointsArray.exists(door.getTargetName()))
			{
				door.updateTarget(state.teleportPointsArray.get(door.getTargetName()));
			}
		}

		if ((state is PlayState))
			cast(state, PlayState).addDoors(doors);

		if (character != null)
			state.addCharacter(character);

		insertLayer(state, cast map.getLayer("walls"), true);
		insertLayer(state, cast map.getLayer("objects"), true);

		FlxG.worldBounds.set(0, 0, map.fullWidth, map.fullHeight);
	}

	function insertLayer(state:AbstractGameState, layer:TiledTileLayer, blocking:Bool = false)
	{
		var tilesExt = new FlxTilemapExt();
		tilesExt.loadMapFromArray(layer.tileArray, map.width, map.height, "assets/images/sprites.png", 32, 32, OFF, 1, 0);
		state.add(tilesExt);

		if (blocking)
			for (x in 0...map.width - 1)
				for (y in 0...map.height - 1)
					if (layer.tileArray[map.width * y + x] > BLOCK_TRESHOLD)
						state.setBlocking(x, y, true);
	}
}
