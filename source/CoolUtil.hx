package;

import haxe.Json;
import haxe.format.JsonParser;
import flixel.FlxG;
import openfl.utils.Assets;
import lime.app.Application;
import flixel.addons.transition.FlxTransitionableState;
#if MODS_ALLOWED
import sys.io.File;
import sys.FileSystem;
#end

using StringTools;

typedef Diff =
{
	var names:Array<String>;
	var needUpperCase:Bool;	
}
typedef Uses =
{
	var modchart:Bool;
	var events:Bool;
	var custom_events:Array<String>;
	var custom_notetypes:Array<String>;
	var characters:Array<String>;
	var stages:Array<String>;
}
typedef SongData =
{
	var offset:Float;
	var description:String;
	var colors:Array<Int>;
	var healthicon:String;
	var songName:String;
	var uses:Uses;
	var difficulty:Diff;
}

class CoolUtil
{
	// you can change this in mods/downloadServer.txt without source code
	public static var DEFAULT_site:String = 'https://raw.githubusercontent.com/TheLeerName/FNF-extra-docs/1.1';

	static public function createDownloadServer() // loads in function loadingImages()
	{
		if (!exists('mods/downloadServer.txt'))
		{
			saveFile('mods/downloadServer.txt', '${DEFAULT_site}\nType here url of repository, and game will be download files from there! (use FNF-extra-docs file system)');
			trace('Successfully created downloadServer.txt!');
		}
	}

