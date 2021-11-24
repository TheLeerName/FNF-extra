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
	inline static public function parseRepoFiles(key:String, user_slash_repo:String = 'TheLeerName/FNF-extra-docs', site_with_https:String = 'https://raw.githubusercontent.com') // here (check 27 line)
	{
		var http = new haxe.Http('${site_with_https}' + (user_slash_repo != '' ? '/${user_slash_repo}' : '') + '/${key}');
		// you can change repository or site easily now in args of function :)
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
			ha1.remove("categoryList.json");
			imagesList[i] = ha1[i].replace('.png', '');
		}
		//trace(ba.length + ' | ' + (imagesList.length - 2));
		//trace(ba);
		//trace(imagesList);

		for (i in 0...imagesList.length - 3)
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

		CoolUtil.loadingCats();

		trace('Checking is over! Enjoy your game :)');
	}

	static public function loadingCats() // i mean categories but not cats, of course
	{
		File.saveContent(Paths.modFolders('images/loading/categoryList.json'), haxe.Json.stringify(haxe.Json.parse(CoolUtil.parseRepoFiles('main/categoryList.json')), "\t"));
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
			return man.notetypes;
		else
		{
			trace('uh oh you using unexpected category! return 0...');
			return 0;
		}
	}
	#end

	static public function deleteThing(thing:String, cat:Int, needLowerCase:Bool = false, cycle:Bool = true)
	{
		var thingLC:String = thing;
		if (needLowerCase)
			thingLC = thing.toLowerCase();
		switch (cat)
		{
			#if MODS_ALLOWED
			case 0:
				trace('Start removing song ${thing}...');

				if (FileSystem.exists(Paths.modsSongs('${thingLC}/Inst')))
				{
					FileSystem.deleteFile(Paths.modsSongs('${thingLC}/Inst'));
					trace('Inst for ${thing} was removed');
				}
				else
				{
					trace('Inst for ${thing} is not exist! Skipping removing it');
				}

				if (FileSystem.exists(Paths.modsSongs('${thingLC}/Voices')))
				{
					FileSystem.deleteFile(Paths.modsSongs('${thingLC}/Voices'));
					trace('Voices for ${thing} was removed');
				}
				else
				{
					trace('Voices for ${thing} is not exist! Skipping removing it');
				}

				if (FileSystem.exists(Paths.modsJson('${thingLC}/songData')))
				{
					for (i in 1...(parseDiffCount(thingLC) + 2))
					{
						if (FileSystem.exists(Paths.modsJson('${thingLC}/${thingLC}-${i}')))
						{
							FileSystem.deleteFile(Paths.modsJson('${thingLC}/${thingLC}-${i}'));
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
					for (i in 1...(parseDiffCount(thingLC, true) + 2))
					{
						if (FileSystem.exists(Paths.modsJson('${thingLC}/${thingLC}-${i}')))
						{
							FileSystem.deleteFile(Paths.modsJson('${thingLC}/${thingLC}-${i}'));
							trace('${i} difficulty of ${thing} was removed');
						}
						else
						{
							trace('${i} difficulty of ${thing} is not exist! Skipping removing it');
						}
					}
				} // alt method to remove difficulties of song

				if (FileSystem.exists(Paths.modsJson('${thingLC}/songData')))
				{
					FileSystem.deleteFile(Paths.modsJson('${thingLC}/songData'));
					trace('File songData of ${thing} was removed');
				}
				else
				{
					trace('File songData of ${thing} is not exist! Skipping removing it');
				}

				if (FileSystem.exists(Paths.modFolders('weeks/${thingLC}.json')))
				{
					FileSystem.deleteFile(Paths.modFolders('weeks/${thingLC}.json'));
					trace('Week file of ${thing} was removed');
				}
				else
				{
					trace('Week file of ${thing} is not exist! Skipping removing it');
				}

				if (FileSystem.isDirectory('mods/data/${thingLC}'))
					CoolUtil.deleteDir('mods/data/${thingLC}');
				else
				{
					trace('Folder data/${thing} is not exist! Skipping removing it');
				}

				if (FileSystem.isDirectory('mods/songs/${thingLC}'))
					CoolUtil.deleteDir('mods/songs/${thingLC}');
				else
				{
					trace('Folder songs/${thing} is not exist! Skipping removing it');
				}
				// folder of song and removing extra files in it

				trace('Song ${thing} removed successfully!');

			case 1:
				trace('Start removing character ${thing}...');

				if (FileSystem.exists(Paths.modsImages('characters/${thingLC}')))
				{
					FileSystem.deleteFile(Paths.modsImages('characters/${thingLC}'));
					trace('PNG of ${thing} was removed');
				}
				else
				{
					trace('PNG of ${thing} is not exist! Skipping removing it');
				}

				if (FileSystem.exists(Paths.modsImages('icons/icon-${thingLC}')))
				{
					FileSystem.deleteFile(Paths.modsImages('icons/icon-${thingLC}'));
					trace('Health icon of ${thing} was removed');
				}
				else
				{
					trace('Health icon of ${thing} is not exist! Skipping removing it');
				}

				if (FileSystem.exists(Paths.modsXml('characters/${thingLC}')))
				{
					FileSystem.deleteFile(Paths.modsXml('characters/${thingLC}'));
					trace('XML of ${thing} was removed');
				}
				else
				{
					trace('XML of ${thing} is not exist! Skipping removing it');
				}

				if (FileSystem.exists(Paths.modFolders('characters/${thingLC}.json')))
				{
					FileSystem.deleteFile(Paths.modFolders('characters/${thingLC}.json'));
					trace('JSON of ${thing} was removed');
				}
				else
				{
					trace('JSON of ${thing} is not exist! Skipping removing it');
				}

				trace('Character ${thing} removed successfully!');
			case 2:
				trace('Start removing custom notetype ${thing}...');

				if (FileSystem.exists('mods/custom_notetypes/${thingLC}.lua'))
				{
					FileSystem.deleteFile('mods/custom_notetypes/${thingLC}.lua');
					trace('Lua of ${thing} was removed');
				}
				else
				{
					trace('Lua of ${thing} is not exist! Skipping removing it');
				}

				if (FileSystem.exists('mods/images/custom_notetypes/${thingLC}.xml'))
				{
					FileSystem.deleteFile('mods/images/custom_notetypes/${thingLC}.xml');
					trace('XML of ${thing} was removed');
				}
				else
				{
					trace('XML of ${thing} is not exist! Skipping removing it');
				}

				if (FileSystem.exists(Paths.modsImages('custom_notetypes/${thingLC}')))
				{
					FileSystem.deleteFile(Paths.modsImages('custom_notetypes/${thingLC}'));
					trace('PNG of ${thing} was removed');
				}
				else
				{
					trace('PNG of ${thing} is not exist! Skipping removing it');
				}

				if (!FileSystem.exists('mods/custom_notetypes/${thingLC}.json'))
				{
					File.saveContent(Paths.modFolders('custom_notetypes/${thingLC}.json'), haxe.Json.stringify(haxe.Json.parse(CoolUtil.parseRepoFiles('main/custom_notetypes/${thingLC}.json')), "\t"));
					trace('JSON of ${thing} was downloaded');
				}

				if (cycle)
				{
					for (i in 0...haxe.Json.parse(File.getContent(Paths.modFolders('custom_notetypes/${thingLC}.json'))).neededFiles.characters.length)
						deleteThing(haxe.Json.parse(File.getContent(Paths.modFolders('custom_notetypes/${thingLC}.json'))).neededFiles.characters[i], 1, false, false);
					for (i in 0...haxe.Json.parse(File.getContent(Paths.modFolders('custom_notetypes/${thingLC}.json'))).neededFiles.sounds.length)
						deleteThing(haxe.Json.parse(File.getContent(Paths.modFolders('custom_notetypes/${thingLC}.json'))).neededFiles.sounds[i], 3, false, false);
					for (i in 0...haxe.Json.parse(File.getContent(Paths.modFolders('custom_notetypes/${thingLC}.json'))).neededFiles.music.length)
						deleteThing(haxe.Json.parse(File.getContent(Paths.modFolders('custom_notetypes/${thingLC}.json'))).neededFiles.music[i], 4, false, false);
				}

				if (FileSystem.exists('mods/custom_notetypes/${thingLC}.json'))
				{
					FileSystem.deleteFile('mods/custom_notetypes/${thingLC}.json');
					trace('JSON of ${thing} was removed');
				}
				else
				{
					trace('JSON of ${thing} is not exist! Skipping removing it');
				}

				trace('Custom notetype ${thing} removed successfully!');
			case 3:
				trace('Start removing sound ${thing}...');

				if (FileSystem.exists('mods/sounds/${thingLC}.ogg'))
				{
					FileSystem.deleteFile('mods/sounds/${thingLC}.ogg');
					trace('Sound ${thing} was removed');
				}
				else
				{
					trace('Sound ${thing} is not exist! Skipping removing it');
				}

				trace('Sound ${thing} removed successfully!');
			case 4:
				trace('Start removing music ${thing}...');

				if (FileSystem.exists('mods/music/${thingLC}.ogg'))
				{
					FileSystem.deleteFile('mods/music/${thingLC}.ogg');
					trace('Music ${thing} was removed');
				}
				else
				{
					trace('Music ${thing} is not exist! Skipping removing it');
				}

				trace('Music ${thing} removed successfully!');
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

	static public function downloadThing(thing:String, cat:Int, needLowerCase:Bool = false, cycle:Bool = true)
	{
		var thingLC:String = thing;
		if (needLowerCase)
			thingLC = thing.toLowerCase();
		switch (cat)
		{
			#if MODS_ALLOWED
			case 0:
				trace('Start downloading song ${thing}...');

				if (!FileSystem.isDirectory(Paths.modFolders('songs/${thingLC}')))
					FileSystem.createDirectory(Paths.modFolders('songs/${thingLC}'));
				if (!FileSystem.isDirectory(Paths.modFolders('data/${thingLC}')))
					FileSystem.createDirectory(Paths.modFolders('data/${thingLC}'));

				for (i in 1...(CoolUtil.parseDiffCount(thingLC, true) + 2))
				{
					if (!FileSystem.exists(Paths.modsJson('${thingLC}/${thingLC}-${i}')))
					{
						File.saveContent(Paths.modsJson('${thingLC}/${thingLC}-${i}'), haxe.Json.stringify(haxe.Json.parse(CoolUtil.parseRepoFiles('main/data/${thingLC}/${thingLC}-${i}.json')), "\t"));
						trace('${i} difficulty of ${thing} was downloaded');
					}
					else
					{
						trace('${i} difficulty of ${thing} already exists! Skipping downloading it');
					}
				}

				if (!FileSystem.exists(Paths.modsSongs('${thingLC}/Inst')))
				{
					if (!FileSystem.exists('manifest/NOTDELETE.bat'))
						File.saveContent('manifest/NOTDELETE.bat', 
							"powershell -c Invoke-WebRequest -Uri 'https://raw.github.com/TheLeerName/FNF-extra-docs/main/songs/" +
							thingLC +
							"/Inst.ogg' -OutFile 'mods/songs/" + thingLC + "/Inst.ogg'");
					Sys.command("manifest/NOTDELETE.bat", ['start']);
					FileSystem.deleteFile('manifest/NOTDELETE.bat');
					trace('Inst for ${thing} was downloaded');
				}
				else
				{
					trace('Inst for ${thing} already exists! Skipping downloading it');
				}

				if (haxe.Json.parse(File.getContent(Paths.modsJson('${thingLC}/${thingLC}-1'))).song.needsVoices)
				{
					if (!FileSystem.exists(Paths.modsSongs('${thingLC}/Voices')))
					{
						if (!FileSystem.exists('manifest/NOTDELETE.bat'))
							File.saveContent('manifest/NOTDELETE.bat', 
								"powershell -c Invoke-WebRequest -Uri 'https://raw.github.com/TheLeerName/FNF-extra-docs/main/songs/" +
								thingLC +
								"/Voices.ogg' -OutFile 'mods/songs/" + thingLC + "/Voices.ogg'");
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
	
				if (!FileSystem.exists(Paths.modsJson('${thingLC}/songData')))
				{
					File.saveContent(Paths.modsJson('${thingLC}/songData'), haxe.Json.stringify(haxe.Json.parse(CoolUtil.parseRepoFiles('main/data/${thingLC}/songData.json')), "\t"));
					trace('File songData of ${thing} was downloaded');
				}
				else
				{
					trace('File songData of ${thing} already exists! Skipping downloading it');
				}
	
				if (!FileSystem.exists(Paths.modFolders('weeks/${thingLC}.json')))
				{
					File.saveContent(Paths.modFolders('weeks/${thingLC}.json'), haxe.Json.stringify(haxe.Json.parse(CoolUtil.parseRepoFiles('main/weeks/${thingLC}.json')), "\t"));
					trace('Week file of ${thing} was downloaded');
				}
				else
				{
					trace('Week file of ${thing} already exists! Skipping downloading it');
				}
	
				trace('Song ${thing} downloaded successfully!');
	
			case 1:
				trace('Start downloading character ${thing}...');

				if (!FileSystem.exists(Paths.modFolders('characters/${thingLC}.json')))
				{
					File.saveContent(Paths.modFolders('characters/${thingLC}.json'), haxe.Json.stringify(haxe.Json.parse(CoolUtil.parseRepoFiles('main/characters/${thingLC}.json')), "\t"));
					trace('JSON of ${thing} was downloaded');
				}
				else
				{
					trace('JSON of ${thing} already exists! Skipping downloading it');
				}

				if (!FileSystem.exists(Paths.modsImages('characters/${thingLC}')))
				{
					if (!FileSystem.exists('manifest/NOTDELETE.bat'))
						File.saveContent('manifest/NOTDELETE.bat', 
							"powershell -c Invoke-WebRequest -Uri 'https://raw.github.com/TheLeerName/FNF-extra-docs/main/characters/" +
							thingLC +
							".png' -OutFile 'mods/images/characters/" + thingLC + ".png'");
					Sys.command("manifest/NOTDELETE.bat", ['start']);
					FileSystem.deleteFile('manifest/NOTDELETE.bat');
					trace('PNG of ${thingLC} was downloaded');
				}
				else
				{
					trace('PNG of ${thingLC} already exists! Skipping downloading it');
				}

				switch (haxe.Json.parse(File.getContent(Paths.modFolders('characters/${thingLC}.json'))).healthicon)
				{
					case 'bf' | 'dad' | 'gf' | 'pico' | 'pico-player':
						trace('Health icon of ${thing} not needed! Skipping downloading it');
					default:
						if (!FileSystem.exists(Paths.modsImages('icons/${thingLC}')))
						{
							if (!FileSystem.exists('manifest/NOTDELETE.bat'))
								File.saveContent('manifest/NOTDELETE.bat', 
									"powershell -c Invoke-WebRequest -Uri 'https://raw.github.com/TheLeerName/FNF-extra-docs/main/icons/icon-" +
									thingLC +
									".png' -OutFile 'mods/images/icons/icon-" + thingLC + ".png'");
							Sys.command("manifest/NOTDELETE.bat", ['start']);
							FileSystem.deleteFile('manifest/NOTDELETE.bat');
							trace('Health icon of ${thing} was downloaded');
						}
						else
						{
							trace('Health icon of ${thing} already exists! Skipping downloading it');
						}
				}

				if (!FileSystem.exists(Paths.modsXml('characters/${thingLC}')))
				{
					if (!FileSystem.exists('manifest/NOTDELETE.bat'))
						File.saveContent('manifest/NOTDELETE.bat', 
							"powershell -c Invoke-WebRequest -Uri 'https://raw.github.com/TheLeerName/FNF-extra-docs/main/characters/" +
							thingLC +
							".xml' -OutFile 'mods/images/characters/" + thingLC + ".xml'");
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
				trace('Start downloading custom notetype ${thing}...');

				if (!FileSystem.exists(Paths.modsImages('custom_notetypes/${thingLC}')))
				{
					if (!FileSystem.exists('manifest/NOTDELETE.bat'))
						File.saveContent('manifest/NOTDELETE.bat', 
							"powershell -c Invoke-WebRequest -Uri 'https://raw.github.com/TheLeerName/FNF-extra-docs/main/custom_notetypes/" +
							thingLC +
							".png' -OutFile 'mods/images/custom_notetypes/" + thingLC + ".png'");
					Sys.command("manifest/NOTDELETE.bat", ['start']);
					FileSystem.deleteFile('manifest/NOTDELETE.bat');
					trace('PNG of ${thingLC} was downloaded');
				}
				else
				{
					trace('PNG of ${thing} already exists! Skipping downloading it');
				}
	
				if (!FileSystem.exists(Paths.modFolders('images/custom_notetypes/${thingLC}')))
				{
					if (!FileSystem.exists('manifest/NOTDELETE.bat'))
						File.saveContent('manifest/NOTDELETE.bat', 
							"powershell -c Invoke-WebRequest -Uri 'https://raw.github.com/TheLeerName/FNF-extra-docs/main/custom_notetypes/" +
							thingLC +
							".xml' -OutFile 'mods/images/custom_notetypes/" + thingLC + ".xml'");
					Sys.command("manifest/NOTDELETE.bat", ['start']);
					FileSystem.deleteFile('manifest/NOTDELETE.bat');
					trace('XML of ${thing} was downloaded');
				}
				else
				{
					trace('XML of ${thing} already exists! Skipping downloading it');
				}

				if (!FileSystem.exists(Paths.modFolders('custom_notetypes/${thingLC}.lua')))
				{
					if (!FileSystem.exists('manifest/NOTDELETE.bat'))
						File.saveContent('manifest/NOTDELETE.bat', 
							"powershell -c Invoke-WebRequest -Uri 'https://raw.github.com/TheLeerName/FNF-extra-docs/main/custom_notetypes/" +
							thingLC +
							".lua' -OutFile 'mods/custom_notetypes/" + thingLC + ".lua'");
					Sys.command("manifest/NOTDELETE.bat", ['start']);
					FileSystem.deleteFile('manifest/NOTDELETE.bat');
					trace('LUA of ${thing} was downloaded');
				}
				else
				{
					trace('LUA of ${thing} already exists! Skipping downloading it');
				}

				if (!FileSystem.exists(Paths.modFolders('custom_notetypes/${thingLC}.json')))
				{
					File.saveContent(Paths.modFolders('custom_notetypes/${thingLC}.json'), haxe.Json.stringify(haxe.Json.parse(CoolUtil.parseRepoFiles('main/custom_notetypes/${thingLC}.json')), "\t"));
					trace('JSON of ${thing} was downloaded');
				}
				else
				{
					trace('JSON of ${thing} already exists! Skipping downloading it');
				}

				if (cycle)
				{
					for (i in 0...haxe.Json.parse(File.getContent(Paths.modFolders('custom_notetypes/${thingLC}.json'))).neededFiles.characters.length)
						downloadThing(haxe.Json.parse(File.getContent(Paths.modFolders('custom_notetypes/${thingLC}.json'))).neededFiles.characters[i], 1, false, false);
					for (i in 0...haxe.Json.parse(File.getContent(Paths.modFolders('custom_notetypes/${thingLC}.json'))).neededFiles.sounds.length)
						downloadThing(haxe.Json.parse(File.getContent(Paths.modFolders('custom_notetypes/${thingLC}.json'))).neededFiles.sounds[i], 3, false, false);
					for (i in 0...haxe.Json.parse(File.getContent(Paths.modFolders('custom_notetypes/${thingLC}.json'))).neededFiles.music.length)
						downloadThing(haxe.Json.parse(File.getContent(Paths.modFolders('custom_notetypes/${thingLC}.json'))).neededFiles.music[i], 4, false, false);
				}

				trace('Custom notetype ${thing} downloaded successfully!');

			case 3:
				trace('Start downloading sound ${thing}...');

				if (!FileSystem.isDirectory(Paths.modFolders('sounds')))
					FileSystem.createDirectory(Paths.modFolders('sounds'));

				if (!FileSystem.exists(Paths.modsSounds('${thingLC}')))
				{
					if (!FileSystem.exists('manifest/NOTDELETE.bat'))
						File.saveContent('manifest/NOTDELETE.bat', 
							"powershell -c Invoke-WebRequest -Uri 'https://raw.github.com/TheLeerName/FNF-extra-docs/main/sounds/" +
							thingLC +
							".ogg' -OutFile 'mods/sounds/" + thingLC + ".ogg'");
					Sys.command("manifest/NOTDELETE.bat", ['start']);
					FileSystem.deleteFile('manifest/NOTDELETE.bat');
					trace('Sound ${thing} was downloaded');
				}
				else
				{
					trace('Sound ${thing} already exists! Skipping downloading it');
				}

				trace ('Sound ${thing} downloaded successfully!');
			case 4:
				trace('Start downloading music ${thing}...');

				if (!FileSystem.isDirectory(Paths.modFolders('music')))
					FileSystem.createDirectory(Paths.modFolders('music'));

				if (!FileSystem.exists(Paths.modsMusic('${thingLC}')))
				{
					if (!FileSystem.exists('manifest/NOTDELETE.bat'))
						File.saveContent('manifest/NOTDELETE.bat', 
							"powershell -c Invoke-WebRequest -Uri 'https://raw.github.com/TheLeerName/FNF-extra-docs/main/music/" +
							thingLC +
							".ogg' -OutFile 'mods/music/" + thingLC + ".ogg'");
					Sys.command("manifest/NOTDELETE.bat", ['start']);
					FileSystem.deleteFile('manifest/NOTDELETE.bat');
					trace('Music ${thing} was downloaded');
				}
				else
				{
					trace('Music ${thing} already exists! Skipping downloading it');
				}

				trace ('Music ${thing} downloaded successfully!');
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
