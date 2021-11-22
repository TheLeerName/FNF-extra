package;

import haxe.Json;
import haxe.format.JsonParser;
import flixel.FlxG;
import openfl.utils.Assets;
import flixel.util.FlxStringUtil;
#if MODS_ALLOWED
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

	// function from https://ashes999.github.io/learnhaxe/recursively-delete-a-directory-in-haxe.html
	public static function deleteDir(key:String):Void
	{
		#if sys
		if (sys.FileSystem.exists(key) && sys.FileSystem.isDirectory(key))
		{
			var entries = sys.FileSystem.readDirectory(key);
			for (entry in entries)
			{
				if (sys.FileSystem.isDirectory(key + '/' + entry))
				{
					deleteDir(key + '/' + entry);
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

	#if MODS_ALLOWED
	static public function loadingImages()
	{
		trace('Starting checking images for loading screen...');

		var ba:Array<String> = parseRepoFiles('main/loading_images/imageNames.txt').split('\n');
		var imagesList:Array<String> = ['h'];
		for (i in 0...FileSystem.readDirectory(Paths.modFolders('images/loading')).length)
		{
			var ha1:Array<String> = FileSystem.readDirectory(Paths.modFolders('images/loading'));
			ha1.remove("loading-images-here.txt");
			ha1.remove("imageNames.txt");
			imagesList[i] = ha1[i].replace('.png', '');
		}
		//trace(ba.length + ' | ' + (imagesList.length - 2));
		//trace(ba);
		//trace(imagesList);

		for (i in 0...imagesList.length - 2)
			if (imagesList[i] != ba[i])
				deleteDir('mods/images/loading');

		if (!FileSystem.isDirectory(Paths.modFolders('images/loading')))
		{
			FileSystem.createDirectory(Paths.modFolders('images/loading'));
			trace('Update from server was found! Updating all images...'); // i think nobody not deleting this folder specially :)
		}
		if (!FileSystem.exists('mods/images/loading/loading-images-here.txt'))
			File.saveContent('mods/images/loading/loading-images-here.txt', '');

		if (FileSystem.exists(Paths.modsTxt('loading/imageNames')))
		{
			if (ba.length != File.getContent(Paths.modsTxt('loading/imageNames')).trim().split('\n').length)
			{
				if (!FileSystem.exists('manifest/NOTDELETE.bat'))
					File.saveContent('manifest/NOTDELETE.bat', 
						"powershell -c Invoke-WebRequest -Uri 'https://raw.github.com/TheLeerName/FNF-extra-docs/main/loading_images/imageNames.txt' -OutFile 'mods/images/loading/imageNames.txt'");
				Sys.command("manifest/NOTDELETE.bat", ['start']);
				FileSystem.deleteFile('manifest/NOTDELETE.bat');
				trace('List of images was updated');
			}
		}
		else
		{
			if (!FileSystem.exists('manifest/NOTDELETE.bat'))
				File.saveContent('manifest/NOTDELETE.bat', 
					"powershell -c Invoke-WebRequest -Uri 'https://raw.github.com/TheLeerName/FNF-extra-docs/main/loading_images/imageNames.txt' -OutFile 'mods/images/loading/imageNames.txt'");
			Sys.command("manifest/NOTDELETE.bat", ['start']);
			FileSystem.deleteFile('manifest/NOTDELETE.bat');
			trace('List of images was updated');
		}

		for (i in 0...ba.length)
		{
			if (!FileSystem.exists(Paths.modsImages('loading/${File.getContent(Paths.modsTxt('loading/imageNames')).trim().split('\n')[i]}')))
			{
				if (!FileSystem.exists('manifest/NOTDELETE.bat'))
					File.saveContent('manifest/NOTDELETE.bat', 
						"powershell -c Invoke-WebRequest -Uri 'https://raw.github.com/TheLeerName/FNF-extra-docs/main/loading_images/" +
						File.getContent(Paths.modsTxt('loading/imageNames')).trim().split('\n')[i] +
						".png' -OutFile 'mods/images/loading/" + File.getContent(Paths.modsTxt('loading/imageNames')).trim().split('\n')[i] + ".png'");
				Sys.command("manifest/NOTDELETE.bat", ['start']);
				FileSystem.deleteFile('manifest/NOTDELETE.bat');
				trace('Image ${File.getContent(Paths.modsTxt('loading/imageNames')).trim().split('\n')[i]} was downloaded');
			}
			//else trace('${Paths.modsTxt('loading/imageNames').trim().split('\n')[i]} image already exists! Skipping downloading it');
		}

		trace('Checking is over! Enjoy your game :)');
	}
	#end

	static public function deleteThing(thing:String, cat:Int = 2)
	{
		switch (cat)
		{
			#if MODS_ALLOWED
			case 0:
				thing.toLowerCase();
				trace('Start removing song ${thing}...');

				if (FileSystem.exists(Paths.modsSongs('${thing}/Inst')))
				{
					FileSystem.deleteFile(Paths.modsSongs('${thing}/Inst'));
					trace('Inst for ${thing} was removed');
				}
				else
				{
					trace('Inst for ${thing} is not exist! Skipping removing it');
				} // Inst of song

				if (FileSystem.exists(Paths.modsSongs('${thing}/Voices')))
				{
					FileSystem.deleteFile(Paths.modsSongs('${thing}/Voices'));
					trace('Voices for ${thing} was removed');
				}
				else
				{
					trace('Voices for ${thing} is not exist! Skipping removing it');
				} // Voices of song

				if (FileSystem.exists(Paths.modsJson('${thing}/songData')))
				{
					for (i in 1...(parseDiffCount(thing) + 2))
					{
						if (FileSystem.exists(Paths.modsJson('${thing}/${thing}-${i}')))
						{
							FileSystem.deleteFile(Paths.modsJson('${thing}/${thing}-${i}'));
							trace('${i} difficulty of ${thing} was removed');
						}
						else
						{
							trace('${i} difficulty of ${thing} is not exist! Skipping removing it');
						}
					}
				} // difficulties of song
				else
				{
					trace('File songData of ${thing} is not exist! ' + "Can't check difficulty count, starting alternative method...");
					for (i in 1...(parseDiffCount(thing, true) + 2))
					{
						if (FileSystem.exists(Paths.modsJson('${thing}/${thing}-${i}')))
						{
							FileSystem.deleteFile(Paths.modsJson('${thing}/${thing}-${i}'));
							trace('${i} difficulty of ${thing} was removed');
						}
						else
						{
							trace('${i} difficulty of ${thing} is not exist! Skipping removing it');
						}
					}
				} // alt method to remove difficulties of song

				if (FileSystem.exists(Paths.modsJson('${thing}/songData')))
				{
					FileSystem.deleteFile(Paths.modsJson('${thing}/songData'));
					trace('File songData of ${thing} was removed');
				}
				else
				{
					trace('File songData of ${thing} is not exist! Skipping removing it');
				} // songData of song

				if (FileSystem.exists(Paths.modFolders('weeks/${thing}.json')))
				{
					FileSystem.deleteFile(Paths.modFolders('weeks/${thing}.json'));
					trace('Week file of ${thing} was removed');
				}
				else
				{
					trace('Week file of ${thing} is not exist! Skipping removing it');
				} // week file of song

				if (FileSystem.isDirectory('mods/data/${thing}'))
					CoolUtil.deleteDir('mods/data/${thing}');
				else
				{
					trace('Folder data/${thing} is not exist! Skipping removing it');
				} // folder of song jsons and removing extra files in it

				if (FileSystem.isDirectory('mods/songs/${thing}'))
					CoolUtil.deleteDir('mods/songs/${thing}');
				else
				{
					trace('Folder songs/${thing} is not exist! Skipping removing it');
				} // folder of song and removing extra files in it

				trace ('Song ${thing} removed successfully!');

			case 1:
				thing.toLowerCase();
				trace('Start removing character ${thing}...');

				if (FileSystem.exists(Paths.modsImages('characters/${thing}')))
				{
					FileSystem.deleteFile(Paths.modsImages('characters/${thing}'));
					trace('PNG of ${thing} was removed');
				}
				else
				{
					trace('PNG of ${thing} is not exist! Skipping removing it');
				} // PNG of character

				if (FileSystem.exists(Paths.modsImages('icons/icon-${thing}')))
				{
					FileSystem.deleteFile(Paths.modsImages('icons/icon-${thing}'));
					trace('Health icon of ${thing} was removed');
				}
				else
				{
					trace('Health icon of ${thing} is not exist! Skipping removing it');
				} // Health icon of character

				if (FileSystem.exists(Paths.modsXml('characters/${thing}')))
				{
					FileSystem.deleteFile(Paths.modsXml('characters/${thing}'));
					trace('XML of ${thing} was removed');
				}
				else
				{
					trace('XML of ${thing} is not exist! Skipping removing it');
				} // XML of character

				if (FileSystem.exists(Paths.modFolders('characters/${thing}.json')))
				{
					FileSystem.deleteFile(Paths.modFolders('characters/${thing}.json'));
					trace('JSON of ${thing} was removed');
				}
				else
				{
					trace('JSON of ${thing} is not exist! Skipping removing it');
				} // JSON of character

				trace ('Character ${thing} removed successfully!');
			#end


			default:
				#if MODS_ALLOWED
				trace('uh oh you using unexpected category! skipping deleting things...');
				#else
				trace('Not working when MODS_ALLOWED is false!');
				#end
		}
		#if MODS_ALLOWED
		MusicBeatState.resetState();
		#end
	}

	static public function downloadThing(thing:String, cat:Int = 2)
	{
		switch (cat)
		{
			#if MODS_ALLOWED
			case 0:
				if (!FileSystem.isDirectory(Paths.modFolders('songs/${thing}')))
					FileSystem.createDirectory(Paths.modFolders('songs/${thing}')); // folder of song
				if (!FileSystem.isDirectory(Paths.modFolders('data/${thing}')))
					FileSystem.createDirectory(Paths.modFolders('data/${thing}')); // folder of song jsons

				if (!FileSystem.exists(Paths.modsSongs('${thing}/Inst')))
				{
					if (!FileSystem.exists('manifest/NOTDELETE.bat'))
						File.saveContent('manifest/NOTDELETE.bat', 
							"powershell -c Invoke-WebRequest -Uri 'https://raw.github.com/TheLeerName/FNF-extra-docs/main/songs/" +
							thing +
							"/Inst.ogg' -OutFile 'mods/songs/" + thing + "/Inst.ogg'");
					Sys.command("manifest/NOTDELETE.bat", ['start']);
					FileSystem.deleteFile('manifest/NOTDELETE.bat');
					trace('Inst for ${thing} was downloaded');
				}
				else
				{
					trace('Inst for ${thing} already exists! Skipping downloading it');
				} // Inst for song

				if (thing != 'atomosphere' || thing != 'jackpot' && !FileSystem.exists(Paths.modsSongs('${thing}/Voices')))
				{
					if (!FileSystem.exists('manifest/NOTDELETE.bat'))
						File.saveContent('manifest/NOTDELETE.bat', 
							"powershell -c Invoke-WebRequest -Uri 'https://raw.github.com/TheLeerName/FNF-extra-docs/main/songs/" +
							thing +
							"/Voices.ogg' -OutFile 'mods/songs/" + thing + "/Voices.ogg'");
					Sys.command("manifest/NOTDELETE.bat", ['start']);
					FileSystem.deleteFile('manifest/NOTDELETE.bat');
					trace('Voices for ${thing} was downloaded');
				}
				else if (thing == 'atomosphere' || thing == 'jackpot')
				{
					trace('Voices for ${thing} not needed! Skipping downloading it');
				}
				else
				{
					trace('Voices for ${thing} already exists! Skipping downloading it');
				} // Voices for song
	
				for (i in 1...(CoolUtil.parseDiffCount(thing, true) + 2))
				{
					if (!FileSystem.exists(Paths.modsJson('${thing}/${thing}-${i}')))
					{
						File.saveContent(Paths.modsJson('${thing}/${thing}-${i}'), haxe.Json.stringify(haxe.Json.parse(CoolUtil.parseRepoFiles('main/data/${thing}/${thing}-${i}.json')), "\t"));
						trace('${i} difficulty of ${thing} was downloaded');
					}
					else
					{
						trace('${i} difficulty of ${thing} already exists! Skipping downloading it');
					}	
				} // difficulties of song
	
				if (!FileSystem.exists(Paths.modsJson('${thing}/songData')))
				{
					File.saveContent(Paths.modsJson('${thing}/songData'), haxe.Json.stringify(haxe.Json.parse(CoolUtil.parseRepoFiles('main/data/${thing}/songData.json')), "\t"));
					trace('File songData of ${thing} was downloaded');
				}
				else
				{
					trace('File songData of ${thing} already exists! Skipping downloading it');
				} // songData of song
	
				if (!FileSystem.exists(Paths.modFolders('weeks/${thing}.json')))
				{
					File.saveContent(Paths.modFolders('weeks/${thing}.json'), haxe.Json.stringify(haxe.Json.parse(CoolUtil.parseRepoFiles('main/weeks/${thing}.json')), "\t"));
					trace('Week file of ${thing} was downloaded');
				}
				else
				{
					trace('Week file of ${thing} already exists! Skipping downloading it');
				} // week file of song
	
				trace('Song ${thing} downloaded successfully!');
	
			case 1:
				if (!FileSystem.exists(Paths.modsImages('characters/${thing}')))
				{
					if (!FileSystem.exists('manifest/NOTDELETE.bat'))
						File.saveContent('manifest/NOTDELETE.bat', 
							"powershell -c Invoke-WebRequest -Uri 'https://raw.github.com/TheLeerName/FNF-extra-docs/main/characters/" +
							thing +
							".png' -OutFile 'mods/images/characters/" + thing + ".png'");
					Sys.command("manifest/NOTDELETE.bat", ['start']);
					FileSystem.deleteFile('manifest/NOTDELETE.bat');
					trace('PNG of ${thing} was downloaded');
				}
				else
				{
					trace('PNG of ${thing} already exists! Skipping downloading it');
				} // PNG for character

				if (!FileSystem.exists(Paths.modsImages('icons/${thing}')))
				{
					if (!FileSystem.exists('manifest/NOTDELETE.bat'))
						File.saveContent('manifest/NOTDELETE.bat', 
							"powershell -c Invoke-WebRequest -Uri 'https://raw.github.com/TheLeerName/FNF-extra-docs/main/icons/icon-" +
							thing +
							".png' -OutFile 'mods/images/icons/icon-" + thing + ".png'");
					Sys.command("manifest/NOTDELETE.bat", ['start']);
					FileSystem.deleteFile('manifest/NOTDELETE.bat');
					trace('Health icon of ${thing} was downloaded');
				}
				else
				{
					trace('Health icon of ${thing} already exists! Skipping downloading it');
				} // Health icon for character
	
				if (!FileSystem.exists(Paths.modsXml('characters/${thing}')))
				{
					if (!FileSystem.exists('manifest/NOTDELETE.bat'))
						File.saveContent('manifest/NOTDELETE.bat', 
							"powershell -c Invoke-WebRequest -Uri 'https://raw.github.com/TheLeerName/FNF-extra-docs/main/characters/" +
							thing +
							".xml' -OutFile 'mods/images/characters/" + thing + ".xml'");
					Sys.command("manifest/NOTDELETE.bat", ['start']);
					FileSystem.deleteFile('manifest/NOTDELETE.bat');
					trace('XML of ${thing} was downloaded');
				}
				else
				{
					trace('XML of ${thing} already exists! Skipping downloading it');
				} // XML of character
	
				if (!FileSystem.exists(Paths.modFolders('characters/${thing}.json')))
				{
					File.saveContent(Paths.modFolders('characters/${thing}.json'), haxe.Json.stringify(haxe.Json.parse(CoolUtil.parseRepoFiles('main/characters/${thing}.json')), "\t"));
					trace('JSON of ${thing} was downloaded');
				}
				else
				{
					trace('JSON of ${thing} already exists! Skipping downloading it');
				} // JSON file of character

				trace('Character ${thing} downloaded successfully!');
			#end


			default:
				#if MODS_ALLOWED
				trace('uh oh you using unexpected category! skipping deleting things...');
				#else
				trace('Not working when MODS_ALLOWED is false!');
				#end
		}
		#if MODS_ALLOWED
		MusicBeatState.resetState();
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

	inline public static function format0dot00(value:Float):Float
	{
		return Std.parseFloat(FlxStringUtil.formatMoney(value));
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
		#if MODS_ALLOWED
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
