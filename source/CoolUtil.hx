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

	inline static public function parseRepoFiles(key:String)
	{
		var http = new haxe.Http('https://raw.githubusercontent.com/TheLeerName/FNF-extra-docs/${key}');
		var returnedData:Dynamic;
		http.onData = function(data) {
			returnedData = data;
			//trace(returnedData);
		}
		http.onError = function(error) {
			trace('Error with parsing repo files (check your internet connection): $error');
		}
		http.request();
		return returnedData;
	}

	static var errors:Int;
	static public function downloadSong(song:String)
	{
		#if MODS_ALLOWED
		song.toLowerCase();
		trace('Start downloading song ${song}...');

		if (!FileSystem.isDirectory(Paths.modFolders('songs/${song}')))
			FileSystem.createDirectory(Paths.modFolders('songs/${song}')); // folder of song
		/*if (!FileSystem.exists(Paths.modsSongs('${song}/Inst')))
		{
			//File.saveContent(Paths.modsSongs('${song}/Inst'), parseRepoFiles('main/songs/${song}/Inst.ogg'));
			File.saveContent('mods/songs/${song}/Inst.txt', parseRepoFiles('main/songs/${song}/Inst.ogg'));
			trace('Inst for ${song} was downloaded');
		}
		else
		{
			trace('Inst for ${song} already exists! Skipping downloading it');
			errors++;
		} // Inst of song

		if (!FileSystem.exists(Paths.modsSongs('${song}/Vocals')) && haxe.Json.parse(parseRepoFiles('main/data/${song}/${song}-1.json')).song.needsVoices)
		{
			File.saveContent(Paths.modsSongs('${song}/Vocals'), parseRepoFiles('main/songs/${song}/Vocals.ogg'));
			trace('Vocals for ${song} was downloaded');
		}
		else if (!haxe.Json.parse(parseRepoFiles('main/data/${song}/${song}-1.json')).song.needsVoices)
		{
			trace('Vocals for ${song} not needed! Skipping downloading it');
		}
		else
		{
			trace('Vocals for ${song} already exists! Skipping downloading it');
			errors++;
		} // Vocals of song*/
		//var first:String = "";

		// i love hardcoding!!!
		if (!FileSystem.exists('manifest/NOTDELETE.bat'))
			File.saveContent('manifest/NOTDELETE.bat', 
			"powershell -c Invoke-WebRequest -Uri 'https://raw.github.com/TheLeerName/FNF-extra-docs/main/songs/" +
			song +
			"/Inst.ogg' -OutFile 'mods/songs/" + song + "/Inst.ogg'");
		Sys.command("manifest/NOTDELETE.bat", ['start']);
		FileSystem.deleteFile('manifest/NOTDELETE.bat');
		trace('Inst for ${song} was downloaded');

		if (song != 'atomosphere')
		{
			if (!FileSystem.exists('manifest/NOTDELETE.bat'))
				File.saveContent('manifest/NOTDELETE.bat', 
				"powershell -c Invoke-WebRequest -Uri 'https://raw.github.com/TheLeerName/FNF-extra-docs/main/songs/" +
				song +
				"/Vocals.ogg' -OutFile 'mods/songs/" + song + "/Vocals.ogg'");
			Sys.command("manifest/NOTDELETE.bat", ['start']);
			FileSystem.deleteFile('manifest/NOTDELETE.bat');
			trace('Vocals for ${song} was downloaded');
		}

		if (!FileSystem.isDirectory(Paths.modFolders('data/${song}')))
			FileSystem.createDirectory(Paths.modFolders('data/${song}')); // folder of song jsons
		for (i in 1...(parseDiffCount(song, true) + 2))
		{
			if (!FileSystem.exists(Paths.modsJson('${song}/${song}-${i}')))
			{
				File.saveContent(Paths.modsJson('${song}/${song}-${i}'), haxe.Json.stringify(haxe.Json.parse(parseRepoFiles('main/data/${song}/${song}-${i}.json')), "\t"));
				trace('${i} difficulty of ${song} was downloaded');
			}
			else
			{
				trace('${i} difficulty of ${song} already exists! Skipping downloading it');
				errors++;
			}
		} // difficulties of song

		if (!FileSystem.exists(Paths.modsJson('${song}/songData')))
		{
			File.saveContent(Paths.modsJson('${song}/songData'), haxe.Json.stringify(haxe.Json.parse(parseRepoFiles('main/data/${song}/songData.json')), "\t"));
			trace('songData of ${song} was downloaded');
		}
		else
		{
			trace('songData of ${song} already exists! Skipping downloading it');
			errors++;
		} // songData of song

		if (!FileSystem.exists(Paths.modFolders('weeks/${song}.json')))
		{
			File.saveContent(Paths.modFolders('weeks/${song}.json'), haxe.Json.stringify(haxe.Json.parse(parseRepoFiles('main/weeks/${song}.json')), "\t"));
			trace('${song}.json week file was downloaded');
		}
		else
		{
			trace('${song}.json week file already exists! Skipping downloading it');
			errors++;
		} // week file of song

		//File.saveContent('mods/songs/${song}.json', haxe.Json.stringify(haxe.Json.parse(parseRepoFiles('main/weeks/${song}.json')), "\t"));

		trace (errors == 0 ? 'Song ${song} downloaded successfully!' : 'Song ${song} downloaded with ${errors} errors.');
		MusicBeatState.resetState();
		#else
		trace('This function is disabled, when build is not sys!');
		#end
	}

	// function from https://ashes999.github.io/learnhaxe/recursively-delete-a-directory-in-haxe.html
	public static function deleteDirSong(key:String):Void
	{
		#if sys
		if (sys.FileSystem.exists(key) && sys.FileSystem.isDirectory(key))
		{
			var entries = sys.FileSystem.readDirectory(key);
			for (entry in entries)
			{
				if (sys.FileSystem.isDirectory(key + '/' + entry))
				{
					deleteDirSong(key + '/' + entry);
					sys.FileSystem.deleteDirectory(key + '/' + entry);
				}
				else
				{
					sys.FileSystem.deleteFile(key + '/' + entry);
				}
			}
			sys.FileSystem.deleteDirectory(key);
 		}
		#else
		trace('This function is disabled, when MODS_ALLOWED is false!');
		#end
	}

	static public function deleteSong(song:String)
	{
		#if MODS_ALLOWED
		song.toLowerCase();
		trace('Start removing song ${song}...');

		if (FileSystem.exists(Paths.modsSongs('${song}/Inst')))
		{
			FileSystem.deleteFile(Paths.modsSongs('${song}/Inst'));
			trace('Inst for ${song} was removed');
		}
		else
		{
			trace('Inst for ${song} is not exist! Skipping removing it');
			errors++;
		} // Inst of song

		if (FileSystem.exists(Paths.modsSongs('${song}/Vocals')))
		{
			FileSystem.deleteFile(Paths.modsSongs('${song}/Vocals'));
			trace('Vocals for ${song} was removed');
		}
		else
		{
			trace('Vocals for ${song} is not exist! Skipping removing it');
			//errors++;
		} // Vocals of song

		if (FileSystem.exists(Paths.modsJson('${song}/songData')))
		{
			for (i in 1...(parseDiffCount(song) + 2))
			{
				if (FileSystem.exists(Paths.modsJson('${song}/${song}-${i}')))
				{
					FileSystem.deleteFile(Paths.modsJson('${song}/${song}-${i}'));
					trace('${i} difficulty of ${song} was removed');
				}
				else
				{
					trace('${i} difficulty of ${song} is not exist! Skipping removing it');
					errors++;
				}
			}
		} // difficulties of song
		else
		{
			trace('songData of ${song} is not exist! ' + "Can't check difficulty count, starting alternative method...");
			errors++;
			for (i in 1...(parseDiffCount(song, true) + 2))
			{
				if (FileSystem.exists(Paths.modsJson('${song}/${song}-${i}')))
				{
					FileSystem.deleteFile(Paths.modsJson('${song}/${song}-${i}'));
					trace('${i} difficulty of ${song} was removed');
				}
				else
				{
					trace('${i} difficulty of ${song} is not exist! Skipping removing it');
					errors++;
				}
			}
		} // alt method to remove difficulties of song

		if (FileSystem.exists(Paths.modsJson('${song}/songData')))
		{
			FileSystem.deleteFile(Paths.modsJson('${song}/songData'));
			trace('songData of ${song} was removed');
		}
		else
		{
			trace('songData of ${song} is not exist! Skipping removing it');
			errors++;
		} // songData of song

		if (FileSystem.exists(Paths.modFolders('weeks/${song}.json')))
		{
			FileSystem.deleteFile(Paths.modFolders('weeks/${song}.json'));
			trace('${song} week file was removed');
		}
		else
		{
			trace('${song} week file is not exist! Skipping removing it');
			errors++;
		} // week file of song

		if (FileSystem.isDirectory('mods/data/${song}'))
			deleteDirSong('mods/data/${song}');
		else
		{
			trace('data/${song} folder is not exist! Skipping removing it');
			errors++;
		} // folder of song jsons and removing extra files in it

		if (FileSystem.isDirectory('mods/songs/${song}'))
			deleteDirSong('mods/songs/${song}');
		else
		{
			trace('songs/${song} folder is not exist! Skipping removing it');
			errors++;
		} // folder of song and removing extra files in it

		trace (errors == 0 ? 'Song ${song} removed successfully!' : 'Song ${song} removed with ${errors} errors.');
		errors = 0;
		MusicBeatState.resetState();
		#else
		trace('This function is disabled, when MODS_ALLOWED is false!');
		#end
	}

	/*inline static public function stringify(inDir:String, outDir:String)
	{
		#if sys
		File.saveContent(inDir, haxe.Json.stringify(haxe.Json.parse(parseRepoFiles(outDir)), "\t"));
		trace('Successfully downloaded file from ${outDir}, and saved to ${inDir}!');
		#else
		trace('This function is disabled, when build is not sys!');
		#end
	}
	// this three functions used for testing only!
	inline static public function parseRepoTest(key:String)
	{
		var man = haxe.Json.parse(parseRepoFiles(key)).difficultyNames;
		return 'Diffs from HTTP: ${man[0]}, ${man[1]}, ${man[2]}, ${man[3]}';
	}
	inline static public function parseSongDataJSON(key:String)
	{
		return haxe.Json.parse(Assets.getText(Paths.json('${key}/songData')));
	}*/

	inline static public function parseOffset(song:String, fromNet:Bool = false):Float
	{
		if (fromNet)
			return haxe.Json.parse(parseRepoFiles('main/data/${song}/songData.json')).offset;
		else
		{
			#if MODS_ALLOWED
			if (FileSystem.exists(Paths.modFolders('weeks/${song}.json')))
				return haxe.Json.parse(File.getContent(Paths.modsJson('${song}/songData'))).offset;
			else
				return haxe.Json.parse(openfl.utils.Assets.getText('assets/data/${song}/songData.json')).offset;
			#else
			trace('This function is disabled, when MODS_ALLOWED is false!');
			return 0;
			#end
		}
	}
	inline static public function parseDiffCount(song:String, fromNet:Bool = false):Int
	{
		if (fromNet)
		{
			return Std.int(haxe.Json.parse(parseRepoFiles('main/data/${song}/songData.json')).difficultyCount - 1);
		}
		else
		{
			#if MODS_ALLOWED
			if (FileSystem.exists(Paths.modFolders('weeks/${song}.json')))
				return Std.int(haxe.Json.parse(File.getContent(Paths.modsJson('${song}/songData'))).difficultyCount - 1);
			else
				return Std.int(haxe.Json.parse(openfl.utils.Assets.getText('assets/data/${song}/songData.json')).difficultyCount - 1);
			#else
			trace('This function is disabled, when MODS_ALLOWED is false!');
			return 3;
			#end
		}
	}
	inline static public function parseDiffNames(song:String, curDifficulty:Int, fromNet:Bool = false):String
	{
		if (fromNet)
			return haxe.Json.parse(parseRepoFiles('main/data/${song}/songData.json')).difficultyNames[curDifficulty].toUpperCase();
		{
			#if MODS_ALLOWED
			if (FileSystem.exists(Paths.modFolders('weeks/${song}.json')))
				return haxe.Json.parse(File.getContent(Paths.modsJson('${song}/songData'))).difficultyNames[curDifficulty].toUpperCase();
			else
				return haxe.Json.parse(openfl.utils.Assets.getText('assets/data/${song}/songData.json')).difficultyNames[curDifficulty].toUpperCase();
			#else
			trace('This function is disabled, when MODS_ALLOWED is false!');
			return 'NORMAL';
			#end
		}
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
