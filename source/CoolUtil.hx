package;

import haxe.Json;
import haxe.format.JsonParser;
import flixel.FlxG;
import openfl.utils.Assets;
import lime.utils.Assets as LimeAssets;
import lime.utils.AssetLibrary;
import lime.utils.AssetManifest;
#if sys
import sys.io.File;
import sys.FileSystem;
#end

using StringTools;

typedef SongData =
{
	var offset:Float;
	var difficultyCount:Int;
	var difficultyNames:Array<String>;
}

class CoolUtil
{
	// [Difficulty name, Chart file suffix]
	public static var difficultyStuff:Array<Dynamic> = [
		['1', '-1'],
		['2', '-2'],
		['3', '-3'],
		['4', '-4'],
		['5', '-5'],
		['6', '-6'],
		['7', '-7'],
		['8', '-8'],
		['9', '-9'],
		['10', '-10']
	];

	/*public static function difficultyString():String
	{
		return difficultyStuff[PlayState.storyDifficulty][0].toUpperCase();
	}*/

	/*inline static public function parseSongDataJSON(key:String) // disabled since i made better functions
	{
		return haxe.Json.parse(Assets.getText(Paths.json('${key}/songData')));
	}*/

	inline static public function parseOffset(key:String):Float
	{
		return haxe.Json.parse(lime.utils.Assets.getText(Paths.json('${key}/songData'))).offset;
	}

	inline static public function parseDiffCount(key:String):Int
	{
		var man = haxe.Json.parse(lime.utils.Assets.getText(Paths.json('${key}/songData')));
		return man.difficultyCount - 1; // fLoAt ShOuLd Be InT why????
	}

	inline static public function parseDiffNames(key:String, curDifficulty:Int):String
	{
		return haxe.Json.parse(lime.utils.Assets.getText(Paths.json('${key}/songData'))).difficultyNames[curDifficulty].toUpperCase();
	}

	public static function boundTo(value:Float, min:Float, max:Float):Float {
		var newValue:Float = value;
		if(newValue < min) newValue = min;
		else if(newValue > max) newValue = max;
		return newValue;
	}

	public static function coolTextFile(path:String):Array<String>
	{
		var daList:Array<String> = [];
		#if sys
		if(FileSystem.exists(path)) daList = File.getContent(path).trim().split('\n');
		#else
		if(Assets.exists(path)) daList = Assets.getText(path).trim().split('\n');
		#end

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

	//uhhhh does this even work at all? i'm starting to doubt
	public static function precacheSound(sound:String, ?library:String = null):Void {
		if(!Assets.cache.hasSound(Paths.sound(sound, library))) {
			FlxG.sound.cache(Paths.sound(sound, library));
		}
	}

	public static function browserLoad(site:String) {
		#if linux
		Sys.command('/usr/bin/xdg-open', [site]);
		#else
		FlxG.openURL(site);
		#end
	}
}