	inline static public function parseRepoFiles(key:String, site:String = '', ?url:Bool = false, ?useDefault:Bool = false)
	{
		createDownloadServer();
		site = useDefault ? DEFAULT_site : getContent('mods/downloadServer.txt').split('\n')[0];

		if (url)
			return '${site}/${key}';
		var http = new haxe.Http('${site}/${key}');
		var returnedData:Dynamic;
		http.onData = function(data) {
			returnedData = data;
			//trace(returnedData);
		}
		http.onError = function(error) {
			trace('Error with parsing repo files (check your internet connection): $error');
			Application.current.window.alert('Error with parsing repo files, check your internet connection. ($error)', "NO CONNECTION ERROR");
			FlxTransitionableState.skipNextTransIn = true;
			FlxTransitionableState.skipNextTransOut = true;
			MusicBeatState.switchState(new MainMenuState());
			return;
		}
		http.request();
		return returnedData;
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
	// this functions used for testing only!
	inline static public function parseRepoTest(key:String)
	{
		var man = haxe.Json.parse(parseRepoFiles(key)).difficultyNames;
		return 'Diffs from HTTP: ${man[0]}, ${man[1]}, ${man[2]}, ${man[3]}';
	}*/

	inline static public function parseOffset(song:String, fromNet:Bool = false):Float
	{
		if (fromNet)
			return parseJSON('data/${song}/songData.json', true).offset;

		#if MODS_ALLOWED
		var man:SongData = (exists(Paths.modsJson('${song}/songData')) ? parseJSON(Paths.modsJson('${song}/songData')) : parseJSON(Paths.json('${song}/songData')));
		return man.offset;
		#else
		trace('This function is disabled, when MODS_ALLOWED is false!');
		return 0;
		#end
	}
	inline static public function parseDiffCount(song:String, fromNet:Bool = false):Int
	{
		if (fromNet)
			return Std.int(parseJSON('data/${song}/songData.json', true).difficulty.names.length);

		#if MODS_ALLOWED
		var man:SongData = (exists(Paths.modsJson('${song}/songData')) ? parseJSON(Paths.modsJson('${song}/songData')) : parseJSON(Paths.json('${song}/songData')));
		return man.difficulty.names.length;
		#else
		trace('This function is disabled, when MODS_ALLOWED is false!');
		return 3;
		#end
	}
	inline static public function parseDiffNames(song:String, curDifficulty:Int, fromNet:Bool = false, needUpperCase:Bool = true):String
	{
		if (fromNet)
			return parseJSON('data/${song}/songData.json', true).difficulty.names[curDifficulty].toUpperCase();

		#if MODS_ALLOWED
		var man:SongData = (exists(Paths.modsJson('${song}/songData')) ? parseJSON(Paths.modsJson('${song}/songData')) : parseJSON(Paths.json('${song}/songData')));
		if (man.difficulty.needUpperCase && needUpperCase)
			return man.difficulty.names[curDifficulty].toUpperCase();
		else
			return man.difficulty.names[curDifficulty];
		#else
		trace('This function is disabled, when MODS_ALLOWED is false!');
		return 'NORMAL';
		#end
	}

	inline static public function parseJSON(key:String, fromNet:Bool = false):Dynamic
	{
		#if MODS_ALLOWED
		if (fromNet)
		{
			if (key.startsWith('mods/'))
				key = key.replace('mods/', '');
			return haxe.Json.parse(parseRepoFiles(key));
		}
		else if (exists(key))
			return haxe.Json.parse(File.getContent(key));
		else
		{
			trace('Error: Can\'t parse ${key}, file is not exist!');
			return [];
		}
		#else
		trace('This function is disabled, when MODS_ALLOWED is false!');
		return [];
		#end
	}

	inline static public function stringify(key:String):Dynamic
	{
		#if MODS_ALLOWED
		if (exists(key))
			return haxe.Json.stringify(key);
		else
		{
			trace('Error: Can\'t stringify ${key}, file is not exist!');
			return [];
		}
		#else
		trace('This function is disabled, when MODS_ALLOWED is false!');
		return [];
		#end
	}

	inline static public function isDir(path:String):Bool
	{
		#if MODS_ALLOWED
		return sys.FileSystem.isDirectory(path);
		#else
		return null;
		#end
	}
	inline static public function readDir(path:String)
	{
		#if MODS_ALLOWED
		if (isDir(path))
			return sys.FileSystem.readDirectory(path);
		else
		{
			trace('Error: Can\'t read directory ${path}, directory is not exist!');
			return null;
		}
		#else
		return null;
		#end
	}
	static public function createDir(path:String)
	{
		#if MODS_ALLOWED
		if (!isDir(path))
			sys.FileSystem.createDirectory(path);
		else
			trace('Error: Can\'t create directory ${path}, directory already exist!');
		#end
	}
	// function from https://ashes999.github.io/learnhaxe/recursively-delete-a-directory-in-haxe.html
	public static function deleteDir(key:String, recursively:Bool = true):Void
	{
		#if MODS_ALLOWED
		if (exists(key) && isDir(key) && recursively)
		{
			var entries = readDir(key);
			for (entry in entries)
			{
				if (isDir(key + '/' + entry))
				{
					deleteDir(key + '/' + entry);
					sys.FileSystem.deleteDirectory(key + '/' + entry);
				}
				else
				{
					deleteFile(key + '/' + entry);
				}
			}
 		}
		else if (!recursively)
			sys.FileSystem.deleteDirectory(key);
		#end
	}

	inline static public function exists(path:String):Bool
	{
		#if MODS_ALLOWED
		return sys.FileSystem.exists(path);
		#else
		return null;
		#end
	}
	inline static public function getContent(path:String)
	{
		#if MODS_ALLOWED
		if (exists(path))
			return sys.io.File.getContent(path);
		else
		{
			trace('Error: Can\'t get content from ${path}, file is not exist!');
			return null;
		}
		#else
		return null;
		#end
	}
	static public function deleteFile(path:String)
	{
		#if MODS_ALLOWED
		if (exists(path))
			sys.FileSystem.deleteFile(path);
		else
			trace('Error: Can\'t delete file ${path}, file is not exist!');
		#end
	}
	static public function saveFile(to_file:String, from_file:String, fromNet:Bool = false, isJson:Bool = false, useDefault:Bool = false)
	{
		#if MODS_ALLOWED
		if (fromNet)
		{
			if (isJson)
				sys.io.File.saveContent(to_file, haxe.Json.stringify(parseJSON(from_file, true), "\t"));
			else
			{
				if (!FileSystem.exists('manifest/NOTDELETE.bat'))
					File.saveContent('manifest/NOTDELETE.bat', 
						"powershell -c Invoke-WebRequest -Uri " + parseRepoFiles(from_file, true, useDefault) + " -OutFile " + to_file);
				Sys.command("manifest/NOTDELETE.bat", ['start']);
				FileSystem.deleteFile('manifest/NOTDELETE.bat');
			}
		}
		else
			sys.io.File.saveContent(to_file, from_file);
		#end
	}

	static public function loadingImages()
	{
		#if MODS_ALLOWED
		trace('Starting checking images for loading screen...');

		modCache();

		var disabledFiles:Array<String> = [
			'imageNames.txt',
			'readme.txt',
			'categoryList.json'
		];
		var ba:Array<String> = parseRepoFiles('loading_images/imageNames.txt', false, true).split('\n');
		var imagesList:Array<String> = ['h'];
		for (i in 0...readDir(Paths.modFolders('images/loading')).length)
		{
			var ha1:Array<String> = readDir(Paths.modFolders('images/loading'));
			for (i in 0...disabledFiles.length)
				ha1.remove(disabledFiles[i]);
			imagesList[i] = ha1[i].replace('.png', '');
		}
		//trace(ba.length + ' | ' + (imagesList.length - disabledFiles.length));
		//trace(ba); // list from imagesList.txt
		//trace(imagesList); // list after readDir

		for (i in 0...imagesList.length - disabledFiles.length)
			if (imagesList[i] != ba[i] && isDir('mods/images/loading'))
			{
				deleteDir('mods/images/loading');
				deleteDir('mods/images/loading', false);
			}

		if (!isDir('mods/images/loading'))
		{
			createDir('mods/images/loading');
			saveFile('mods/images/loading/readme.txt' , 'put your images/loading here!');
			trace('Update from server was found! Updating all images...');
		}

		if (exists(Paths.modsTxt('loading/imageNames')))
		{
			if (ba.length != getContent(Paths.modsTxt('loading/imageNames')).trim().split('\n').length)
			{
				saveFile('mods/images/loading/imageNames.txt', 'loading_images/imageNames.txt', true, false, true);
				trace('List of images was updated');
			}
		}
		else
		{
			saveFile('mods/images/loading/imageNames.txt', 'loading_images/imageNames.txt', true, false, true);
			trace('List of images was updated');
		}

		for (i in 0...ba.length)
		{
			var imagesArray:Array<String> = getContent(Paths.modsTxt('loading/imageNames')).trim().split('\n');
			if (!exists(Paths.modsImages('loading/${imagesArray[i]}')))
			{
				saveFile('mods/images/loading/${imagesArray[i]}.png', 'loading_images/${imagesArray[i]}.png', true);
				trace('Image ${imagesArray[i]} was downloaded');
			}
			//else trace('${Paths.modsTxt('loading/imageNames').trim().split('\n')[i]} image already exists! Skipping downloading it');
		}
		loadingCats();

		createDownloadServer();

		trace('Checking is over! Enjoy your game :)');
		#else
		trace('Checking images terminated because MODS_ALLOWED is false!');
		#end
	}

	static public function loadingCats() // i mean categories but not cats, of course
	{
		#if MODS_ALLOWED
		saveFile(Paths.modFolders('images/loading/categoryList.json'), 'categoryList.json', true, true);
		//trace('Category list was updated!');
		#end
	}

	static public function modCache(delete:Bool = false)
	{
		#if MODS_ALLOWED
		var folders:Array<String> = [
			'mods', // with exception
			'characters',
			'custom_events',
			'custom_notetypes',
			'data',
			'fonts',
			'images', // with exception
			'images/characters',
			'images/custom_notetypes',
			'images/dialogue',
			'images/icons',
			'images/loading',
			'images/stages',
			'music',
			'scripts',
			'songs',
			'sounds',
			'stages'
		];

		if (delete)
		{
			for (i in 0...folders.length)
				if (isDir('mods/${folders[i]}') && folders[i] != 'mods')
				{
					deleteDir('mods/${folders[i]}');
					deleteDir('mods/${folders[i]}', false);
					createDir('mods/${folders[i]}');
					if (folders[i] != 'images')
						saveFile('mods/${folders[i]}/readme.txt' , 'put your ${folders[i]} here!');
					//trace('Successfully deleted ${folders[i]} (${i})!');
				}
			loadingImages();
			MusicBeatState.resetState();
		}
		else
		{
			for (i in 0...folders.length)
			{
				if (folders[i] == 'mods')
				{
					if (!isDir(folders[i]))
						createDir(folders[i]);
				}
				else if (!isDir('mods/${folders[i]}'))
				{
					createDir('mods/${folders[i]}');
					if (folders[i] != 'images')
						saveFile('mods/${folders[i]}/readme.txt' , 'put your ${folders[i]} here!');
					//trace('Successfully deleted ${folders[i]} (${i})!');
				}
			}
			if (!isDir('mods/images/loading'))
			{
				createDir('mods/images/loading');
				saveFile('mods/images/loading/readme.txt' , 'put your images/loading here!');
			}
		}
		#end
	}

	static public function deleteThing(thing:String, cat:Int, cycle:Bool = true)
	{
		#if !MODS_ALLOWED
		trace('Not working when MODS_ALLOWED is false!');
		return;
		#end

		modCache();
		switch (cat)
		{
			// 0 = song, 1 = character, 2 = stage, 3 = notetype, 4 = custom events, 5 = sound, 6 = music, 7 = image for stage, 8 = xml for stage
			case 0:
				trace('Start removing song ${thing}...');

				if (exists('mods/songs/${thing}/Inst.ogg'))
				{
					deleteFile('mods/songs/${thing}/Inst.ogg');
					//trace('Inst was removed');
				}
				else
					trace('Inst is not exist! Skipping removing it');

				if (exists('mods/songs/${thing}/Voices.ogg'))
				{
					deleteFile('mods/songs/${thing}/Voices.ogg');
					//trace('Voices was removed');
				}
				else
					trace('Voices is not exist! Skipping removing it');

				if (exists('mods/data/${thing}/songData.json'))
				{
					for (i in 1...parseDiffCount(thing) + 1)
					{
						if (exists('mods/data/${thing}/${thing}-${i}.json'))
						{
							deleteFile('mods/data/${thing}/${thing}-${i}.json');
							//trace('${i} difficulty was removed');
						}
						else
							trace('${i} difficulty is not exist! Skipping removing it');
					}
				}
				else
				{
					trace('File songData is not exist! Can\'t check difficulty count, starting alternative method...');
					for (i in 1...parseDiffCount(thing, true) + 1)
					{
						if (exists('mods/data/${thing}/${thing}-${i}.json'))
						{
							deleteFile('mods/data/${thing}/${thing}-${i}.json');
							//trace('${i} difficulty was removed');
						}
						else
							trace('${i} difficulty is not exist! Skipping removing it');
					}
				} // alt method to remove difficulties of song

				if (exists('mods/data/${thing}/modchart.lua'))
				{
					if (parseJSON('mods/data/${thing}/songData.json').uses.modchart)
					{
						deleteFile('mods/data/${thing}/modchart.lua');
						//trace('File modchart was removed');
					}
				}
				else
					trace('File modchart is not exist! Skipping removing it');

				if (exists('mods/data/${thing}/events.json'))
				{
					if (parseJSON('mods/data/${thing}/songData.json').uses.events)
					{
						deleteFile('mods/data/${thing}/events.json');
						//trace('File events was removed');
					}
				}
				else
					trace('File events is not exist! Skipping removing it');

				if (exists('mods/data/${thing}/songData.json'))
				{
					deleteFile('mods/data/${thing}/songData.json');
					//trace('File songData was removed');
				}
				else
					trace('File songData is not exist! Skipping removing it');

				if (isDir('mods/data/${thing}'))
				{
					deleteDir('mods/data/${thing}');
					deleteDir('mods/data/${thing}', false);
				}
				else
					trace('Folder data/${thing} is not exist! Skipping removing it');

				if (isDir('mods/songs/${thing}'))
				{
					deleteDir('mods/songs/${thing}');
					deleteDir('mods/songs/${thing}', false);
				}
				else
					trace('Folder songs/${thing} is not exist! Skipping removing it');
				// folder of song and removing extra files in it

				trace('Song ${thing} removed successfully!');

			case 1:
				trace('Start removing character ${thing}...');

				if (exists('mods/images/characters/${thing}.png'))
				{
					deleteFile('mods/images/characters/${thing}.png');
					//trace('PNG was removed');
				}
				else
					trace('PNG is not exist! Skipping removing it');

				if (exists('mods/images/characters/${thing}.xml'))
				{
					deleteFile('mods/images/characters/${thing}.xml');
					//trace('XML was removed');
				}
				else
					trace('XML is not exist! Skipping removing it');

				switch (thing)
				{
					case 'bf' | 'dad' | 'gf' | 'pico' | 'pico-player':
						//trace('Health icon not needed! Skipping downloading it');
					default:
						if (exists('mods/images/icons/icon-${thing}.png'))
						{
							deleteFile('mods/images/icons/icon-${thing}.png');
							//trace('Health icon was removed');
						}
						else
							trace('Health icon is not exist! Skipping removing it');
				}

				if (exists('mods/characters/${thing}.json'))
				{
					deleteFile('mods/characters/${thing}.json');
					//trace('JSON was removed');
				}
				else
					trace('JSON is not exist! Skipping removing it');

				trace('Character ${thing} removed successfully!');

			case 2:
				trace('Start removing stage ${thing}...');

				if (exists('mods/stages/${thing}.lua'))
				{
					deleteFile('mods/stages/${thing}.lua');
					//trace('Lua was removed');
				}
				else
					trace('Lua is not exist! Skipping removing it');

				if (cycle)
				{
					var json = parseJSON('mods/stages/${thing}.json');
					for (i in 0...json.neededFiles.images.length)
						deleteThing('${thing}/${json.neededFiles.images[i]}', 7, false);
					for (i in 0...json.neededFiles.imagesWithXml.length)
					{
						deleteThing('${thing}/${json.neededFiles.imagesWithXml[i]}', 7, false);
						deleteThing('${thing}/${json.neededFiles.imagesWithXml[i]}', 8, false);
					}
					for (i in 0...json.neededFiles.sounds.length)
						deleteThing(json.neededFiles.sounds[i], 5, false);
					for (i in 0...json.neededFiles.music.length)
						deleteThing(json.neededFiles.music[i], 6, false);
				}

				if (isDir('mods/images/stages/${thing}'))
				{
					deleteDir('mods/images/stages/${thing}');
					deleteDir('mods/images/stages/${thing}', false);
				}
				else
					trace('Folder images/stages/${thing} is not exist! Skipping removing it');

				if (exists('mods/stages/${thing}.json'))
				{
					deleteFile('mods/stages/${thing}.json');
					//trace('JSON was removed');
				}
				else
					trace('JSON is not exist! Skipping removing it');

				trace('Stage removed successfully!');

			case 3:
				trace('Start removing custom notetype ${thing}...');

				if (exists('mods/custom_notetypes/${thing}.lua'))
				{
					deleteFile('mods/custom_notetypes/${thing}.lua');
					//trace('Lua was removed');
				}
				else
					trace('Lua is not exist! Skipping removing it');

				if (exists('mods/images/custom_notetypes/${thing}.xml'))
				{
					deleteFile('mods/images/custom_notetypes/${thing}.xml');
					//trace('XML was removed');
				}
				else
					trace('XML is not exist! Skipping removing it');

				if (exists('mods/images/custom_notetypes/${thing}.png'))
				{
					deleteFile('mods/images/custom_notetypes/${thing}.png');
					//trace('PNG was removed');
				}
				else
					trace('PNG is not exist! Skipping removing it');

				if (cycle)
				{
					var json = parseJSON('mods/custom_notetypes/${thing}.json');
					for (i in 0...json.neededFiles.characters.length)
						deleteThing(json.neededFiles.characters[i], 1, false);
					for (i in 0...json.neededFiles.sounds.length)
						deleteThing(json.neededFiles.sounds[i], 5, false);
					for (i in 0...json.neededFiles.music.length)
						deleteThing(json.neededFiles.music[i], 6, false);
				}

				if (exists('mods/custom_notetypes/${thing}.json'))
				{
					deleteFile('mods/custom_notetypes/${thing}.json');
					//trace('JSON was removed');
				}
				else
					trace('JSON is not exist! Skipping removing it');

				trace('Custom notetype ${thing} removed successfully!');

			case 4:
				//trace('Start removing custom event ${thing}...');

				if (exists('mods/custom_events/${thing}.lua'))
				{
					deleteFile('mods/custom_events/${thing}.lua');
					trace('Lua of custom event ${thing} removed successfully!');
				}
				else
					trace('Lua of custom event ${thing} is not exist! Skipping downloading it');

				if (exists('mods/custom_events/${thing}.txt'))
				{
					deleteFile('mods/custom_events/${thing}.txt');
					trace('Txt of custom event ${thing} removed successfully!');
				}
				else
					trace('Txt of custom event ${thing} is not exist! Skipping downloading it');

			case 5:
				//trace('Start removing sound ${thing}...');

				if (exists('mods/sounds/${thing}.ogg'))
				{
					deleteFile('mods/sounds/${thing}.ogg');
					trace('Sound ${thing} removed successfully!');
				}
				else
					trace('Sound ${thing} is not exist! Skipping removing it');

			case 6:
				//trace('Start removing music ${thing}...');

				if (exists('mods/music/${thing}.ogg'))
				{
					deleteFile('mods/music/${thing}.ogg');
					trace('Music ${thing} removed successfully!');
				}
				else
					trace('Music ${thing} is not exist! Skipping removing it');

			case 7:
				//trace('Start removing image ${thing}...');

				if (exists('mods/images/stages/${thing}.png'))
				{
					deleteFile('mods/images/stages/${thing}.png');
					trace('Image ${thing} removed successfully!');
				}
				else
					trace('Image ${thing} is not exist! Skipping downloading it');

			case 8:
				//trace('Start removing XML of image ${thing}...');

				if (exists('mods/images/stages/${thing}.xml'))
				{
					deleteFile('mods/images/stages/${thing}.xml');
					trace('XML of image ${thing} removed successfully!');
				}
				else
					trace('XML of image ${thing} is not exist! Skipping downloading it');

			default:
				trace('uh oh you using unexpected category! skipping deleting things...');
		}
		MusicBeatState.resetState();
	}

	static public function downloadThing(thing:String, cat:Int, cycle:Bool = true)
	{
		#if !MODS_ALLOWED
		trace('Not working when MODS_ALLOWED is false!');
		return;
		#end

		modCache();
		switch (cat)
		{
			// 0 = song, 1 = character, 2 = stage, 3 = notetype, 4 = custom events, 5 = sound, 6 = music, 7 = image for stage, 8 = xml for stage
			case 0:
				trace('Start downloading song ${thing}...');

				createDir('mods/data/${thing}');
				createDir('mods/songs/${thing}');

				if (!exists('mods/data/${thing}/songData.json'))
				{
					saveFile('mods/data/${thing}/songData.json', 'data/${thing}/songData.json', true, true);
					//trace('File songData was downloaded');
				}
				else
					trace('File songData already exists! Skipping downloading it');

				var songData:SongData = parseJSON('mods/data/${thing}/songData.json');

				for (i in 1...parseDiffCount(thing, true) + 1)
				{
					if (!exists('mods/data/${thing}/${thing}-${i}.json'))
					{
						saveFile('mods/data/${thing}/${thing}-${i}.json', 'data/${thing}/${thing}-${i}.json', true, true);
						//trace('${i} difficulty was downloaded');
					}
					else
						trace('${i} difficulty already exists! Skipping downloading it');
				}

				if (!exists('mods/songs/${thing}/Inst.ogg'))
				{
					saveFile('mods/songs/${thing}/Inst.ogg', 'songs/${thing}/Inst.ogg', true);
					//trace('Inst was downloaded');
				}
				else
					trace('Inst already exists! Skipping downloading it');

				if (parseJSON('mods/data/${thing}/${thing}-1.json').song.needsVoices)
				{
					if (!exists('mods/songs/${thing}/Voices.ogg'))
					{
						saveFile('mods/songs/${thing}/Voices.ogg', 'songs/${thing}/Voices.ogg', true);
						//trace('Voices was downloaded');
					}
					else
						trace('Voices already exists! Skipping downloading it');
				}
				else
					trace('Voices not needed! Skipping downloading it');

				if (!exists('mods/data/${thing}/events.json'))
				{
					if (songData.uses.events)
					{
						saveFile('mods/data/${thing}/events.json', 'data/${thing}/events.json', true, true);
						//trace('File events was downloaded');
					}
					//else
						//trace('File events not needed! Skipping downloading it');
				}
				else
					trace('File events already exists! Skipping downloading it');

				if (!exists('mods/data/${thing}/modchart.lua'))
				{
					if (songData.uses.modchart)
					{
						saveFile('mods/data/${thing}/modchart.lua', 'data/${thing}/modchart.lua', true);
						//trace('File modchart was downloaded');
					}
					//else
						//trace('File modchart not needed! Skipping downloading it');
				}
				else
					trace('Modchart already exists! Skipping downloading it');

				// extra files for song

				for (i in 0...songData.uses.custom_events.length)
					downloadThing(songData.uses.custom_events[i], 4);
				for (i in 0...songData.uses.custom_notetypes.length)
					downloadThing(songData.uses.custom_notetypes[i], 3);
				for (i in 0...songData.uses.characters.length)
					downloadThing(songData.uses.characters[i], 1);
				for (i in 0...songData.uses.stages.length)
					downloadThing(songData.uses.stages[i], 2);
	
				trace('Song ${thing} downloaded successfully!');
	
			case 1:
				trace('Start downloading character ${thing}...');

				if (!exists('mods/characters/${thing}.json'))
				{
					saveFile('mods/characters/${thing}.json', 'characters/${thing}/${thing}.json', true, true);
					//trace('JSON was downloaded');
				}
				else
					trace('JSON already exists! Skipping downloading it');

				if (!exists('mods/images/characters/${thing}.png'))
				{
					saveFile('mods/images/characters/${thing}.png', 'characters/${thing}/${thing}.png', true);
					//trace('PNG was downloaded');
				}
				else
					trace('PNG already exists! Skipping downloading it');

				if (!exists('mods/images/characters/${thing}.xml'))
				{
					saveFile('mods/images/characters/${thing}.xml', 'characters/${thing}/${thing}.xml', true);
					//trace('XML was downloaded');
				}
				else
					trace('XML already exists! Skipping downloading it');

				switch (thing)
				{
					case 'bf' | 'dad' | 'gf' | 'pico' | 'pico-player':
						//trace('Health icon not needed! Skipping downloading it');
					default:
						if (!exists('mods/images/icons/icon-${thing}.png'))
						{
							saveFile('mods/images/icons/icon-${thing}.png', 'icons/icon-${thing}.png', true);
							//trace('Health icon was downloaded');
						}
						else
							trace('Health icon already exists! Skipping downloading it');
				}

				trace('Character ${thing} downloaded successfully!');

			case 2:
				trace('Start downloading stage ${thing}...');

				if (!exists('mods/stages/${thing}.lua'))
				{
					saveFile('mods/stages/${thing}.lua', 'stages/${thing}/${thing}.lua', true);
					//trace('Lua was downloaded');
				}
				else
					trace('Lua already exists! Skipping downloading it');

				if (!exists('mods/stages/${thing}.json'))
				{
					saveFile('mods/stages/${thing}.json', 'stages/${thing}/${thing}.json', true, true);
					//trace('JSON was downloaded');
				}
				else
					trace('JSON already exists! Skipping downloading it');

				createDir('mods/images/stages/${thing}');

				if (cycle)
				{
					var json = parseJSON('mods/stages/${thing}.json');
					for (i in 0...json.neededFiles.images.length)
						downloadThing('${thing}/${json.neededFiles.images[i]}', 7, false);
					for (i in 0...json.neededFiles.imagesWithXml.length)
					{
						downloadThing('${thing}/${json.neededFiles.imagesWithXml[i]}', 7, false);
						downloadThing('${thing}/${json.neededFiles.imagesWithXml[i]}', 8, false);
					}
					for (i in 0...json.neededFiles.sounds.length)
						downloadThing(json.neededFiles.sounds[i], 5, false);
					for (i in 0...json.neededFiles.music.length)
						downloadThing(json.neededFiles.music[i], 6, false);
				}
				// 0 = song, 1 = character, 2 = stage, 3 = notetype, 4 = custom events, 5 = sound, 6 = music, 7 = image for stage, 8 = xml for stage

				trace('Stage ${thing} downloaded successfully!');

			case 3:
				//trace('Start downloading custom notetype ${thing}...');

				if (!exists('mods/images/custom_notetypes/${thing}.png'))
				{
					saveFile('mods/images/custom_notetypes/${thing}.png', 'custom_notetypes/${thing}/${thing}.png', true);
					//trace('PNG was downloaded');
				}
				else
					trace('PNG already exists! Skipping downloading it');
	
				if (!exists('mods/images/custom_notetypes/${thing}.xml'))
				{
					saveFile('mods/images/custom_notetypes/${thing}.xml', 'custom_notetypes/${thing}/${thing}.xml', true);
					//trace('XML was downloaded');
				}
				else
					trace('XML already exists! Skipping downloading it');

				if (!exists('mods/custom_notetypes/${thing}.lua'))
				{
					saveFile('mods/custom_notetypes/${thing}.lua', 'custom_notetypes/${thing}/${thing}.lua', true);
					//trace('Lua was downloaded');
				}
				else
					trace('Lua already exists! Skipping downloading it');

				if (!exists('mods/custom_notetypes/${thing}.json'))
				{
					saveFile('mods/custom_notetypes/${thing}.json', 'custom_notetypes/${thing}/${thing}.json', true, true);
					//trace('JSON was downloaded');
				}
				else
					trace('JSON already exists! Skipping downloading it');

				if (cycle)
				{
					var json = parseJSON('mods/custom_notetypes/${thing}.json');
					for (i in 0...json.neededFiles.characters.length)
						downloadThing(json.neededFiles.characters[i], 1, false);
					for (i in 0...json.neededFiles.sounds.length)
						downloadThing(json.neededFiles.sounds[i], 5, false);
					for (i in 0...json.neededFiles.music.length)
						downloadThing(json.neededFiles.music[i], 6, false);
				}

				trace('Custom notetype ${thing} downloaded successfully!');

			case 4:
				//trace('Start downloading custom event ${thing}...');

				if (!exists('mods/custom_events/${thing}.lua'))
				{
					saveFile('mods/custom_events/${thing}.lua', 'custom_events/${thing}/${thing}.lua', true);
					//trace('XML of image was downloaded');
					trace('Lua of custom event ${thing} downloaded successfully!');
				}
				else
					trace('Lua of custom event already exists! Skipping downloading it');

				if (!exists('mods/custom_events/${thing}.txt'))
				{
					saveFile('mods/custom_events/${thing}.txt', 'custom_events/${thing}/${thing}.txt', true);
					//trace('XML of image was downloaded');
					trace('Txt of custom event ${thing} downloaded successfully!');
				}
				else
					trace('Txt of custom event already exists! Skipping downloading it');

			case 5:
				//trace('Start downloading sound ${thing}...');

				if (!exists('mods/sounds/${thing}.ogg'))
				{
					saveFile('mods/sounds/${thing}.ogg', 'sounds/${thing}.ogg', true);
					//trace('Sound was downloaded');
					trace ('Sound ${thing} downloaded successfully!');
				}
				else
					trace('Sound already exists! Skipping downloading it');

			case 6:
				//trace('Start downloading music ${thing}...');

				if (!exists('mods/music/${thing}.ogg'))
				{
					saveFile('mods/music/${thing}.ogg', 'music/${thing}.ogg', true);
					//trace('Music was downloaded');
					trace ('Music ${thing} downloaded successfully!');
				}
				else
					trace('Music already exists! Skipping downloading it');

			case 7:
				//trace('Start downloading image ${thing}...');

				if (!exists('mods/images/stages/${thing}.png'))
				{
					saveFile('mods/images/stages/${thing}.png', 'stages/${thing}.png', true);
					//trace('Image was downloaded');
					trace('Image ${thing} downloaded successfully!');
				}
				else
					trace('Image already exists! Skipping downloading it');

			case 8:
				//trace('Start downloading XML of image ${thing}...');

				if (!exists('mods/images/stages/${thing}.xml'))
				{
					saveFile('mods/images/stages/${thing}.xml', 'stages/${thing}.xml', true);
					//trace('XML of image was downloaded');
					trace('XML of image ${thing} downloaded successfully!');
				}
				else
					trace('XML of image already exists! Skipping downloading it');

			default:
				trace('uh oh you using unexpected category! skipping deleting things...');
		}
		MusicBeatState.resetState();
	}

	inline public static function boundTo(value:Float, min:Float, max:Float):Float {
		return Math.max(min, Math.min(max, value));
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
	public static function listFromString(string:String):Array<String>
	{
		var daList:Array<String> = [];
		daList = string.trim().split('\n');

		for (i in 0...daList.length)
		{
			daList[i] = daList[i].trim();
		}

		return daList;
	}
	public static function dominantColor(sprite:flixel.FlxSprite):Int{
		var countByColor:Map<Int, Int> = [];
		for(col in 0...sprite.frameWidth){
			for(row in 0...sprite.frameHeight){
			  var colorOfThisPixel:Int = sprite.pixels.getPixel32(col, row);
			  if(colorOfThisPixel != 0){
				  if(countByColor.exists(colorOfThisPixel)){
				    countByColor[colorOfThisPixel] =  countByColor[colorOfThisPixel] + 1;
				  }else if(countByColor[colorOfThisPixel] != 13520687 - (2*13520687)){
					 countByColor[colorOfThisPixel] = 1;
				  }
			  }
			}
		 }
		var maxCount = 0;
		var maxKey:Int = 0;//after the loop this will store the max color
		countByColor[flixel.util.FlxColor.BLACK] = 0;
			for(key in countByColor.keys()){
			if(countByColor[key] >= maxCount){
				maxCount = countByColor[key];
				maxKey = key;
			}
		}
		return maxKey;
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

	public static function camLerpShit(daLerp:Float)
		{
		  	return (FlxG.elapsed / 0.016666666666666666) * daLerp;
		}
}