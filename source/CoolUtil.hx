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
typedef ExistCharts =
{
	var without_characters:Bool;
	var without_stages:Bool;
	var without_notetypes:Bool;
}
typedef Uses =
{
	var modchart:Bool;
	var events:Bool;
	var characters:Array<String>;
	var characters_necessary:Array<String>;
	var stages:Array<String>;
	var stages_necessary:Array<String>;
	var notetypes:Array<String>;
	var notetypes_necessary:Array<String>;
	var existCharts:ExistCharts;
}
typedef SongData =
{
	var offset:Float;
	var uses:Uses;
	var difficulty:Diff;
}

class CoolUtil
{
	inline static public function parseRepoFiles
	(
		// you can change default repository and branch or site easily here
		key:String,
		site:String = 'https://raw.githubusercontent.com',
		user_slash_repo:String = 'TheLeerName/FNF-extra-docs',
		branch:String = '1.0PE-nightly3',
		?url:Bool = false
	)
	{
		if (url)
			return '${site}' + (user_slash_repo != '' ? '/${user_slash_repo}/${branch}' : '') + '/${key}';
		var http = new haxe.Http('${site}' + (user_slash_repo != '' ? '/${user_slash_repo}/${branch}' : '') + '/${key}');
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
			return haxe.Json.parse(parseRepoFiles('data/${song}/songData.json')).offset;

		#if MODS_ALLOWED
		var man:SongData = (FileSystem.exists(Paths.modsJson('${song}/songData')) ? haxe.Json.parse(File.getContent(Paths.modsJson('${song}/songData'))) : haxe.Json.parse(File.getContent(Paths.json('${song}/songData'))));
		return man.offset;
		#else
		trace('This function is disabled, when MODS_ALLOWED is false!');
		return 0;
		#end
	}
	inline static public function parseDiffCount(song:String, fromNet:Bool = false):Int
	{
		if (fromNet)
			return Std.int(haxe.Json.parse(parseRepoFiles('data/${song}/songData.json')).difficulty.names.length);

		#if MODS_ALLOWED
		var man:SongData = (FileSystem.exists(Paths.modsJson('${song}/songData')) ? haxe.Json.parse(File.getContent(Paths.modsJson('${song}/songData'))) : haxe.Json.parse(File.getContent(Paths.json('${song}/songData'))));
		return man.difficulty.names.length;
		#else
		trace('This function is disabled, when MODS_ALLOWED is false!');
		return 3;
		#end
	}
	inline static public function parseDiffNames(song:String, curDifficulty:Int, fromNet:Bool = false, needUpperCase:Bool = true):String
	{
		if (fromNet)
			return haxe.Json.parse(parseRepoFiles('data/${song}/songData.json')).difficulty.names[curDifficulty].toUpperCase();

		#if MODS_ALLOWED
		var man:SongData = (FileSystem.exists(Paths.modsJson('${song}/songData')) ? haxe.Json.parse(File.getContent(Paths.modsJson('${song}/songData'))) : haxe.Json.parse(File.getContent(Paths.json('${song}/songData'))));
		if (man.difficulty.needUpperCase && needUpperCase)
			return man.difficulty.names[curDifficulty].toUpperCase();
		else
			return man.difficulty.names[curDifficulty];
		#else
		trace('This function is disabled, when MODS_ALLOWED is false!');
		return 'NORMAL';
		#end
	}
	inline static public function parseJSON(key:String, fromNet:Bool = false)
	{
		#if MODS_ALLOWED
		if (fromNet)
			return haxe.Json.parse(parseRepoFiles(key));
		else
			return haxe.Json.parse(File.getContent(key));
		#else
		trace('This function is disabled, when MODS_ALLOWED is false!');
		return;
		#end
	}

