package;

import lime.utils.Assets;
import haxe.Json;
import haxe.format.JsonParser;

using StringTools;

typedef SongData =
{
	var offset:Float;
	var difficultyCount:Int;
	var difficultyNames:Array<String>;
}

class CoolUtil
{
	public static var difficultyArray:Array<String> = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10"];

	public static function difficultyFromInt(difficulty:Int):String
	{
		return difficultyArray[difficulty];
	}

	/*inline static public function parseSongJSON(key:String)
	{
		return haxe.Json.parse(Assets.getText(Paths.json(key)));
	}*/

	inline static public function parseOffset(key:String):Float
	{
		//var man = haxe.Json.parse(Assets.getText(Paths.json('${key}/songData')));
		return haxe.Json.parse(Assets.getText(Paths.json('${key}/songData'))).offset;
	}

	inline static public function parseDiffCount(key:String):Int
	{
		var man = haxe.Json.parse(Assets.getText(Paths.json('${key}/songData')));
		return man.difficultyCount - 1; // fLoAt ShOuLd Be InT why????
	}

	inline static public function parseDiffNames(key:String):String // use only in FreeplayState!
	{
		//var man = haxe.Json.parse(Assets.getText(Paths.json('${key}/songData')));
		return haxe.Json.parse(Assets.getText(Paths.json('${key}/songData'))).difficultyNames[FreeplayState.curDifficulty];
	}

	public static function coolTextFile(path:String):Array<String>
	{
		var daList:Array<String> = Assets.getText(path).trim().split('\n');

		for (i in 0...daList.length)
		{
			daList[i] = daList[i].trim();
		}

		return daList;
	}
	
	public static function coolStringFile(path:String):Array<String>
		{
			var daList:Array<String> = path.trim().split('\n');
	
			for (i in 0...daList.length)
			{
				daList[i] = daList[i].trim();
			}
	
			return daList;
		}

	public static function numberArray(max:Int, ?min = 0):Array<Int>
	{
		var dumbArray:Array<Int> = [];
		for (i in min...max)
		{
			dumbArray.push(i);
		}
		return dumbArray;
	}
}
