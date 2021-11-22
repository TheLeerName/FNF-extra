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
	//var man:Bool = true;
	var delete:Bool;
	var infoText:FlxText;
	var text:FlxText;

	var menuItems:Array<String>;
	var songs:Array<String>;
	var characters:Array<String>;
	var curCat:Int = 0;
	var curSelected:Int = 0;

	public function new()
	{
		super();

		var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menuBGBlue'));
		bg.antialiasing = ClientPrefs.globalAntialiasing;
		add(bg);

		grpMenuShit = new FlxTypedGroup<Alphabet>();
		add(grpMenuShit);

		songs = CoolUtil.parseRepoFiles('main/songList.txt').split('\n');
		characters = CoolUtil.parseRepoFiles('main/characterList.txt').split('\n');
		menuItems = songs;
		trace('MenuItems: ${menuItems} == Songs: ${songs} | Characters: ${characters}');
		for (i in 0...menuItems.length) {
			var item = new Alphabet(0, 70 * i + 30, menuItems[i], true, false);
			item.isMenuItem = true;
			item.targetY = i;
			grpMenuShit.add(item);
		}

		var textBG:FlxSprite = new FlxSprite(0, FlxG.height - 46).makeGraphic(FlxG.width, 46, 0xFF000000);
		textBG.alpha = 0.6;
		add(textBG);
		#if MODS_ALLOWED
		delete = (FileSystem.isDirectory(Paths.modFolders('songs/${menuItems[curSelected]}')) || FileSystem.isDirectory(Paths.modFolders('data/${menuItems[curSelected]}')) ? true : false);
		infoText = new FlxText(textBG.x, textBG.y + 4, FlxG.width, (delete ? 'Press DELETE to delete' : 'Press ACCEPT to download') + ' / Press RESET to update list', 18);
		#else
		delete = false;
		infoText = new FlxText(textBG.x, textBG.y + 4, FlxG.width, 'Press ACCEPT to download / Press RESET to update list', 18);
		#end
		infoText.setFormat(Paths.font("vcr.ttf"), 18, FlxColor.WHITE, RIGHT);
		infoText.scrollFactor.set();
		add(infoText);
		text = new FlxText(textBG.x, textBG.y + 25, FlxG.width, 'Press TAB or BACK to close this menu / Press LEFT or RIGHT to switch list (now songs)', 18);
		text.setFormat(Paths.font("vcr.ttf"), 18, FlxColor.WHITE, RIGHT);
		text.scrollFactor.set();
		add(text);

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

		if (FlxG.keys.justPressed.DELETE && delete) 
		{
			funnyText.text = 'Deleting a ' + (curCat == 0 ? 'song' : 'character') + ' ${menuItems[curSelected]}...\nWhile you wait, look at this funny picture lol!';
			FlxTween.tween(black, {alpha: 1}, 1, {ease: FlxEase.quartInOut, onComplete: function(twn:FlxTween){CoolUtil.deleteThing(menuItems[curSelected], curCat);}});
			FlxTween.tween(funnyText, {alpha: 1}, 1, {ease: FlxEase.quartInOut});
			FlxTween.tween(funnyPic, {alpha: 1}, 1, {ease: FlxEase.quartInOut});
		}
		if (controls.BACK || FlxG.keys.justPressed.TAB) close();

		if (controls.UI_UP_P) changeSelection(-1);
		if (controls.UI_DOWN_P) changeSelection(1);
		if (controls.UI_LEFT_P) changeCat(-1);
		if (controls.UI_RIGHT_P) changeCat(1);

		/*if (FlxG.keys.justPressed.G) // for tests
		{
			man = !man;
			funnyText.text = 'Downloading a song ${menuItems[curSelected]}, game will be freezed...\nWhile you wait, look at this funny picture lol!';
			FlxTween.tween(black, {alpha: (man?1:0)}, 1, {ease: FlxEase.quartInOut});
			FlxTween.tween(funnyText, {alpha: (man?1:0)}, 1, {ease: FlxEase.quartInOut});
			FlxTween.tween(funnyPic, {alpha: (man?1:0)}, 1, {ease: FlxEase.quartInOut});
		}*/

		if (controls.RESET) changeCat(true);

		if (controls.ACCEPT && !delete)
		{
			funnyText.text = 'Downloading a ' + (curCat == 0 ? 'song' : 'character') + ' ${menuItems[curSelected]}, game will be freezed...\nWhile you wait, look at this funny picture lol!';
			FlxTween.tween(black, {alpha: 1}, 1, {ease: FlxEase.quartInOut, onComplete: function(twn:FlxTween){CoolUtil.downloadThing(menuItems[curSelected], curCat);}});
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

		switch (curCat)
		{
			case 0:
				#if MODS_ALLOWED
				delete = (FileSystem.isDirectory(Paths.modFolders('songs/${menuItems[curSelected]}')) || FileSystem.isDirectory(Paths.modFolders('data/${menuItems[curSelected]}')) ? true : false);
				infoText.text = (delete ? 'Press DELETE to delete' : 'Press ACCEPT to download') + ' / Press RESET to update list';
				#else
				delete = false;
				#end
			case 1:
				#if MODS_ALLOWED
				delete = (
					FileSystem.exists(Paths.modsImages('characters/${menuItems[curSelected]}')) ||
					FileSystem.exists(Paths.modsImages('icons/${menuItems[curSelected]}')) ||
					FileSystem.exists(Paths.modsXml('characters/${menuItems[curSelected]}')) ||
					FileSystem.exists(Paths.modFolders('characters/${menuItems[curSelected]}.json'))
					? true : false);
				infoText.text = (delete ? 'Press DELETE to delete' : 'Press ACCEPT to download') + ' / Press RESET to update list';
				#else
				delete = false;
				#end
		}
		#if !MODS_ALLOWED
		infoText.text = 'Press ACCEPT to download / Press RESET to update list';
		#end

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

	function changeCat(change:Int = 0, needUpdate:Bool = false):Void
	{
		curCat += change;
		if (curCat < 0)
			curCat = 1;
		if (curCat > 1)
			curCat = 0;

		switch (curCat)
		{
			case 0:
				if (needUpdate)
					songs = CoolUtil.parseRepoFiles('main/songList.txt').split('\n');
				menuItems = songs;
				#if MODS_ALLOWED
				delete = (FileSystem.isDirectory(Paths.modFolders('songs/${menuItems[curSelected]}')) || FileSystem.isDirectory(Paths.modFolders('data/${menuItems[curSelected]}')) ? true : false);
				infoText.text = (delete ? 'Press DELETE to delete' : 'Press ACCEPT to download') + ' / Press RESET to update list';
				#else
				delete = false;
				#end
				text.text = 'Press TAB or BACK to close this menu / Press LEFT or RIGHT to switch list (now songs)';
				trace('MenuItems: ${menuItems} == Songs: ${songs} | Characters: ${characters}');
			case 1:
				if (needUpdate)
					characters = CoolUtil.parseRepoFiles('main/characterList.txt').split('\n');
				menuItems = characters;
				#if MODS_ALLOWED
				delete = (
					FileSystem.exists(Paths.modsImages('characters/${menuItems[curSelected]}')) ||
					FileSystem.exists(Paths.modsImages('icons/${menuItems[curSelected]}')) ||
					FileSystem.exists(Paths.modsXml('characters/${menuItems[curSelected]}')) ||
					FileSystem.exists(Paths.modFolders('characters/${menuItems[curSelected]}.json'))
					? true : false);
				infoText.text = (delete ? 'Press DELETE to delete' : 'Press ACCEPT to download') + ' / Press RESET to update list';
				#else
				delete = false;
				#end
				text.text = 'Press TAB or BACK to close this menu / Press LEFT or RIGHT to switch list (now characters)';
				trace('MenuItems: ${menuItems} == Characters: ${characters} | Songs: ${songs}');
		}
		#if !MODS_ALLOWED
		infoText.text = 'Press ACCEPT to download / Press RESET to update list';
		#end

		for (i in 0...grpMenuShit.members.length) {
			this.grpMenuShit.remove(this.grpMenuShit.members[0], true);
		}
		for (i in 0...menuItems.length) {
			var item = new Alphabet(0, 70 * i + 30, menuItems[i], true, false);
			item.isMenuItem = true;
			item.targetY = i;
			grpMenuShit.add(item);
		}
		curSelected = 0;
		changeSelection();
	}
}