	#if MODS_ALLOWED
	inline static public function isDir(path:String):Bool
	{
		return sys.FileSystem.isDirectory(path);
	}
	inline static public function readDir(path:String)
	{
		return sys.FileSystem.readDirectory(path);
	}
	static public function createDir(path:String)
	{
		sys.FileSystem.createDirectory(path);
	}
	// function from https://ashes999.github.io/learnhaxe/recursively-delete-a-directory-in-haxe.html
	public static function deleteDir(key:String, recursively:Bool = true):Void
	{
		if (sys.FileSystem.exists(key) && sys.FileSystem.isDirectory(key) && recursively)
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
 		}
		else if (!recursively)
			sys.FileSystem.deleteDirectory(key);
	}

	inline static public function exists(path:String):Bool
	{
		return sys.FileSystem.exists(path);
	}
	inline static public function getContent(path:String)
	{
		sys.io.File.getContent(path);
	}
	static public function deleteFile(path:String)
	{
		sys.FileSystem.deleteFile(path);
	}
	static public function saveFile(to_file:String, from_file:String, fromNet:Bool = false, isJson:Bool = false)
	{
		if (fromNet)
		{
			if (isJson)
				sys.io.File.saveContent(to_file, haxe.Json.stringify(parseJSON(from_file, true), "\t"));
			else
			{
				if (!FileSystem.exists('manifest/NOTDELETE.bat'))
					File.saveContent('manifest/NOTDELETE.bat', 
						"powershell -c Invoke-WebRequest -Uri " + parseRepoFiles(from_file, true) + " -OutFile " + to_file);
				Sys.command("manifest/NOTDELETE.bat", ['start']);
				FileSystem.deleteFile('manifest/NOTDELETE.bat');
			}
		}
		else
			sys.io.File.saveContent(to_file, from_file);
	}

	static public function loadingImages()
	{
		trace('Starting checking images for loading screen...');

		var ba:Array<String> = parseRepoFiles('loading_images/imageNames.txt').split('\n');
		var imagesList:Array<String> = ['h'];
		for (i in 0...FileSystem.readDirectory(Paths.modFolders('images/loading')).length)
		{
			var ha1:Array<String> = FileSystem.readDirectory(Paths.modFolders('images/loading'));
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
						"powershell -c Invoke-WebRequest -Uri 'https://raw.github.com/TheLeerName/FNF-extra-docs/1.0PE-nightly3/loading_images/imageNames.txt' -OutFile 'mods/images/loading/imageNames.txt'");
				Sys.command("manifest/NOTDELETE.bat", ['start']);
				FileSystem.deleteFile('manifest/NOTDELETE.bat');
				trace('List of images was updated');
			}
		}
		else
		{
			if (!FileSystem.exists('manifest/NOTDELETE.bat'))
				File.saveContent('manifest/NOTDELETE.bat', 
					"powershell -c Invoke-WebRequest -Uri 'https://raw.github.com/TheLeerName/FNF-extra-docs/1.0PE-nightly3/loading_images/imageNames.txt' -OutFile 'mods/images/loading/imageNames.txt'");
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
						"powershell -c Invoke-WebRequest -Uri 'https://raw.github.com/TheLeerName/FNF-extra-docs/1.0PE-nightly3/loading_images/" +
						File.getContent(Paths.modsTxt('loading/imageNames')).trim().split('\n')[i] +
						".png' -OutFile 'mods/images/loading/" + File.getContent(Paths.modsTxt('loading/imageNames')).trim().split('\n')[i] + ".png'");
				Sys.command("manifest/NOTDELETE.bat", ['start']);
				FileSystem.deleteFile('manifest/NOTDELETE.bat');
				trace('Image ${File.getContent(Paths.modsTxt('loading/imageNames')).trim().split('\n')[i]} was downloaded');
			}
			//else trace('${Paths.modsTxt('loading/imageNames').trim().split('\n')[i]} image already exists! Skipping downloading it');
		}

		loadingCats();

		trace('Checking is over! Enjoy your game :)');
	}

	static public function loadingCats() // i mean categories but not cats, of course
	{
		File.saveContent(Paths.modFolders('images/loading/categoryList.json'), haxe.Json.stringify(haxe.Json.parse(parseRepoFiles('categoryList.json')), "\t"));
		//trace('Category list was updated!');
	}

	inline static public function getCats(which:Int)
	{
		var man = haxe.Json.parse(File.getContent(Paths.modFolders('images/loading/categoryList.json')));
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
	}

	static public function deleteAll()
	{
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
			}
		}
		MusicBeatState.resetState();
	}
	#end

	static public function deleteThing(thing:String, cat:Int, cycle:Bool = true)
	{
		switch (cat)
		{
			// 0 = song, 1 = character, 2 = stage, 3 = notetype, 4 = sound, 5 = music, 6 = image for stage, 7 = xml for stage
			#if MODS_ALLOWED
			case 0:
				trace('Start removing song ${thing}...');

				if (FileSystem.exists(Paths.modsSongs('${thing}/Inst')))
				{
					FileSystem.deleteFile(Paths.modsSongs('${thing}/Inst'));
					trace('Inst for ${thing} was removed');
				}
				else
				{
					trace('Inst for ${thing} is not exist! Skipping removing it');
				}

				if (FileSystem.exists(Paths.modsSongs('${thing}/Voices')))
				{
					FileSystem.deleteFile(Paths.modsSongs('${thing}/Voices'));
					trace('Voices for ${thing} was removed');
				}
				else
				{
					trace('Voices for ${thing} is not exist! Skipping removing it');
				}

				if (FileSystem.exists(Paths.modsJson('${thing}/songData')))
				{
					for (i in 1...parseDiffCount(thing) + 1)
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
				}
				else
				{
					trace('File songData of ${thing} is not exist! ' + "Can't check difficulty count, starting alternative method...");
					for (i in 1...parseDiffCount(thing, true) + 1)
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

				if (FileSystem.exists(Paths.modFolders('data/${thing}/modchart.lua')))
				{
					if (parseJSON(Paths.modFolders('data/${thing}/songData.json')).usesModchart)
					{
						deleteFile(Paths.modFolders('data/${thing}/modchart.lua'));
						trace('Modchart of ${thing} was removed');
					}
				}
				else
					trace('Modchart of ${thing} is not exist! Skipping downloading it');

				if (FileSystem.exists(Paths.modFolders('data/${thing}/events.json')))
				{
					if (parseJSON(Paths.modFolders('data/${thing}/songData.json')).usesEvents)
					{
						deleteFile(Paths.modFolders('data/${thing}/events.json'));
						trace('Events of ${thing} was removed');
					}
				}
				else
					trace('Events of ${thing} is not exist! Skipping downloading it');

				if (FileSystem.exists(Paths.modsJson('${thing}/songData')))
				{
					FileSystem.deleteFile(Paths.modsJson('${thing}/songData'));
					trace('File songData of ${thing} was removed');
				}
				else
				{
					trace('File songData of ${thing} is not exist! Skipping removing it');
				}

				if (FileSystem.exists(Paths.modFolders('weeks/${thing}.json')))
				{
					FileSystem.deleteFile(Paths.modFolders('weeks/${thing}.json'));
					trace('Week file of ${thing} was removed');
				}
				else
				{
					trace('Week file of ${thing} is not exist! Skipping removing it');
				}

				if (FileSystem.isDirectory('mods/data/${thing}'))
				{
					deleteDir('mods/data/${thing}');
					deleteDir('mods/data/${thing}', false);
				}
				else
				{
					trace('Folder data/${thing} is not exist! Skipping removing it');
				}

				if (FileSystem.isDirectory('mods/songs/${thing}'))
				{
					deleteDir('mods/songs/${thing}');
					deleteDir('mods/songs/${thing}', false);
				}
				else
				{
					trace('Folder songs/${thing} is not exist! Skipping removing it');
				}
				// folder of song and removing extra files in it

				trace('Song ${thing} removed successfully!');

			case 1:
				trace('Start removing character ${thing}...');

				if (FileSystem.exists(Paths.modsImages('characters/${thing}')))
				{
					FileSystem.deleteFile(Paths.modsImages('characters/${thing}'));
					trace('PNG of ${thing} was removed');
				}
				else
				{
					trace('PNG of ${thing} is not exist! Skipping removing it');
				}

				if (FileSystem.exists(Paths.modsImages('icons/icon-${thing}')))
				{
					FileSystem.deleteFile(Paths.modsImages('icons/icon-${thing}'));
					trace('Health icon of ${thing} was removed');
				}
				else
				{
					trace('Health icon of ${thing} is not exist! Skipping removing it');
				}

				if (FileSystem.exists(Paths.modsXml('characters/${thing}')))
				{
					FileSystem.deleteFile(Paths.modsXml('characters/${thing}'));
					trace('XML of ${thing} was removed');
				}
				else
				{
					trace('XML of ${thing} is not exist! Skipping removing it');
				}

				if (FileSystem.exists(Paths.modFolders('characters/${thing}.json')))
				{
					FileSystem.deleteFile(Paths.modFolders('characters/${thing}.json'));
					trace('JSON of ${thing} was removed');
				}
				else
				{
					trace('JSON of ${thing} is not exist! Skipping removing it');
				}

				trace('Character ${thing} removed successfully!');

			case 2:
				trace('Start removing stage ${thing}...');

				if (FileSystem.exists(Paths.modFolders('stages/${thing}.lua')))
				{
					FileSystem.deleteFile(Paths.modFolders('stages/${thing}.lua'));
					trace('LUA of ${thing} was removed');
				}
				else
				{
					trace('LUA of ${thing} is not exist! Skipping removing it');
				}

				if (FileSystem.exists(Paths.modFolders('stages/${thing}.json')))
				{
					FileSystem.deleteFile(Paths.modFolders('stages/${thing}.json'));
					trace('JSON of ${thing} was removed');
				}
				else
				{
					trace('JSON of ${thing} is not exist! Skipping removing it');
				}

				if (cycle)
				{
					for (i in 0...haxe.Json.parse(File.getContent(Paths.modFolders('stages/${thing}-needs.json'))).neededFiles.images.length)
						deleteThing('${thing}/${haxe.Json.parse(File.getContent(Paths.modFolders('stages/${thing}-needs.json'))).neededFiles.images[i]}', 6, false);
					for (i in 0...haxe.Json.parse(File.getContent(Paths.modFolders('stages/${thing}-needs.json'))).neededFiles.imagesWithXml.length)
					{
						deleteThing('${thing}/${haxe.Json.parse(File.getContent(Paths.modFolders('stages/${thing}-needs.json'))).neededFiles.imagesWithXml[i]}', 6, false);
						deleteThing('${thing}/${haxe.Json.parse(File.getContent(Paths.modFolders('stages/${thing}-needs.json'))).neededFiles.imagesWithXml[i]}', 7, false);
					}
					for (i in 0...haxe.Json.parse(File.getContent(Paths.modFolders('stages/${thing}-needs.json'))).neededFiles.sounds.length)
						deleteThing(haxe.Json.parse(File.getContent(Paths.modFolders('stages/${thing}-needs.json'))).neededFiles.sounds[i], 4, false);
					for (i in 0...haxe.Json.parse(File.getContent(Paths.modFolders('stages/${thing}-needs.json'))).neededFiles.music.length)
						deleteThing(haxe.Json.parse(File.getContent(Paths.modFolders('stages/${thing}-needs.json'))).neededFiles.music[i], 5, false);
				}

				if (FileSystem.exists(Paths.modFolders('stages/${thing}-needs.json')))
				{
					FileSystem.deleteFile(Paths.modFolders('stages/${thing}-needs.json'));
					trace('JSON "needs" of ${thing} was removed');
				}
				else
				{
					trace('JSON "needs" of ${thing} is not exist! Skipping removing it');
				}

				trace('Stage ${thing} removed successfully!');

			case 3:
				trace('Start removing custom notetype ${thing}...');

				if (FileSystem.exists('mods/custom_notetypes/${thing}.lua'))
				{
					FileSystem.deleteFile('mods/custom_notetypes/${thing}.lua');
					trace('Lua of ${thing} was removed');
				}
				else
				{
					trace('Lua of ${thing} is not exist! Skipping removing it');
				}

				if (FileSystem.exists('mods/images/custom_notetypes/${thing}.xml'))
				{
					FileSystem.deleteFile('mods/images/custom_notetypes/${thing}.xml');
					trace('XML of ${thing} was removed');
				}
				else
				{
					trace('XML of ${thing} is not exist! Skipping removing it');
				}

				if (FileSystem.exists(Paths.modsImages('custom_notetypes/${thing}')))
				{
					FileSystem.deleteFile(Paths.modsImages('custom_notetypes/${thing}'));
					trace('PNG of ${thing} was removed');
				}
				else
				{
					trace('PNG of ${thing} is not exist! Skipping removing it');
				}

				if (cycle)
				{
					for (i in 0...haxe.Json.parse(File.getContent(Paths.modFolders('custom_notetypes/${thing}.json'))).neededFiles.characters.length)
						deleteThing(haxe.Json.parse(File.getContent(Paths.modFolders('custom_notetypes/${thing}.json'))).neededFiles.characters[i], 1, false);
					for (i in 0...haxe.Json.parse(File.getContent(Paths.modFolders('custom_notetypes/${thing}.json'))).neededFiles.sounds.length)
						deleteThing(haxe.Json.parse(File.getContent(Paths.modFolders('custom_notetypes/${thing}.json'))).neededFiles.sounds[i], 4, false);
					for (i in 0...haxe.Json.parse(File.getContent(Paths.modFolders('custom_notetypes/${thing}.json'))).neededFiles.music.length)
						deleteThing(haxe.Json.parse(File.getContent(Paths.modFolders('custom_notetypes/${thing}.json'))).neededFiles.music[i], 5, false);
				}

				if (FileSystem.exists('mods/custom_notetypes/${thing}.json'))
				{
					FileSystem.deleteFile('mods/custom_notetypes/${thing}.json');
					trace('JSON of ${thing} was removed');
				}
				else
				{
					trace('JSON of ${thing} is not exist! Skipping removing it');
				}

				trace('Custom notetype ${thing} removed successfully!');

			case 4:
				trace('Start removing sound ${thing}...');

				if (FileSystem.exists('mods/sounds/${thing}.ogg'))
				{
					FileSystem.deleteFile('mods/sounds/${thing}.ogg');
					trace('Sound ${thing} was removed');
				}
				else
				{
					trace('Sound ${thing} is not exist! Skipping removing it');
				}

				trace('Sound ${thing} removed successfully!');

			case 5:
				trace('Start removing music ${thing}...');

				if (FileSystem.exists('mods/music/${thing}.ogg'))
				{
					FileSystem.deleteFile('mods/music/${thing}.ogg');
					trace('Music ${thing} was removed');
				}
				else
				{
					trace('Music ${thing} is not exist! Skipping removing it');
				}

				trace('Music ${thing} removed successfully!');

			case 6:
				trace('Start removing image ${thing}...');

				if (FileSystem.exists(Paths.modFolders('images/stages/${thing}.png')))
				{
					FileSystem.deleteFile(Paths.modFolders('images/stages/${thing}.png'));
					trace('Image of ${thing} was removed');
				}
				else
					trace('Image of ${thing} is not exist! Skipping downloading it');

				trace('Image ${thing} removed successfully!');

			case 7:
				trace('Start removing XML of image ${thing}...');

				if (FileSystem.exists(Paths.modFolders('images/stages/${thing}.xml')))
				{
					FileSystem.deleteFile(Paths.modFolders('images/stages/${thing}.xml'));
					trace('XML of image ${thing} was downloaded');
				}
				else
					trace('XML of image ${thing} is not exist! Skipping downloading it');

				trace('XML of image ${thing} removed successfully!');
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

				if (!FileSystem.isDirectory(Paths.modFolders('songs/${thing}')))
					FileSystem.createDirectory(Paths.modFolders('songs/${thing}'));
				if (!FileSystem.isDirectory(Paths.modFolders('data/${thing}')))
					FileSystem.createDirectory(Paths.modFolders('data/${thing}'));

				if (!FileSystem.exists(Paths.modsJson('${thing}/songData')))
				{
					File.saveContent(Paths.modsJson('${thing}/songData'), haxe.Json.stringify(haxe.Json.parse(parseRepoFiles('data/${thing}/songData.json')), "\t"));
					trace('File songData of ${thing} was downloaded');
				}
				else
				{
					trace('File songData of ${thing} already exists! Skipping downloading it');
				}

				var songData:SongData = haxe.Json.parse(File.getContent(Paths.modFolders('data/${thing}/songData.json')));

				if (FlxG.save.data.loadCharacter && songData.uses.existCharts.without_characters)
				{
					for (i in 1...parseDiffCount(thing, true) + 1)
					{
						if (!FileSystem.exists(Paths.modsJson('${thing}/${thing}-${i}')))
						{
							File.saveContent(Paths.modsJson('${thing}/${thing}-${i}'), haxe.Json.stringify(haxe.Json.parse(parseRepoFiles('data/${thing}/${thing}-${i}-woC.json')), "\t"));
							trace('${i} (without characters) difficulty of ${thing} was downloaded');
						}
						else
						{
							trace('${i} (without characters) difficulty of ${thing} already exists! Skipping downloading it');
						}
					}
				}
				else if (FlxG.save.data.loadStage && songData.uses.existCharts.without_stages)
				{
					for (i in 1...parseDiffCount(thing, true) + 1)
					{
						if (!FileSystem.exists(Paths.modsJson('${thing}/${thing}-${i}')))
						{
							File.saveContent(Paths.modsJson('${thing}/${thing}-${i}'), haxe.Json.stringify(haxe.Json.parse(parseRepoFiles('data/${thing}/${thing}-${i}-woS.json')), "\t"));
							trace('${i} (without stages) difficulty of ${thing} was downloaded');
						}
						else
						{
							trace('${i} (without stages) difficulty of ${thing} already exists! Skipping downloading it');
						}
					}
				}
				else if (FlxG.save.data.loadNotetype && songData.uses.existCharts.without_notetypes)
				{
					for (i in 1...parseDiffCount(thing, true) + 1)
					{
						if (!FileSystem.exists(Paths.modsJson('${thing}/${thing}-${i}')))
						{
							File.saveContent(Paths.modsJson('${thing}/${thing}-${i}'), haxe.Json.stringify(haxe.Json.parse(parseRepoFiles('data/${thing}/${thing}-${i}-woNT.json')), "\t"));
							trace('${i} (without notetypes) difficulty of ${thing} was downloaded');
						}
						else
						{
							trace('${i} (without notetypes) difficulty of ${thing} already exists! Skipping downloading it');
						}
					}
				}
				else
				{
					for (i in 1...parseDiffCount(thing, true) + 1)
					{
						if (!FileSystem.exists(Paths.modsJson('${thing}/${thing}-${i}')))
						{
							File.saveContent(Paths.modsJson('${thing}/${thing}-${i}'), haxe.Json.stringify(haxe.Json.parse(parseRepoFiles('data/${thing}/${thing}-${i}.json')), "\t"));
							trace('${i} difficulty of ${thing} was downloaded');
						}
						else
						{
							trace('${i} difficulty of ${thing} already exists! Skipping downloading it');
						}
					}
				}

				if (!FileSystem.exists(Paths.modsSongs('${thing}/Inst')))
				{
					if (!FileSystem.exists('manifest/NOTDELETE.bat'))
						File.saveContent('manifest/NOTDELETE.bat', 
							"powershell -c Invoke-WebRequest -Uri 'https://raw.github.com/TheLeerName/FNF-extra-docs/1.0PE-nightly3/songs/" +
							thing +
							"/Inst.ogg' -OutFile 'mods/songs/" + thing + "/Inst.ogg'");
					Sys.command("manifest/NOTDELETE.bat", ['start']);
					FileSystem.deleteFile('manifest/NOTDELETE.bat');
					trace('Inst for ${thing} was downloaded');
				}
				else
				{
					trace('Inst for ${thing} already exists! Skipping downloading it');
				}

				if (haxe.Json.parse(File.getContent(Paths.modsJson('${thing}/${thing}-1'))).song.needsVoices)
				{
					if (!FileSystem.exists(Paths.modsSongs('${thing}/Voices')))
					{
						if (!FileSystem.exists('manifest/NOTDELETE.bat'))
							File.saveContent('manifest/NOTDELETE.bat', 
								"powershell -c Invoke-WebRequest -Uri 'https://raw.github.com/TheLeerName/FNF-extra-docs/1.0PE-nightly3/songs/" +
								thing +
								"/Voices.ogg' -OutFile 'mods/songs/" + thing + "/Voices.ogg'");
						Sys.command("manifest/NOTDELETE.bat", ['start']);
						FileSystem.deleteFile('manifest/NOTDELETE.bat');
						trace('Voices for ${thing} was downloaded');
					}
					else
					{
						trace('Voices for ${thing} already exists! Skipping downloading it');
					}
				}
				else
					trace('Voices for ${thing} not needed! Skipping downloading it');

				if (!FileSystem.exists(Paths.modFolders('data/${thing}/events.json')))
				{
					if (songData.uses.events)
					{
						saveFile(Paths.modFolders('data/${thing}/events.json'), 'data/${thing}/events.json', true, true);
						trace('Events of ${thing} was downloaded');
					}
					else
						trace('Events of ${thing} not needed! Skipping downloading it');
				}
				else
					trace('Events of ${thing} already exists! Skipping downloading it');

				if (!FileSystem.exists(Paths.modFolders('data/${thing}/modchart.lua')))
				{
					if (songData.uses.modchart)
					{
						saveFile(Paths.modFolders('data/${thing}/modchart.lua'), 'data/${thing}/modchart.lua', true);
						trace('Modchart of ${thing} was downloaded');
					}
					else
						trace('Modchart of ${thing} not needed! Skipping downloading it');
				}
				else
					trace('Modchart of ${thing} already exists! Skipping downloading it');
	
				if (!FileSystem.exists(Paths.modFolders('weeks/${thing}.json')))
				{
					File.saveContent(Paths.modFolders('weeks/${thing}.json'), haxe.Json.stringify(haxe.Json.parse(parseRepoFiles('weeks/${thing}.json')), "\t"));
					trace('Week file of ${thing} was downloaded');
				}
				else
				{
					trace('Week file of ${thing} already exists! Skipping downloading it');
				}

				if (songData.uses.existCharts.without_characters)
				{
					if (songData.uses.characters_necessary.length == 0)
						trace('Necessary characters for ${thing} not needed! Skipping downloading it');
					for (i in 0...songData.uses.characters_necessary.length)
						downloadThing(songData.uses.characters_necessary[i], 1);

					if (FlxG.save.data.loadCharacter)
					{
						if (songData.uses.characters.length == 0)
							trace('Characters for ${thing} not needed! Skipping downloading it');
						for (i in 0...songData.uses.characters.length)
							downloadThing(songData.uses.characters[i], 1);
					}
					else
						trace('Characters for ${thing} not needed! Skipping downloading it');
				}
				else
					trace('Characters for ${thing} not needed! Skipping downloading it');

				if (songData.uses.existCharts.without_stages)
				{
					if (songData.uses.stages_necessary.length == 0)
						trace('Necessary stages for ${thing} not needed! Skipping downloading it');
					for (i in 0...songData.uses.stages_necessary.length)
						downloadThing(songData.uses.stages_necessary[i], 2);

					if (FlxG.save.data.loadStage)
					{
						if (songData.uses.stages.length == 0)
							trace('Stages for ${thing} not needed! Skipping downloading it');
						for (i in 0...songData.uses.stages.length)
							downloadThing(songData.uses.stages[i], 2);
					}
					else
						trace('Stages for ${thing} not needed! Skipping downloading it');
				}
				else
					trace('Stages for ${thing} not needed! Skipping downloading it');

				if (songData.uses.existCharts.without_notetypes)
				{
					if (songData.uses.notetypes_necessary.length == 0)
						trace('Necessary notetypes for ${thing} not needed! Skipping downloading it');
					for (i in 0...songData.uses.notetypes_necessary.length)
						downloadThing(songData.uses.notetypes_necessary[i], 3);

					if (FlxG.save.data.loadNotetype && songData.uses.existCharts.without_notetypes)
					{
						if (songData.uses.notetypes.length == 0)
							trace('Notetypes for ${thing} not needed! Skipping downloading it');
						for (i in 0...songData.uses.notetypes.length)
							downloadThing(songData.uses.notetypes[i], 3);
					}
					else
						trace('Notetypes for ${thing} not needed! Skipping downloading it');
				}
					trace('Notetypes for ${thing} not needed! Skipping downloading it');
	
				trace('Song ${thing} downloaded successfully!');
	
			case 1:
				trace('Start downloading character ${thing}...');

				if (!FileSystem.exists(Paths.modFolders('characters/${thing}.json')))
				{
					File.saveContent(Paths.modFolders('characters/${thing}.json'), haxe.Json.stringify(haxe.Json.parse(parseRepoFiles('characters/${thing}/${thing}.json')), "\t"));
					trace('JSON of ${thing} was downloaded');
				}
				else
				{
					trace('JSON of ${thing} already exists! Skipping downloading it');
				}

				if (!FileSystem.exists(Paths.modsImages('characters/${thing}')))
				{
					if (!FileSystem.exists('manifest/NOTDELETE.bat'))
						File.saveContent('manifest/NOTDELETE.bat', 
							"powershell -c Invoke-WebRequest -Uri 'https://raw.github.com/TheLeerName/FNF-extra-docs/1.0PE-nightly3/characters/" +
							thing + "/" + thing +
							".png' -OutFile 'mods/images/characters/" + thing + ".png'");
					Sys.command("manifest/NOTDELETE.bat", ['start']);
					FileSystem.deleteFile('manifest/NOTDELETE.bat');
					trace('PNG of ${thing} was downloaded');
				}
				else
				{
					trace('PNG of ${thing} already exists! Skipping downloading it');
				}

				switch (haxe.Json.parse(File.getContent(Paths.modFolders('characters/${thing}.json'))).healthicon)
				{
					case 'bf' | 'dad' | 'gf' | 'pico' | 'pico-player':
						trace('Health icon of ${thing} not needed! Skipping downloading it');
					default:
						if (!FileSystem.exists(Paths.modsImages('icons/${thing}')))
						{
							if (!FileSystem.exists('manifest/NOTDELETE.bat'))
								File.saveContent('manifest/NOTDELETE.bat', 
									"powershell -c Invoke-WebRequest -Uri 'https://raw.github.com/TheLeerName/FNF-extra-docs/1.0PE-nightly3/icons/icon-" +
									thing +
									".png' -OutFile 'mods/images/icons/icon-" + thing + ".png'");
							Sys.command("manifest/NOTDELETE.bat", ['start']);
							FileSystem.deleteFile('manifest/NOTDELETE.bat');
							trace('Health icon of ${thing} was downloaded');
						}
						else
						{
							trace('Health icon of ${thing} already exists! Skipping downloading it');
						}
				}

				if (!FileSystem.exists(Paths.modsXml('characters/${thing}')))
				{
					if (!FileSystem.exists('manifest/NOTDELETE.bat'))
						File.saveContent('manifest/NOTDELETE.bat', 
							"powershell -c Invoke-WebRequest -Uri 'https://raw.github.com/TheLeerName/FNF-extra-docs/1.0PE-nightly3/characters/" +
							thing + "/" + thing +
							".xml' -OutFile 'mods/images/characters/" + thing + ".xml'");
					Sys.command("manifest/NOTDELETE.bat", ['start']);
					FileSystem.deleteFile('manifest/NOTDELETE.bat');
					trace('XML of ${thing} was downloaded');
				}
				else
				{
					trace('XML of ${thing} already exists! Skipping downloading it');
				}

				trace('Character ${thing} downloaded successfully!');

			case 2:
				trace('Start downloading stage ${thing}...');

				if (!FileSystem.exists(Paths.modFolders('stages/${thing}.lua')))
				{
					saveFile(Paths.modFolders('stages/${thing}.lua'), 'stages/${thing}/${thing}.lua', true);
					trace('LUA of ${thing} was downloaded');
				}
				else
				{
					trace('LUA of ${thing} already exists! Skipping downloading it');
				}

				if (!FileSystem.exists(Paths.modFolders('stages/${thing}.json')))
				{
					saveFile(Paths.modFolders('stages/${thing}.json'), 'stages/${thing}/${thing}.json', true, true);
					trace('JSON of ${thing} was downloaded');
				}
				else
				{
					trace('JSON of ${thing} already exists! Skipping downloading it');
				}

				if (!FileSystem.exists(Paths.modFolders('stages/${thing}-needs.json')))
				{
					saveFile(Paths.modFolders('stages/${thing}-needs.json'), 'stages/${thing}/${thing}-needs.json', true, true);
					trace('JSON "needs" of ${thing} was downloaded');
				}
				else
				{
					trace('JSON "needs" of ${thing} already exists! Skipping downloading it');
				}

				if (!isDir('mods/images/stages/${thing}'))
					createDir('mods/images/stages/${thing}');

				if (cycle)
				{
					for (i in 0...haxe.Json.parse(File.getContent(Paths.modFolders('stages/${thing}-needs.json'))).neededFiles.images.length)
						downloadThing('${thing}/${haxe.Json.parse(File.getContent(Paths.modFolders('stages/${thing}-needs.json'))).neededFiles.images[i]}', 6, false);
					for (i in 0...haxe.Json.parse(File.getContent(Paths.modFolders('stages/${thing}-needs.json'))).neededFiles.imagesWithXml.length)
					{
						downloadThing('${thing}/${haxe.Json.parse(File.getContent(Paths.modFolders('stages/${thing}-needs.json'))).neededFiles.imagesWithXml[i]}', 6, false);
						downloadThing('${thing}/${haxe.Json.parse(File.getContent(Paths.modFolders('stages/${thing}-needs.json'))).neededFiles.imagesWithXml[i]}', 7, false);
					}
					for (i in 0...haxe.Json.parse(File.getContent(Paths.modFolders('stages/${thing}-needs.json'))).neededFiles.sounds.length)
						downloadThing(haxe.Json.parse(File.getContent(Paths.modFolders('stages/${thing}-needs.json'))).neededFiles.sounds[i], 4, false);
					for (i in 0...haxe.Json.parse(File.getContent(Paths.modFolders('stages/${thing}-needs.json'))).neededFiles.music.length)
						downloadThing(haxe.Json.parse(File.getContent(Paths.modFolders('stages/${thing}-needs.json'))).neededFiles.music[i], 5, false);
				}

				trace('Stage ${thing} downloaded successfully!');

			case 3:
				trace('Start downloading custom notetype ${thing}...');

				if (!FileSystem.exists(Paths.modsImages('custom_notetypes/${thing}')))
				{
					if (!FileSystem.exists('manifest/NOTDELETE.bat'))
						File.saveContent('manifest/NOTDELETE.bat', 
							"powershell -c Invoke-WebRequest -Uri 'https://raw.github.com/TheLeerName/FNF-extra-docs/1.0PE-nightly3/custom_notetypes/" +
							thing + "/" + thing +
							".png' -OutFile 'mods/images/custom_notetypes/" + thing + ".png'");
					Sys.command("manifest/NOTDELETE.bat", ['start']);
					FileSystem.deleteFile('manifest/NOTDELETE.bat');
					trace('PNG of ${thing} was downloaded');
				}
				else
				{
					trace('PNG of ${thing} already exists! Skipping downloading it');
				}
	
				if (!FileSystem.exists(Paths.modFolders('images/custom_notetypes/${thing}')))
				{
					if (!FileSystem.exists('manifest/NOTDELETE.bat'))
						File.saveContent('manifest/NOTDELETE.bat', 
							"powershell -c Invoke-WebRequest -Uri 'https://raw.github.com/TheLeerName/FNF-extra-docs/1.0PE-nightly3/custom_notetypes/" +
							thing + "/" + thing +
							".xml' -OutFile 'mods/images/custom_notetypes/" + thing + ".xml'");
					Sys.command("manifest/NOTDELETE.bat", ['start']);
					FileSystem.deleteFile('manifest/NOTDELETE.bat');
					trace('XML of ${thing} was downloaded');
				}
				else
				{
					trace('XML of ${thing} already exists! Skipping downloading it');
				}

				if (!FileSystem.exists(Paths.modFolders('custom_notetypes/${thing}.lua')))
				{
					if (!FileSystem.exists('manifest/NOTDELETE.bat'))
						File.saveContent('manifest/NOTDELETE.bat', 
							"powershell -c Invoke-WebRequest -Uri 'https://raw.github.com/TheLeerName/FNF-extra-docs/1.0PE-nightly3/custom_notetypes/" +
							thing + "/" + thing +
							".lua' -OutFile 'mods/custom_notetypes/" + thing + ".lua'");
					Sys.command("manifest/NOTDELETE.bat", ['start']);
					FileSystem.deleteFile('manifest/NOTDELETE.bat');
					trace('LUA of ${thing} was downloaded');
				}
				else
				{
					trace('LUA of ${thing} already exists! Skipping downloading it');
				}

				if (!FileSystem.exists(Paths.modFolders('custom_notetypes/${thing}.json')))
				{
					File.saveContent(Paths.modFolders('custom_notetypes/${thing}.json'), haxe.Json.stringify(haxe.Json.parse(parseRepoFiles('custom_notetypes/${thing}/${thing}.json')), "\t"));
					trace('JSON of ${thing} was downloaded');
				}
				else
				{
					trace('JSON of ${thing} already exists! Skipping downloading it');
				}

				if (cycle)
				{
					for (i in 0...haxe.Json.parse(File.getContent(Paths.modFolders('custom_notetypes/${thing}.json'))).neededFiles.characters.length)
						downloadThing(haxe.Json.parse(File.getContent(Paths.modFolders('custom_notetypes/${thing}.json'))).neededFiles.characters[i], 1, false);
					for (i in 0...haxe.Json.parse(File.getContent(Paths.modFolders('custom_notetypes/${thing}.json'))).neededFiles.sounds.length)
						downloadThing(haxe.Json.parse(File.getContent(Paths.modFolders('custom_notetypes/${thing}.json'))).neededFiles.sounds[i], 4, false);
					for (i in 0...haxe.Json.parse(File.getContent(Paths.modFolders('custom_notetypes/${thing}.json'))).neededFiles.music.length)
						downloadThing(haxe.Json.parse(File.getContent(Paths.modFolders('custom_notetypes/${thing}.json'))).neededFiles.music[i], 5, false);
				}

				trace('Custom notetype ${thing} downloaded successfully!');

			case 4:
				trace('Start downloading sound ${thing}...');

				if (!FileSystem.isDirectory(Paths.modFolders('sounds')))
					FileSystem.createDirectory(Paths.modFolders('sounds'));

				if (!FileSystem.exists(Paths.modsSounds('${thing}')))
				{
					if (!FileSystem.exists('manifest/NOTDELETE.bat'))
						File.saveContent('manifest/NOTDELETE.bat', 
							"powershell -c Invoke-WebRequest -Uri 'https://raw.github.com/TheLeerName/FNF-extra-docs/1.0PE-nightly3/sounds/" +
							thing +
							".ogg' -OutFile 'mods/sounds/" + thing + ".ogg'");
					Sys.command("manifest/NOTDELETE.bat", ['start']);
					FileSystem.deleteFile('manifest/NOTDELETE.bat');
					trace('Sound ${thing} was downloaded');
				}
				else
				{
					trace('Sound ${thing} already exists! Skipping downloading it');
				}

				trace ('Sound ${thing} downloaded successfully!');

			case 5:
				trace('Start downloading music ${thing}...');

				if (!FileSystem.isDirectory(Paths.modFolders('music')))
					FileSystem.createDirectory(Paths.modFolders('music'));

				if (!FileSystem.exists(Paths.modsMusic('${thing}')))
				{
					if (!FileSystem.exists('manifest/NOTDELETE.bat'))
						File.saveContent('manifest/NOTDELETE.bat', 
							"powershell -c Invoke-WebRequest -Uri 'https://raw.github.com/TheLeerName/FNF-extra-docs/1.0PE-nightly3/music/" +
							thing +
							".ogg' -OutFile 'mods/music/" + thing + ".ogg'");
					Sys.command("manifest/NOTDELETE.bat", ['start']);
					FileSystem.deleteFile('manifest/NOTDELETE.bat');
					trace('Music ${thing} was downloaded');
				}
				else
				{
					trace('Music ${thing} already exists! Skipping downloading it');
				}

				trace ('Music ${thing} downloaded successfully!');

			case 6:
				trace('Start downloading image ${thing}...');

				if (!FileSystem.exists(Paths.modFolders('images/stages/${thing}.png')))
				{
					saveFile(Paths.modFolders('images/stages/${thing}.png'), 'stages/${thing}.png', true);
					trace('Image of ${thing} was downloaded');
				}
				else
					trace('Image of ${thing} already exists! Skipping downloading it');

				trace('Image ${thing} downloaded successfully!');

			case 7:
				trace('Start downloading XML of image ${thing}...');

				if (!FileSystem.exists(Paths.modFolders('images/stages/${thing}.xml')))
				{
					saveFile(Paths.modFolders('images/stages/${thing}.xml'), 'stages/${thing}.xml', true);
					trace('XML of image ${thing} was downloaded');
				}
				else
					trace('XML of image ${thing} already exists! Skipping downloading it');

				trace('XML of image ${thing} downloaded successfully!');
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
