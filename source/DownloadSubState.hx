package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;
#if MODS_ALLOWED
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
#end

class DownloadSubState extends MusicBeatSubstate
{
	var grpMenuShit:FlxTypedGroup<Alphabet>;
	var menuItems:Array<String>;
	var cats:Array<Dynamic>;
	var curCat:Int = 0;
	var curSelected:Int = 0;
	var curChart:Int = 0;

	var delete:Bool = false;
	var textBG:FlxSprite;
	//var text5:FlxText;
	var text4:FlxText;
	var text3:FlxText;
	var text2:FlxText;
	var text1:FlxText;

	var siteBG:FlxSprite;
	var textSite:FlxText;

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
		[CoolUtil.getCats(3), 'Note Type']
		];
		menuItems = cats[curCat][0];
		//trace('MenuItems: ${menuItems} || ${cats[0][1]}s: ${cats[0][0]} | ${cats[1][1]}s: ${cats[1][0]} | ${cats[2][1]}s: ${cats[2][0]} | ${cats[3][1]}s: ${cats[3][0]}');
		for (i in 0...menuItems.length) {
			var item = new Alphabet(0, 70 * i + 30, menuItems[i], true, false);
			item.isMenuItem = true;
			item.targetY = i;
			grpMenuShit.add(item);
		}

		#if MODS_ALLOWED
		delete = (CoolUtil.isDir(Paths.modFolders('songs/${menuItems[curSelected]}')) || CoolUtil.isDir(Paths.modFolders('data/${menuItems[curSelected]}')) ? true : false);
		#end
		var text_X:Float = -3;
		var textspacing_Y:Float = 21;
		textBG = new FlxSprite((FlxG.width / 2) + 210, FlxG.height - 3 - textspacing_Y * 4).makeGraphic(FlxG.width, Std.int(FlxG.height - 3 - textspacing_Y * 4), 0xFF000000);
		textBG.alpha = 0.6;
		add(textBG);
		text1 = new FlxText(text_X, FlxG.height - textspacing_Y, FlxG.width, '', 18);
		text1.setFormat(Paths.font("vcr.ttf"), 18, FlxColor.WHITE, RIGHT);
		add(text1);
		text2 = new FlxText(text_X, text1.y - textspacing_Y, FlxG.width, '', 18);
		text2.setFormat(Paths.font("vcr.ttf"), 18, FlxColor.WHITE, RIGHT);
		add(text2);
		text3 = new FlxText(text_X, text2.y - textspacing_Y, FlxG.width, '', 18);
		text3.setFormat(Paths.font("vcr.ttf"), 18, FlxColor.WHITE, RIGHT);
		add(text3);
		text4 = new FlxText(text_X, text3.y - textspacing_Y, FlxG.width, '', 18);
		text4.setFormat(Paths.font("vcr.ttf"), 18, FlxColor.WHITE, RIGHT);
		add(text4);
		/*text5 = new FlxText(text_X, text4.y - textspacing_Y, FlxG.width, '', 18);
		text5.setFormat(Paths.font("vcr.ttf"), 18, FlxColor.WHITE, RIGHT);
		add(text5);*/

		textBG = new FlxSprite(0, 0).makeGraphic(FlxG.width, 24, 0xFF000000);
		textBG.alpha = 0.6;
		add(textBG);
		textSite = new FlxText(text_X, 2, FlxG.width, CoolUtil.getContent('mods/downloadServer.txt').split('\n')[0], 18);
		textSite.setFormat(Paths.font("vcr.ttf"), 18, FlxColor.WHITE, RIGHT);
		add(textSite);

		text1.text = 'TAB or BACK to close this menu';
		text2.text = 'List: ${cats[curCat][1]}s (press LEFT or RIGHT)';
		text3.text = 'RESET to update list';
		#if MODS_ALLOWED
		text4.text = (delete ? 'DELETE to delete (ALT to delete all)' : 'ACCEPT to download');
		#else
		text4.text = '';
		#end
		/*if (curCat == 0)
			text5.text = 'Type of chart: ${(curChart == 0 ? 'default' : (curChart == 1 ? 'without characters' : (curChart == 2 ? 'without stages' : 'without notetypes')))} (press CTRL)';
		else
			text5.text = '';*/

		black = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		black.alpha = 0;
		add(black);

		funnyPic = new FlxSprite().loadGraphic(Paths.image('loading/${CoolUtil.getContent(Paths.modsTxt('loading/imageNames')).split('\n')[Std.int(Std.random(CoolUtil.getContent(Paths.modsTxt('loading/imageNames')).split('\n').length))]}'));
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

		//if (FlxG.keys.justPressed.CONTROL && curCat == 0) changeChart();

		/*if (FlxG.keys.justPressed.G) // for tests
		{
			man = !man;
			funnyText.text = 'Downloading a song ${menuItems[curSelected]}, game will be freezed...\nWhile you wait, look at this picture lol!';
			FlxTween.tween(black, {alpha: (man?1:0)}, 1, {ease: FlxEase.quartInOut});
			FlxTween.tween(funnyText, {alpha: (man?1:0)}, 1, {ease: FlxEase.quartInOut});
			FlxTween.tween(funnyPic, {alpha: (man?1:0)}, 1, {ease: FlxEase.quartInOut});
		}*/

		if (controls.RESET) changeCat(true);

		#if MODS_ALLOWED
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
		#end
	}

	function changeSelection(change:Int = 0):Void
	{
		curSelected += change;

		FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);

		if (curSelected < 0)
			curSelected = menuItems.length - 1;
		if (curSelected >= menuItems.length)
			curSelected = 0;

		#if MODS_ALLOWED
		switch (curCat)
		{
			case 0:
				delete = (
					CoolUtil.isDir(Paths.modFolders('songs/${menuItems[curSelected]}')) ||
					CoolUtil.isDir(Paths.modFolders('data/${menuItems[curSelected]}'))
					? true : false);
			case 1:
				delete = (
					CoolUtil.exists(Paths.modsImages('characters/${menuItems[curSelected]}')) ||
					CoolUtil.exists(Paths.modsImages('icons/${menuItems[curSelected]}')) ||
					CoolUtil.exists(Paths.modsXml('characters/${menuItems[curSelected]}')) ||
					CoolUtil.exists(Paths.modFolders('characters/${menuItems[curSelected]}.json'))
					? true : false);
			case 2:
				delete = (
					CoolUtil.exists('mods/stages/${menuItems[curSelected]}.json') ||
					CoolUtil.isDir(Paths.modFolders('images/stages/${menuItems[curSelected]}'))
					? true : false);
			case 3:
				delete = (
					CoolUtil.exists('mods/custom_notetypes/${menuItems[curSelected]}.json') ||
					CoolUtil.exists(Paths.modsImages('custom_notetypes/${menuItems[curSelected]}')) ||
					CoolUtil.exists('mods/custom_notetypes/${menuItems[curSelected]}.xml') ||
					CoolUtil.exists('mods/custom_notetypes/${menuItems[curSelected]}.lua')
					? true : false);
		}
		text4.text = (delete ? 'DELETE to delete (ALT to delete all)' : 'ACCEPT to download');
		#else
		text4.text = '';
		#end
		textSite.text = CoolUtil.getContent('mods/downloadServer.txt').split('\n')[0];
		/*if (curCat == 0)
			text5.text = 'Type of chart: ${(curChart == 0 ? 'default' : (curChart == 1 ? 'without characters' : (curChart == 2 ? 'without stages' : 'without notetypes')))} (press CTRL)';
		else
			text5.text = '';*/

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

	/*function changeChart()
	{
		curChart += 1;
		if (curChart > 3)
			curChart = 0;

		FlxG.save.data.curChart = curChart;
		FlxG.save.flush();

		//trace('Chart: ' + (FlxG.save.data.curChart == 3 ? 'without notetype' : (FlxG.save.data.curChart == 2 ? 'without stage' : (FlxG.save.data.curChart == 1 ? 'without character' : 'default'))));
		text5.text = 'Type of chart: ${(curChart == 0 ? 'default' : (curChart == 1 ? 'without characters' : (curChart == 2 ? 'without stages' : 'without notetypes')))} (press CTRL)';
	}*/

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
		//trace('MenuItems: ${menuItems} || ${cats[0][1]}s: ${cats[0][0]} | ${cats[1][1]}s: ${cats[1][0]} | ${cats[2][1]}s: ${cats[2][0]} | ${cats[3][1]}s: ${cats[3][0]}');
		text2.text = 'List: ${cats[curCat][1]}s (press LEFT or RIGHT)';
		/*if (curCat == 0)
			text5.text = 'Type of chart: ${(curChart == 0 ? 'default' : (curChart == 1 ? 'without characters' : (curChart == 2 ? 'without stages' : 'without notetypes')))} (press CTRL)';
		else
			text5.text = '';*/

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