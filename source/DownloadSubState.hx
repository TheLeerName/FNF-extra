package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
#if MODS_ALLOWED
import sys.io.File;
import sys.FileSystem;
#end

class DownloadSubState extends MusicBeatSubstate
{
	var grpMenuShit:FlxTypedGroup<Alphabet>;
	var black:FlxSprite;
	var funnyText:FlxText;
	var funnyPic:FlxSprite;
	var man:Bool = true;

	var menuItems:Array<String>;
	var curSelected:Int = 0;

	public function new()
	{
		super();

		var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menuBGBlue'));
		bg.antialiasing = ClientPrefs.globalAntialiasing;
		add(bg);

		grpMenuShit = new FlxTypedGroup<Alphabet>();
		add(grpMenuShit);

		menuItems = CoolUtil.parseRepoFiles('main/songList.txt').split('\n');
		trace(menuItems);
		for (i in 0...menuItems.length)
		{
			var songText:Alphabet = new Alphabet(0, (70 * i) + 30, menuItems[i], true, false);
			songText.isMenuItem = true;
			songText.targetY = i;
			grpMenuShit.add(songText);
		}

		var textBG:FlxSprite = new FlxSprite(0, FlxG.height - 26).makeGraphic(FlxG.width, 26, 0xFF000000);
		textBG.alpha = 0.6;
		add(textBG);
		var infoText:FlxText = new FlxText(textBG.x, textBG.y + 4, FlxG.width, 'Press ACCEPT to download this song / Press RESET to update song list.', 18);
		infoText.setFormat(Paths.font("vcr.ttf"), 18, FlxColor.WHITE, RIGHT);
		infoText.scrollFactor.set();
		add(infoText);

		black = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		black.alpha = 0;
		add(black);

		funnyPic = new FlxSprite().loadGraphic(Paths.image('funnycat', 'shared'));
		funnyPic.screenCenter();
		funnyPic.width = 720;
		funnyPic.height = 405;
		funnyPic.y += 125;
		funnyPic.alpha = 0;
		add(funnyPic);

		funnyText = new FlxText(0, FlxG.height * 0.25, FlxG.width, 'joe biden', 30);
		funnyText.setFormat(Paths.font("vcr.ttf"), 30, FlxColor.WHITE, CENTER, FlxColor.BLACK);
		funnyText.alpha = 0;
		add(funnyText);

		changeSelection();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (controls.BACK) close();

		if (controls.UI_UP_P) changeSelection(-1);
		if (controls.UI_DOWN_P) changeSelection(1);

		/*if (FlxG.keys.justPressed.G) // for tests
		{
			man = !man;
			funnyText.text = 'Downloading a song ${menuItems[curSelected]}, game will be freezed...\nWhile you wait, look at this funny picture lol!'; // update
			FlxTween.tween(black, {alpha: (man?1:0)}, 1, {ease: FlxEase.quartInOut});
			FlxTween.tween(funnyText, {alpha: (man?1:0)}, 1, {ease: FlxEase.quartInOut});
			FlxTween.tween(funnyPic, {alpha: (man?1:0)}, 1, {ease: FlxEase.quartInOut});
		}*/

		if (controls.RESET)
		{
			new DownloadSubState();
		}

		if (controls.ACCEPT)
		{
			funnyText.text = 'Downloading a song ${menuItems[curSelected]}, game will be freezed...\nWhile you wait, look at this funny picture lol!'; // update
			FlxTween.tween(black, {alpha: 1}, 1, {ease: FlxEase.quartInOut,
			onComplete: function(twn:FlxTween){
				//CoolUtil.downloadSong(menuItems[curSelected]);
				#if MODS_ALLOWED
				//text('Start downloading song ${menuItems[curSelected]}...', 1);

				//trace('Creating folders of ${menuItems[curSelected]}');

				if (!FileSystem.isDirectory(Paths.modFolders('songs/${menuItems[curSelected]}')))
					FileSystem.createDirectory(Paths.modFolders('songs/${menuItems[curSelected]}')); // folder of song
				if (!FileSystem.isDirectory(Paths.modFolders('data/${menuItems[curSelected]}')))
					FileSystem.createDirectory(Paths.modFolders('data/${menuItems[curSelected]}')); // folder of song jsons

				//trace('Starting download Inst for ${menuItems[curSelected]}...');

				if (!FileSystem.exists(Paths.modsSongs('${menuItems[curSelected]}/Inst')))
				{
					if (!FileSystem.exists('manifest/NOTDELETE.bat'))
						File.saveContent('manifest/NOTDELETE.bat', 
						"powershell -c Invoke-WebRequest -Uri 'https://raw.github.com/TheLeerName/FNF-extra-docs/main/songs/" +
						menuItems[curSelected] +
						"/Inst.ogg' -OutFile 'mods/songs/" + menuItems[curSelected] + "/Inst.ogg'");
					Sys.command("manifest/NOTDELETE.bat", ['start /B']);
					FileSystem.deleteFile('manifest/NOTDELETE.bat');
					trace('Inst for ${menuItems[curSelected]} was downloaded');
				}
				else
				{
					trace('Inst for ${menuItems[curSelected]} already exists! Skipping downloading it');
				} // Inst for song

				//trace('Starting download Voices for ${menuItems[curSelected]}...');

				if (menuItems[curSelected] != 'atomosphere' && !FileSystem.exists(Paths.modsSongs('${menuItems[curSelected]}/Voices')))
				{
					if (!FileSystem.exists('manifest/NOTDELETE.bat'))
						File.saveContent('manifest/NOTDELETE.bat', 
						"powershell -c Invoke-WebRequest -Uri 'https://raw.github.com/TheLeerName/FNF-extra-docs/main/songs/" +
						menuItems[curSelected] +
						"/Voices.ogg' -OutFile 'mods/songs/" + menuItems[curSelected] + "/Voices.ogg'");
					Sys.command("manifest/NOTDELETE.bat", ['start /B']);
					FileSystem.deleteFile('manifest/NOTDELETE.bat');
					trace('Voices for ${menuItems[curSelected]} was downloaded');
				}
				else if (menuItems[curSelected] == 'atomosphere')
				{
					trace('Voices for ${menuItems[curSelected]} not needed! Skipping downloading it');
				}
				else
				{
					trace('Voices for ${menuItems[curSelected]} already exists! Skipping downloading it');
				} // Voices for song

				//trace('Starting download difficulties of ${menuItems[curSelected]}...');

				for (i in 1...(CoolUtil.parseDiffCount(menuItems[curSelected], true) + 2))
				{
					if (!FileSystem.exists(Paths.modsJson('${menuItems[curSelected]}/${menuItems[curSelected]}-${i}')))
					{
						File.saveContent(Paths.modsJson('${menuItems[curSelected]}/${menuItems[curSelected]}-${i}'), haxe.Json.stringify(haxe.Json.parse(CoolUtil.parseRepoFiles('main/data/${menuItems[curSelected]}/${menuItems[curSelected]}-${i}.json')), "\t"));
						trace('${i} difficulty of ${menuItems[curSelected]} was downloaded');
					}
					else
					{
					trace('${i} difficulty of ${menuItems[curSelected]} already exists! Skipping downloading it');
					}	
				} // difficulties of song

				//trace('Starting download songData of ${menuItems[curSelected]}...');

				if (!FileSystem.exists(Paths.modsJson('${menuItems[curSelected]}/songData')))
				{
					File.saveContent(Paths.modsJson('${menuItems[curSelected]}/songData'), haxe.Json.stringify(haxe.Json.parse(CoolUtil.parseRepoFiles('main/data/${menuItems[curSelected]}/songData.json')), "\t"));
					trace('File songData of ${menuItems[curSelected]} was downloaded');
				}
				else
				{
					trace('File songData of ${menuItems[curSelected]} already exists! Skipping downloading it');
				} // songData of song

				//trace('Starting download week file of ${menuItems[curSelected]}...');

				if (!FileSystem.exists(Paths.modFolders('weeks/${menuItems[curSelected]}.json')))
				{
					File.saveContent(Paths.modFolders('weeks/${menuItems[curSelected]}.json'), haxe.Json.stringify(haxe.Json.parse(CoolUtil.parseRepoFiles('main/weeks/${menuItems[curSelected]}.json')), "\t"));
					trace('Week file of ${menuItems[curSelected]} was downloaded');
				}
				else
				{
					trace('Week file of ${menuItems[curSelected]} already exists! Skipping downloading it');
				} // week file of song

				trace('Song ${menuItems[curSelected]} downloaded successfully!');
				MusicBeatState.resetState();
				#else
				trace('Not working when MODS_ALLOWED is false!');
				#end
				//close();
			}});
			FlxTween.tween(funnyText, {alpha: 1}, 1, {ease: FlxEase.quartInOut});
			FlxTween.tween(funnyPic, {alpha: 1}, 1, {ease: FlxEase.quartInOut});
		}
	}

	function changeSelection(change:Int = 0):Void
	{
		curSelected += change;

		FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);

		if (curSelected < 0)
			curSelected = menuItems.length - 1;
		if (curSelected >= menuItems.length)
			curSelected = 0;

		var bullShit:Int = 0;

		for (item in grpMenuShit.members)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;

			item.alpha = 0.6;

			if (item.targetY == 0)
			{
				item.alpha = 1;
			}
		}
	}
}
