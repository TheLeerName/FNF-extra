#if MODS_ALLOWED
package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import sys.io.File;
import sys.FileSystem;

class DownloadSubState extends MusicBeatSubstate
{
	var grpMenuShit:FlxTypedGroup<Alphabet>;
	var menuItems:Array<String>;
	var cats:Array<Dynamic>;
	var curCat:Int = 0;
	var curSelected:Int = 0;
	var curChart:Int = 0;

	var delete:Bool = false;
	var infoText2:FlxText;
	var infoText:FlxText;
	var text:FlxText;
	var black:FlxSprite;
	var funnyPic:FlxSprite;
	var funnyText:FlxText;
	//var man:Bool = true;

	public function new()
	{
		super();

		if (FlxG.save.data.curChart != null)
			curChart = FlxG.save.data.curChart;
		else
			FlxG.save.data.curChart = curChart;

		var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menuBGBlue'));
		bg.antialiasing = ClientPrefs.globalAntialiasing;
		add(bg);

		grpMenuShit = new FlxTypedGroup<Alphabet>();
		add(grpMenuShit);

		cats = [ // "things in categories", "name"
		[CoolUtil.getCats(0), 'Song'],
		[CoolUtil.getCats(1), 'Character'],
		[CoolUtil.getCats(2), 'Stage'],
		[CoolUtil.getCats(3), 'NoteType']
		];
		menuItems = cats[curCat][0];
		//trace('MenuItems: ${menuItems} || ${cats[0][1]}s: ${cats[0][0]} | ${cats[1][1]}s: ${cats[1][0]} | ${cats[2][1]}s: ${cats[2][0]} | ${cats[3][1]}s: ${cats[3][0]}');
		for (i in 0...menuItems.length) {
			var item = new Alphabet(0, 70 * i + 30, menuItems[i], true, false);
			item.isMenuItem = true;
			item.targetY = i;
			grpMenuShit.add(item);
		}

		var textBG:FlxSprite = new FlxSprite(0, FlxG.height - 70).makeGraphic(FlxG.width, 70, 0xFF000000);
		textBG.alpha = 0.6;
		add(textBG);
		delete = (FileSystem.isDirectory(Paths.modFolders('songs/${menuItems[curSelected]}')) || FileSystem.isDirectory(Paths.modFolders('data/${menuItems[curSelected]}')) ? true : false);
		infoText2 = new FlxText(textBG.x, textBG.y + 4, FlxG.width, 'Press CTRL to switch type of chart (now ${(curChart == 0 ? 'all' : (curChart == 1 ? 'without characters' : (curChart == 2 ? 'without stages' : 'without notetypes')))})', 18);
		infoText2.setFormat(Paths.font("vcr.ttf"), 18, FlxColor.WHITE, RIGHT);
		infoText2.scrollFactor.set();
		add(infoText2);
		infoText = new FlxText(textBG.x, textBG.y + 25, FlxG.width, (delete ? 'Press DELETE to delete (hold ALT to delete all)' : 'Press ACCEPT to download') + ' / Press RESET to update list', 18);
		infoText.setFormat(Paths.font("vcr.ttf"), 18, FlxColor.WHITE, RIGHT);
		infoText.scrollFactor.set();
		add(infoText);
		text = new FlxText(textBG.x, textBG.y + 46, FlxG.width, 'Press TAB or BACK to close this menu / Press LEFT or RIGHT to switch list (now ${cats[curCat][1]}s)', 18);
		text.setFormat(Paths.font("vcr.ttf"), 18, FlxColor.WHITE, RIGHT);
		text.scrollFactor.set();
		add(text);

		black = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		black.alpha = 0;
		add(black);

		funnyPic = new FlxSprite().loadGraphic(Paths.image('loading/${File.getContent(Paths.modsTxt('loading/imageNames')).split('\n')[Std.int(Std.random(File.getContent(Paths.modsTxt('loading/imageNames')).split('\n').length))]}'));
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

		if (controls.BACK || FlxG.keys.justPressed.TAB) close();

		if (controls.UI_UP_P) changeSelection(-1);
		if (controls.UI_DOWN_P) changeSelection(1);
		if (controls.UI_LEFT_P) changeCat(-1);
		if (controls.UI_RIGHT_P) changeCat(1);

		if (FlxG.keys.justPressed.CONTROL) changeChart();

		/*if (FlxG.keys.justPressed.G) // for tests
		{
			man = !man;
			funnyText.text = 'Downloading a song ${menuItems[curSelected]}, game will be freezed...\nWhile you wait, look at this picture lol!';
			FlxTween.tween(black, {alpha: (man?1:0)}, 1, {ease: FlxEase.quartInOut});
			FlxTween.tween(funnyText, {alpha: (man?1:0)}, 1, {ease: FlxEase.quartInOut});
			FlxTween.tween(funnyPic, {alpha: (man?1:0)}, 1, {ease: FlxEase.quartInOut});
		}*/

		if (controls.RESET) changeCat(true);

		if (FlxG.keys.justPressed.DELETE && delete)
		{
			if (FlxG.keys.pressed.ALT)
			{
				funnyText.text = 'Deleting all cache, game can be freezed...\nWhile you wait, look at this picture lol!';
				FlxTween.tween(black, {alpha: 1}, 1, {ease: FlxEase.quartInOut, onComplete: function(twn:FlxTween){CoolUtil.deleteAll();}});
				FlxTween.tween(funnyText, {alpha: 1}, 1, {ease: FlxEase.quartInOut});
				FlxTween.tween(funnyPic, {alpha: 1}, 1, {ease: FlxEase.quartInOut});
			}
			else
			{
				funnyText.text = 'Deleting a ' + cats[curCat][1].toLowerCase() + ' ${menuItems[curSelected]}...\nWhile you wait, look at this picture lol!';
				FlxTween.tween(black, {alpha: 1}, 1, {ease: FlxEase.quartInOut, onComplete: function(twn:FlxTween){CoolUtil.deleteThing(menuItems[curSelected], curCat);}});
				FlxTween.tween(funnyText, {alpha: 1}, 1, {ease: FlxEase.quartInOut});
				FlxTween.tween(funnyPic, {alpha: 1}, 1, {ease: FlxEase.quartInOut});
			}
		}
		if (controls.ACCEPT && !delete)
		{
			funnyText.text = 'Downloading a ' + cats[curCat][1].toLowerCase() + ' ${menuItems[curSelected]}, game will be freezed...\nWhile you wait, look at this picture lol!';
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
				delete = (
					FileSystem.isDirectory(Paths.modFolders('songs/${menuItems[curSelected]}')) ||
					FileSystem.isDirectory(Paths.modFolders('data/${menuItems[curSelected]}'))
					? true : false);
			case 1:
				delete = (
					FileSystem.exists(Paths.modsImages('characters/${menuItems[curSelected]}')) ||
					FileSystem.exists(Paths.modsImages('icons/${menuItems[curSelected]}')) ||
					FileSystem.exists(Paths.modsXml('characters/${menuItems[curSelected]}')) ||
					FileSystem.exists(Paths.modFolders('characters/${menuItems[curSelected]}.json'))
					? true : false);
			case 2:
				delete = (
					FileSystem.exists('mods/stages/${menuItems[curSelected]}.json') ||
					FileSystem.exists('mods/stages/${menuItems[curSelected]}-needs.json')
					? true : false);
			case 3:
				delete = (
					FileSystem.exists('mods/custom_notetypes/${menuItems[curSelected]}.json') ||
					FileSystem.exists(Paths.modsImages('custom_notetypes/${menuItems[curSelected]}')) ||
					FileSystem.exists('mods/custom_notetypes/${menuItems[curSelected]}.xml') ||
					FileSystem.exists('mods/custom_notetypes/${menuItems[curSelected]}.lua')
					? true : false);
		}
		infoText.text = (delete ? 'Press DELETE to delete (hold ALT to delete all)' : 'Press ACCEPT to download') + ' / Press RESET to update list';

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

	function changeChart()
	{
		curChart += 1;
		if (curChart < 0)
			curChart = 3;
		if (curChart > 3)
			curChart = 0;

		FlxG.save.data.curChart = curChart;
		FlxG.save.data.loadCharacter = (curChart == 1 ? true : false);
		FlxG.save.data.loadStage = (curChart == 2 ? true : false);
		FlxG.save.data.loadNotetype = (curChart == 3 ? true : false);
		FlxG.save.flush();

		infoText2.text = 'Press CTRL to switch type of chart (now ${(curChart == 0 ? 'all' : (curChart == 1 ? 'without characters' : (curChart == 2 ? 'without stages' : 'without notetypes')))})';

		trace('loadCharacter: ${FlxG.save.data.loadCharacter} | loadStage: ${FlxG.save.data.loadStage} | loadNotetype: ${FlxG.save.data.loadNotetype}');
	}

	function changeCat(change:Int = 0, needUpdate:Bool = false):Void
	{
		curCat += change;
		if (curCat < 0)
			curCat = 3;
		if (curCat > 3)
			curCat = 0;

		if (needUpdate)
		{
			CoolUtil.loadingCats();
			cats = [[CoolUtil.getCats(0), cats[0][1]], [CoolUtil.getCats(1), cats[1][1]], [CoolUtil.getCats(2), cats[2][1]], [CoolUtil.getCats(3), cats[3][1]]];
		}
		menuItems = cats[curCat][0];
		trace('MenuItems: ${menuItems} || ${cats[0][1]}s: ${cats[0][0]} | ${cats[1][1]}s: ${cats[1][0]} | ${cats[2][1]}s: ${cats[2][0]} | ${cats[3][1]}s: ${cats[3][0]}');
		text.text = 'Press TAB or BACK to close this menu / Press LEFT or RIGHT to switch list (now ${cats[curCat][1]}s)';

		if (curCat != 0)
			infoText2.text = '';
		else
			infoText2.text = 'Press CTRL to switch type of chart (now ${(curChart == 0 ? 'all' : (curChart == 1 ? 'without characters' : (curChart == 2 ? 'without stages' : 'without notetypes')))})';

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
#end