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

typedef Diff =
{
	var names:Array<String>;
	var needUpperCase:Bool;	
}
typedef Uses =
{
	var modchart:Bool;
	var events:Bool;
	var characters:Array<String>;
	var stages:Array<String>;
	var notetypes:Array<String>;
}
typedef SongData =
{
	var offset:Float;
	var uses:Uses;
	var difficulty:Diff;
}

class CoolUtil
{
	static public function createDownloadServer() // loads in function loadingImages()
	{
		if (!exists('mods/downloadServer.txt'))
		{
			// you can change this in mods/downloadServer.txt without source code
			var DEFAULT_site:String = 'https://raw.githubusercontent.com/TheLeerName/FNF-extra-docs/1.0PE-nightly3';

			saveFile('mods/downloadServer.txt', '${DEFAULT_site}\nType here url of repository, and game will be download files from there! (use FNF-extra-docs file system)');
			trace('Successfully created downloadServer.txt!');
		}
	}

	inline static public function parseRepoFiles(key:String, site:String = '', ?url:Bool = false, ?useDefault:Bool = false)
	{
		createDownloadServer();
		site = useDefault ? 'https://raw.githubusercontent.com/TheLeerName/FNF-extra-docs/1.0PE-nightly3' : CoolUtil.getContent('mods/downloadServer.txt').split('\n')[0];

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
			return haxe.Json.parse(parseRepoFiles(key));
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

	inline static public function parse(key:String, fromNet:Bool = false):Dynamic
	{
		#if MODS_ALLOWED
		if (exists(key))
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
	inline static public function getContent(path:String):String
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

		var ba:Array<String> = parseRepoFiles('loading_images/imageNames.txt', false, true).split('\n');
		var imagesList:Array<String> = ['h'];
		for (i in 0...readDir(Paths.modFolders('images/loading')).length)
		{
			var ha1:Array<String> = readDir(Paths.modFolders('images/loading'));
			ha1.remove("loading-images-here.txt");
			ha1.remove("imageNames.txt");
			ha1.remove("categoryList.json");
			imagesList[i] = ha1[i].replace('.png', '');
		}
		//trace(ba.length + ' | ' + (imagesList.length - 2));
		//trace(ba);
		//trace(imagesList);

		for (i in 0...imagesList.length - 3)
			if (imagesList[i] != ba[i])
			{
				deleteDir('mods/images/loading');
				deleteDir('mods/images/loading', false);
			}

		if (!isDir(Paths.modFolders('images/loading')))
		{
			createDir(Paths.modFolders('images/loading'));
			trace('Update from server was found! Updating all images...'); // i think nobody not deleting this folder specially :)
		}
		if (!exists('mods/images/loading/loading-images-here.txt'))
			saveFile('mods/images/loading/loading-images-here.txt', '');

		if (exists(Paths.modsTxt('loading/imageNames')))
		{
			if (ba.length != File.getContent(Paths.modsTxt('loading/imageNames')).trim().split('\n').length)
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
			if (!exists(Paths.modsImages('loading/${File.getContent(Paths.modsTxt('loading/imageNames')).trim().split('\n')[i]}')))
			{
				saveFile('mods/images/loading/${File.getContent(Paths.modsTxt('loading/imageNames')).trim().split('\n')[i]}.png', 'loading_images/${File.getContent(Paths.modsTxt('loading/imageNames')).trim().split('\n')[i]}.png', true);
				trace('Image ${File.getContent(Paths.modsTxt('loading/imageNames')).trim().split('\n')[i]} was downloaded');
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

	inline static public function getCats(which:Int)
	{
		#if MODS_ALLOWED
		var man = parseJSON(Paths.modFolders('images/loading/categoryList.json'));
		if (which == 0)
			return man.songs;
		if (which == 1)
			return man.characters;
		if (which == 2)
			return man.stages;
		if (which == 3)
			return man.notetypes;
		else
		{
			trace('uh oh you using unexpected category! return 0...');
			return 0;
		}
		#else
		return null;
		#end
	}

	static public function deleteAll()
	{
		#if MODS_ALLOWED
		var folders:Array<String> = [
			'characters',
			'custom_notetypes',
			'data',
			'images/characters',
			'images/custom_notetypes',
			'images/icons',
			'images/stages',
			'music',
			'songs',
			'sounds',
			'stages',
			'weeks'
		];
		for (i in 0...folders.length)
		{
			if (isDir('mods/${folders[i]}'))
			{
				deleteDir('mods/${folders[i]}');
				deleteDir('mods/${folders[i]}', false);
				createDir('mods/${folders[i]}');
				saveFile('mods/${folders[i]}/readme.txt' , 'put your ${folders[i]} here!');
				//trace('Successfully deleted ${folders[i]} (${i})!');
			}
		}
		MusicBeatState.resetState();
		#end
	}

	static public function deleteThing(thing:String, cat:Int, cycle:Bool = true)
	{
		switch (cat)
		{
			// 0 = song, 1 = character, 2 = stage, 3 = notetype, 4 = sound, 5 = music, 6 = image for stage, 7 = xml for stage
			#if MODS_ALLOWED
			case 0:
				trace('Start removing song ${thing}...');

				if (exists(Paths.modsSongs('${thing}/Inst')))
				{
					deleteFile(Paths.modsSongs('${thing}/Inst'));
					//trace('Inst was removed');
				}
				else
					trace('Inst is not exist! Skipping removing it');

				if (exists(Paths.modsSongs('${thing}/Voices')))
				{
					deleteFile(Paths.modsSongs('${thing}/Voices'));
					//trace('Voices was removed');
				}
				else
					trace('Voices is not exist! Skipping removing it');

				if (exists(Paths.modsJson('${thing}/songData')))
				{
					for (i in 1...parseDiffCount(thing) + 1)
					{
						if (exists(Paths.modsJson('${thing}/${thing}-${i}')))
						{
							deleteFile(Paths.modsJson('${thing}/${thing}-${i}'));
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
						if (exists(Paths.modsJson('${thing}/${thing}-${i}')))
						{
							deleteFile(Paths.modsJson('${thing}/${thing}-${i}'));
							//trace('${i} difficulty was removed');
						}
						else
							trace('${i} difficulty is not exist! Skipping removing it');
					}
				} // alt method to remove difficulties of song

				if (exists(Paths.modFolders('data/${thing}/modchart.lua')))
				{
					if (parseJSON(Paths.modFolders('data/${thing}/songData.json')).usesModchart)
					{
						deleteFile(Paths.modFolders('data/${thing}/modchart.lua'));
						//trace('File modchart was removed');
					}
				}
				else
					trace('File modchart is not exist! Skipping downloading it');

				if (exists(Paths.modFolders('data/${thing}/events.json')))
				{
					if (parseJSON(Paths.modFolders('data/${thing}/songData.json')).usesEvents)
					{
						deleteFile(Paths.modFolders('data/${thing}/events.json'));
						//trace('File events was removed');
					}
				}
				else
					trace('File events is not exist! Skipping downloading it');

				if (exists(Paths.modsJson('${thing}/songData')))
				{
					deleteFile(Paths.modsJson('${thing}/songData'));
					//trace('File songData was removed');
				}
				else
					trace('File songData is not exist! Skipping removing it');

				if (exists(Paths.modFolders('weeks/${thing}.json')))
				{
					deleteFile(Paths.modFolders('weeks/${thing}.json'));
					//trace('Week file was removed');
				}
				else
					trace('Week file is not exist! Skipping removing it');

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

				if (exists(Paths.modsImages('characters/${thing}')))
				{
					deleteFile(Paths.modsImages('characters/${thing}'));
					//trace('PNG was removed');
				}
				else
					trace('PNG is not exist! Skipping removing it');

				if (exists(Paths.modsImages('icons/icon-${thing}')))
				{
					deleteFile(Paths.modsImages('icons/icon-${thing}'));
					//trace('Health icon was removed');
				}
				else
					trace('Health icon is not exist! Skipping removing it');

				if (exists(Paths.modsXml('characters/${thing}')))
				{
					deleteFile(Paths.modsXml('characters/${thing}'));
					//trace('XML was removed');
				}
				else
					trace('XML is not exist! Skipping removing it');

				if (exists(Paths.modFolders('characters/${thing}.json')))
				{
					deleteFile(Paths.modFolders('characters/${thing}.json'));
					//trace('JSON was removed');
				}
				else
					trace('JSON is not exist! Skipping removing it');

				trace('Character ${thing} removed successfully!');

			case 2:
				trace('Start removing stage ${thing}...');

				if (exists(Paths.modFolders('stages/${thing}.lua')))
				{
					deleteFile(Paths.modFolders('stages/${thing}.lua'));
					//trace('Lua was removed');
				}
				else
					trace('Lua is not exist! Skipping removing it');

				if (cycle)
				{
					for (i in 0...parseJSON(Paths.modFolders('stages/${thing}.json')).neededFiles.images.length)
						deleteThing('${thing}/${parseJSON(Paths.modFolders('stages/${thing}.json')).neededFiles.images[i]}', 6, false);
					for (i in 0...parseJSON(Paths.modFolders('stages/${thing}.json')).neededFiles.imagesWithXml.length)
					{
						deleteThing('${thing}/${parseJSON(Paths.modFolders('stages/${thing}.json')).neededFiles.imagesWithXml[i]}', 6, false);
						deleteThing('${thing}/${parseJSON(Paths.modFolders('stages/${thing}.json')).neededFiles.imagesWithXml[i]}', 7, false);
					}
					for (i in 0...parseJSON(Paths.modFolders('stages/${thing}.json')).neededFiles.sounds.length)
						deleteThing(parseJSON(Paths.modFolders('stages/${thing}.json')).neededFiles.sounds[i], 4, false);
					for (i in 0...parseJSON(Paths.modFolders('stages/${thing}.json')).neededFiles.music.length)
						deleteThing(parseJSON(Paths.modFolders('stages/${thing}.json')).neededFiles.music[i], 5, false);
				}

				if (exists(Paths.modFolders('stages/${thing}.json')))
				{
					deleteFile(Paths.modFolders('stages/${thing}.json'));
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

				if (exists(Paths.modsImages('custom_notetypes/${thing}')))
				{
					deleteFile(Paths.modsImages('custom_notetypes/${thing}'));
					//trace('PNG was removed');
				}
				else
					trace('PNG is not exist! Skipping removing it');

				if (cycle)
				{
					for (i in 0...parseJSON(Paths.modFolders('custom_notetypes/${thing}.json')).neededFiles.characters.length)
						deleteThing(parseJSON(Paths.modFolders('custom_notetypes/${thing}.json')).neededFiles.characters[i], 1, false);
					for (i in 0...parseJSON(Paths.modFolders('custom_notetypes/${thing}.json')).neededFiles.sounds.length)
						deleteThing(parseJSON(Paths.modFolders('custom_notetypes/${thing}.json')).neededFiles.sounds[i], 4, false);
					for (i in 0...parseJSON(Paths.modFolders('custom_notetypes/${thing}.json')).neededFiles.music.length)
						deleteThing(parseJSON(Paths.modFolders('custom_notetypes/${thing}.json')).neededFiles.music[i], 5, false);
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
				//trace('Start removing sound ${thing}...');

				if (exists('mods/sounds/${thing}.ogg'))
				{
					deleteFile('mods/sounds/${thing}.ogg');
					//trace('Sound was removed');
					trace('Sound ${thing} removed successfully!');
				}
				else
					trace('Sound is not exist! Skipping removing it');

			case 5:
				//trace('Start removing music ${thing}...');

				if (exists('mods/music/${thing}.ogg'))
				{
					deleteFile('mods/music/${thing}.ogg');
					//trace('Music was removed');
					trace('Music ${thing} removed successfully!');
				}
				else
					trace('Music is not exist! Skipping removing it');

			case 6:
				//trace('Start removing image ${thing}...');

				if (exists(Paths.modFolders('images/stages/${thing}.png')))
				{
					deleteFile(Paths.modFolders('images/stages/${thing}.png'));
					//trace('Image was removed');
					trace('Image ${thing} removed successfully!');
				}
				else
					trace('Image is not exist! Skipping downloading it');

			case 7:
				//trace('Start removing XML of image ${thing}...');

				if (exists(Paths.modFolders('images/stages/${thing}.xml')))
				{
					deleteFile(Paths.modFolders('images/stages/${thing}.xml'));
					//trace('XML of image was downloaded');
					trace('XML of image ${thing} removed successfully!');
				}
				else
					trace('XML of image is not exist! Skipping downloading it');
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

	static public function downloadThing(thing:String, cat:Int, cycle:Bool = true)
	{
		switch (cat)
		{
			// 0 = song, 1 = character, 2 = stage, 3 = notetype, 4 = sound, 5 = music, 6 = image for stage, 7 = xml for stage
			#if MODS_ALLOWED
			case 0:
				trace('Start downloading song ${thing}...');

				if (!isDir(Paths.modFolders('songs/${thing}')))
					createDir(Paths.modFolders('songs/${thing}'));
				if (!isDir(Paths.modFolders('data/${thing}')))
					createDir(Paths.modFolders('data/${thing}'));

				if (!exists(Paths.modsJson('${thing}/songData')))
				{
					saveFile(Paths.modsJson('${thing}/songData'), 'data/${thing}/songData.json', true, true);
					//trace('File songData was downloaded');
				}
				else
					trace('File songData already exists! Skipping downloading it');

				var songData:SongData = parseJSON(Paths.modFolders('data/${thing}/songData.json'));

				for (i in 1...parseDiffCount(thing, true) + 1)
				{
					if (!exists(Paths.modsJson('${thing}/${thing}-${i}')))
					{
						saveFile(Paths.modsJson('${thing}/${thing}-${i}'), 'data/${thing}/${thing}-${i}.json', true, true);
						//trace('${i} difficulty was downloaded');
					}
					else
						trace('${i} difficulty already exists! Skipping downloading it');
				}

				if (!exists(Paths.modsSongs('${thing}/Inst')))
				{
					saveFile('mods/songs/${thing}/Inst.ogg', 'songs/${thing}/Inst.ogg', true);
					//trace('Inst was downloaded');
				}
				else
					trace('Inst already exists! Skipping downloading it');

				if (parseJSON(Paths.modsJson('${thing}/${thing}-1')).song.needsVoices)
				{
					if (!exists(Paths.modsSongs('${thing}/Voices')))
					{
						saveFile('mods/songs/${thing}/Voices.ogg', 'songs/${thing}/Voices.ogg', true);
						//trace('Voices was downloaded');
					}
					else
						trace('Voices already exists! Skipping downloading it');
				}
				else
					trace('Voices not needed! Skipping downloading it');

				if (!exists(Paths.modFolders('data/${thing}/events.json')))
				{
					if (songData.uses.events)
					{
						saveFile(Paths.modFolders('data/${thing}/events.json'), 'data/${thing}/events.json', true, true);
						//trace('File events was downloaded');
					}
					//else
						//trace('File events not needed! Skipping downloading it');
				}
				else
					trace('File events already exists! Skipping downloading it');

				if (!exists(Paths.modFolders('data/${thing}/modchart.lua')))
				{
					if (songData.uses.modchart)
					{
						saveFile(Paths.modFolders('data/${thing}/modchart.lua'), 'data/${thing}/modchart.lua', true);
						//trace('File modchart was downloaded');
					}
					//else
						//trace('File modchart not needed! Skipping downloading it');
				}
				else
					trace('Modchart already exists! Skipping downloading it');
	
				if (!exists(Paths.modFolders('weeks/${thing}.json')))
				{
					saveFile(Paths.modFolders('weeks/${thing}.json'), 'weeks/${thing}.json', true, true);
					//trace('Week file was downloaded');
				}
				else
					trace('Week file already exists! Skipping downloading it');

				// extra files for song

				//if (songData.uses.characters.length == 0)
					//trace('Characters not needed! Skipping downloading it');
				for (i in 0...songData.uses.characters.length)
					downloadThing(songData.uses.characters[i], 1);

				//if (songData.uses.stages.length == 0)
					//trace('Stages not needed! Skipping downloading it');
				for (i in 0...songData.uses.stages.length)
					downloadThing(songData.uses.stages[i], 2);

				//if (songData.uses.notetypes.length == 0)
					//trace('Notetypes not needed! Skipping downloading it');
				for (i in 0...songData.uses.notetypes.length)
					downloadThing(songData.uses.notetypes[i], 3);
	
				trace('Song ${thing} downloaded successfully!');
	
			case 1:
				trace('Start downloading character ${thing}...');

				if (!exists(Paths.modFolders('characters/${thing}.json')))
				{
					saveFile(Paths.modFolders('characters/${thing}.json'), 'characters/${thing}/${thing}.json', true, true);
					//trace('JSON was downloaded');
				}
				else
					trace('JSON already exists! Skipping downloading it');

				if (!exists(Paths.modsImages('characters/${thing}')))
				{
					saveFile(Paths.modFolders('images/characters/${thing}.png'), 'characters/${thing}/${thing}.png', true);
					//trace('PNG was downloaded');
				}
				else
					trace('PNG already exists! Skipping downloading it');

				var icon = parseJSON(Paths.modFolders('characters/${thing}.json')).healthicon;
				switch (icon)
				{
					case 'bf' | 'dad' | 'gf' | 'pico' | 'pico-player':
						//trace('Health icon not needed! Skipping downloading it');
					default:
						if (!exists(Paths.modsImages('icons/${icon}')))
						{
							saveFile(Paths.modFolders('images/icons/icon-${icon}.png'), 'icons/icon-${icon}.png', true);
							//trace('Health icon was downloaded');
						}
						else
							trace('Health icon already exists! Skipping downloading it');
				}

				if (!exists(Paths.modsXml('characters/${thing}')))
				{
					saveFile(Paths.modFolders('images/characters/${thing}.xml'), 'characters/${thing}/${thing}.xml', true);
					//trace('XML was downloaded');
				}
				else
					trace('XML already exists! Skipping downloading it');

				trace('Character ${thing} downloaded successfully!');

			case 2:
				trace('Start downloading stage ${thing}...');

				if (!exists(Paths.modFolders('stages/${thing}.lua')))
				{
					saveFile(Paths.modFolders('stages/${thing}.lua'), 'stages/${thing}/${thing}.lua', true);
					//trace('Lua was downloaded');
				}
				else
					trace('Lua already exists! Skipping downloading it');

				if (!exists(Paths.modFolders('stages/${thing}.json')))
				{
					saveFile(Paths.modFolders('stages/${thing}.json'), 'stages/${thing}/${thing}.json', true, true);
					//trace('JSON was downloaded');
				}
				else
					trace('JSON already exists! Skipping downloading it');

				if (!isDir('mods/images/stages/${thing}'))
					createDir('mods/images/stages/${thing}');

				if (cycle)
				{
					for (i in 0...parseJSON(Paths.modFolders('stages/${thing}.json')).neededFiles.images.length)
						downloadThing('${thing}/${parseJSON(Paths.modFolders('stages/${thing}.json')).neededFiles.images[i]}', 6, false);
					for (i in 0...parseJSON(Paths.modFolders('stages/${thing}.json')).neededFiles.imagesWithXml.length)
					{
						downloadThing('${thing}/${parseJSON(Paths.modFolders('stages/${thing}.json')).neededFiles.imagesWithXml[i]}', 6, false);
						downloadThing('${thing}/${parseJSON(Paths.modFolders('stages/${thing}.json')).neededFiles.imagesWithXml[i]}', 7, false);
					}
					for (i in 0...parseJSON(Paths.modFolders('stages/${thing}.json')).neededFiles.sounds.length)
						downloadThing(parseJSON(Paths.modFolders('stages/${thing}.json')).neededFiles.sounds[i], 4, false);
					for (i in 0...parseJSON(Paths.modFolders('stages/${thing}.json')).neededFiles.music.length)
						downloadThing(parseJSON(Paths.modFolders('stages/${thing}.json')).neededFiles.music[i], 5, false);
				}

				trace('Stage ${thing} downloaded successfully!');

			case 3:
				//trace('Start downloading custom notetype ${thing}...');

				if (!exists(Paths.modsImages('custom_notetypes/${thing}')))
				{
					saveFile('mods/images/custom_notetypes/${thing}.png', 'custom_notetypes/${thing}/${thing}.png', true);
					//trace('PNG was downloaded');
				}
				else
					trace('PNG already exists! Skipping downloading it');
	
				if (!exists(Paths.modFolders('images/custom_notetypes/${thing}')))
				{
					saveFile('mods/images/custom_notetypes/${thing}.xml', 'custom_notetypes/${thing}/${thing}.xml', true);
					//trace('XML was downloaded');
				}
				else
					trace('XML already exists! Skipping downloading it');

				if (!exists(Paths.modFolders('custom_notetypes/${thing}.lua')))
				{
					saveFile('mods/custom_notetypes/${thing}.lua', 'custom_notetypes/${thing}/${thing}.lua', true);
					//trace('Lua was downloaded');
				}
				else
					trace('Lua already exists! Skipping downloading it');

				if (!exists(Paths.modFolders('custom_notetypes/${thing}.json')))
				{
					saveFile(Paths.modFolders('custom_notetypes/${thing}.json'), 'custom_notetypes/${thing}/${thing}.json', true, true);
					//trace('JSON was downloaded');
				}
				else
					trace('JSON already exists! Skipping downloading it');

				if (cycle)
				{
					for (i in 0...parseJSON(Paths.modFolders('custom_notetypes/${thing}.json')).neededFiles.characters.length)
						downloadThing(parseJSON(Paths.modFolders('custom_notetypes/${thing}.json')).neededFiles.characters[i], 1, false);
					for (i in 0...parseJSON(Paths.modFolders('custom_notetypes/${thing}.json')).neededFiles.sounds.length)
						downloadThing(parseJSON(Paths.modFolders('custom_notetypes/${thing}.json')).neededFiles.sounds[i], 4, false);
					for (i in 0...parseJSON(Paths.modFolders('custom_notetypes/${thing}.json')).neededFiles.music.length)
						downloadThing(parseJSON(Paths.modFolders('custom_notetypes/${thing}.json')).neededFiles.music[i], 5, false);
				}

				trace('Custom notetype ${thing} downloaded successfully!');

			case 4:
				//trace('Start downloading sound ${thing}...');

				if (!isDir(Paths.modFolders('sounds')))
					createDir(Paths.modFolders('sounds'));

				if (!exists(Paths.modsSounds('${thing}')))
				{
					saveFile('mods/sounds/${thing}.ogg', 'sounds/${thing}.ogg', true);
					//trace('Sound was downloaded');
					trace ('Sound ${thing} downloaded successfully!');
				}
				else
					trace('Sound already exists! Skipping downloading it');

			case 5:
				//trace('Start downloading music ${thing}...');

				if (!isDir(Paths.modFolders('music')))
					createDir(Paths.modFolders('music'));

				if (!exists(Paths.modsMusic('${thing}')))
				{
					saveFile('mods/music/${thing}.ogg', 'music/${thing}.ogg', true);
					//trace('Music was downloaded');
					trace ('Music ${thing} downloaded successfully!');
				}
				else
					trace('Music already exists! Skipping downloading it');

			case 6:
				//trace('Start downloading image ${thing}...');

				if (!exists(Paths.modFolders('images/stages/${thing}.png')))
				{
					saveFile(Paths.modFolders('images/stages/${thing}.png'), 'stages/${thing}.png', true);
					//trace('Image was downloaded');
					trace('Image ${thing} downloaded successfully!');
				}
				else
					trace('Image already exists! Skipping downloading it');

			case 7:
				//trace('Start downloading XML of image ${thing}...');

				if (!exists(Paths.modFolders('images/stages/${thing}.xml')))
				{
					saveFile(Paths.modFolders('images/stages/${thing}.xml'), 'stages/${thing}.xml', true);
					//trace('XML of image was downloaded');
					trace('XML of image ${thing} downloaded successfully!');
				}
				else
					trace('XML of image already exists! Skipping downloading it');
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
