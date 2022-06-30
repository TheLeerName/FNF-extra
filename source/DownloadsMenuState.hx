package;

#if desktop
import Discord.DiscordClient;
#end
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.ui.FlxButtonPlus;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.tweens.FlxTween;
import lime.utils.Assets;
import flixel.system.FlxSound;
import openfl.utils.Assets as OpenFlAssets;
import sys.io.File;
import sys.FileSystem;
import haxe.Json;
import haxe.format.JsonParser;
import openfl.display.BitmapData;
import flash.geom.Rectangle;
import flixel.ui.FlxButton;
import flixel.FlxBasic;
import sys.io.File;
/*import haxe.zip.Reader;
import haxe.zip.Entry;
import haxe.zip.Uncompress;
import haxe.zip.Writer;*/

using StringTools;

class DownloadsMenuState extends MusicBeatState
{
	var mods:Array<ModsMenuState.ModMetadata> = [];
	static var changedAThing = false;
	var bg:FlxSprite;
	var intendedColor:Int;
	var colorTween:FlxTween;
	
	var noModsTxt:FlxText;
	var selector:AttachedSprite;
	var descriptionTxt:FlxText;
	var needaReset = false;
	private static var curSelected:Int = 0;
	public static var defaultColor:FlxColor = 0xFF665AFF;

	var buttonDown:FlxButton;
	var buttonTop:FlxButton;
	var buttonDisableAll:FlxButton;
	var buttonEnableAll:FlxButton;
	var buttonDownload:FlxButton;
	var buttonUp:FlxButton;
	var buttonToggle:FlxButton;
	var buttonsArray:Array<FlxButton> = [];

	var switchButton:FlxButton;
	var installButton:FlxButton;
	var updatesButton:FlxButton;

	var modsList:Array<Dynamic> = [];
	var manList:Array<String> = [];

	var visibleWhenNoMods:Array<FlxBasic> = [];
	var visibleWhenHasMods:Array<FlxBasic> = [];

	public static var path = 'manifest/downloads';

	function updatePacks()
	{
		if (!FileAPI.file.exists(path) && !FileAPI.file.isDir(path))
			FileAPI.file.createDir(path);

		FileAPI.file.downloadFile(path + '/downloadList.txt',  'downloadList.txt');
		var list:Array<String> = FileAPI.file.parseTXT(path + '/downloadList.txt');
		//FileAPI.file.deleteFile('modsDownloadList.txt');

		for (i in 0...list.length)
		{
			list[i] = list[i].substring(0, list[i].indexOf('|'));
			if (!FileAPI.file.exists(path + '/' + list[i]) && !FileAPI.file.isDir(path + '/' + list[i]))
				FileAPI.file.createDir(path + '/' + list[i]);
			if (!FileAPI.file.exists(path + '/' + list[i] + '/pack.json'))
			{
				FileAPI.file.downloadFile(path + '/' + list[i] + '/pack.json', 'downloads/' + list[i] + '/pack.json');
				//var json = FileAPI.file.parseJSON(path + '/' + list[i] + '/pack.json');
				//json.needDownload = true;
				//FileAPI.file.saveFile(path + '/' + list[i] + '/pack.json', FileAPI.file.stringify(json, '\t', false));
				if (!FileAPI.file.exists(path + '/' + list[i] + '/pack.png'))
					FileAPI.file.downloadFile(path + '/' + list[i] + '/pack.png', 'downloads/' + list[i] + '/pack.png');
				if (!FileAPI.file.exists(path + '/' + list[i] + '/pack.xml'))
					FileAPI.file.downloadFile(path + '/' + list[i] + '/pack.xml', 'downloads/' + list[i] + '/pack.xml');
			}
		}
	}
	function checkUpdates(name:String):Bool
	{
		var json = FileAPI.file.parseJSON(path + '/${name}/pack.json');
		if (!FileAPI.file.exists('manifest/temp') && !FileAPI.file.isDir('manifest/temp'))
			FileAPI.file.createDir('manifest/temp');
		FileAPI.file.downloadFile('manifest/temp/${name}.json', 'downloads/${name}/pack.json');
		if (!FileAPI.file.exists('manifest/temp/${name}.json'))
			return false;
		var jsonremote = FileAPI.file.parseJSON('manifest/temp/${name}.json');
		FileAPI.file.deleteFiles('manifest/temp');
		FileAPI.file.deleteDir('manifest/temp');
		if (jsonremote.version == null)
			return false;
		if (json.version == null)
			return true;
		if (json.version != jsonremote.version)
			return true;
		return false;
	}

	override function create()
	{
		Paths.clearStoredMemory();
		Paths.clearUnusedMemory();
		WeekData.setDirectoryFromWeek();

		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end

		bg = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
		bg.antialiasing = ClientPrefs.globalAntialiasing;
		add(bg);
		bg.screenCenter();
		
		noModsTxt = new FlxText(0, 0, FlxG.width, 'NO DOWNLOADS FOUND\nCHANGE DOWNLOAD SERVER IN ${path}/downloadServer.txt', 48);
		if(FlxG.random.bool(0.1)) noModsTxt.text += '\nBITCH.'; //meanie
		noModsTxt.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		noModsTxt.scrollFactor.set();
		noModsTxt.borderSize = 2;
		add(noModsTxt);
		noModsTxt.screenCenter();
		visibleWhenNoMods.push(noModsTxt);

		updatePacks();
		for (lm in FileAPI.file.parseTXT(path + '/downloadList.txt'))
		{
			var dss:Array<String> = lm.split('|');
			if (FileAPI.file.exists(path + '/' + dss[0] + '/pack.json'))
				addToModsList([dss[0], false]);
		}

		/*if(FileSystem.exists(path))
		{
			var leMods:Array<String> = CoolUtil.coolTextFile(path);
			for (i in 0...leMods.length) if(leMods[i].length > 0) {
				var modSplit:Array<String> = leMods[i].split('|');
				if(!Paths.ignoreModFolders.contains(modSplit[0].toLowerCase()))
					addToModsList([modSplit[0], (modSplit[1] == '1')]);
			}
		}

		// FIND MOD FOLDERS
		var boolshit = true;
		if (FileSystem.exists(path))
			for (folder in Paths.getModDirectories())
				if(!Paths.ignoreModFolders.contains(folder))
					addToModsList([folder, true]);//i like it false by default. -bb //Well, i like it True! -Shadow
		saveTxt();*/

		// FIND MOD FOLDERS
		/*for (folder in Paths.getModDirectories())
		{
			addToModsList([folder, true]);
		}
		saveTxt();*/

		selector = new AttachedSprite();
		selector.xAdd = -205;
		selector.yAdd = -68;
		selector.alphaMult = 0.5;
		makeSelectorGraphic();
		add(selector);
		visibleWhenHasMods.push(selector);

		//attached buttons
		var startX:Int = 980;

		installButton = new FlxButton(startX, 0, "Delete", function()
		{
			FlxG.sound.play(Paths.sound('scrollMenu'), 0.6);
			if (manCheck(mods[curSelected].name))
				openSubState(new ModsSubState(mods[curSelected].name, 2));
			else
				openSubState(new ModsSubState(mods[curSelected].name, 1));
		});
		installButton.setGraphicSize(200, 50);
		installButton.updateHitbox();
		installButton.label.fieldWidth = 200;
		installButton.label.setFormat(Paths.font("vcr.ttf"), 22, FlxColor.WHITE, CENTER);
		setAllLabelsOffset(installButton, 0, 11);
		add(installButton);
		visibleWhenHasMods.push(installButton);
		buttonsArray.push(installButton);
		startX -= 220;

		updatesButton = new FlxButton(startX, 0, "Check Updates", function()
		{
			if (!manCheck(mods[curSelected].name))
				return;
			FlxG.sound.play(Paths.sound('scrollMenu'), 0.6);
			if (checkUpdates(mods[curSelected].name))
				openSubState(new ModsSubState(mods[curSelected].name, 5));
		});
		updatesButton.setGraphicSize(200, 50);
		updatesButton.updateHitbox();
		updatesButton.color = FlxColor.GRAY;
		updatesButton.label.fieldWidth = 200;
		updatesButton.label.setFormat(Paths.font("vcr.ttf"), 20, FlxColor.WHITE, CENTER);
		setAllLabelsOffset(updatesButton, 0, 13);
		add(updatesButton);
		visibleWhenHasMods.push(updatesButton);
		buttonsArray.push(updatesButton);
		startX -= 220;

		// more buttons
		var startX:Int = 1183;
		var startY:Int = 673;

		switchButton = new FlxButton(0, startY, "Exit Downloads", function()
		{
			FlxG.sound.play(Paths.sound('scrollMenu'), 0.6);
			FlxG.switchState(new ModsMenuState());
		});
		switchButton.setGraphicSize(200, 50);
		switchButton.updateHitbox();
		switchButton.color = FlxColor.PURPLE;
		switchButton.label.fieldWidth = 200;
		switchButton.label.setFormat(Paths.font("vcr.ttf"), 22, FlxColor.WHITE, CENTER);
		setAllLabelsOffset(switchButton, 0, 11);
		add(switchButton);

		///////
		descriptionTxt = new FlxText(148, 0, FlxG.width - 216, "", 32);
		descriptionTxt.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, LEFT);
		descriptionTxt.scrollFactor.set();
		add(descriptionTxt);
		visibleWhenHasMods.push(descriptionTxt);

		var i:Int = 0;
		var len:Int = modsList.length;
		while (i < modsList.length)
		{
			var values:Array<Dynamic> = modsList[i];
			if(!FileSystem.exists(path + '/' + values[0]))
			{
				modsList.remove(modsList[i]);
				continue;
			}

			var newMod:ModsMenuState.ModMetadata = new ModsMenuState.ModMetadata(path + '/' + values[0], true);
			mods.push(newMod);

			newMod.alphabet = new Alphabet(0, 0, mods[i].name, true, false, 0.05);
			var scale:Float = Math.min(840 / newMod.alphabet.width, 1);
			newMod.alphabet = new Alphabet(0, 0, mods[i].name, true, false, 0.05, scale);
			newMod.alphabet.y = i * 150;
			newMod.alphabet.x = 310;
			add(newMod.alphabet);
			//Don't ever cache the icons, it's a waste of loaded memory
			var loadedIcon:BitmapData = null;
			var iconToUse:String = path + '/' + values[0] + '/pack.png';
			//trace(iconToUse);
			if(FileSystem.exists(iconToUse))
			{
				loadedIcon = BitmapData.fromFile(iconToUse);
			}

			newMod.icon = new AttachedSprite();
			if(loadedIcon != null)
			{
				newMod.icon.loadGraphic(loadedIcon, true, 150, 150);//animated icon support
				var totalFrames = Math.floor(loadedIcon.width / 150) * Math.floor(loadedIcon.height / 150);
				newMod.icon.animation.add("icon", [for (i in 0...totalFrames) i],10);
				newMod.icon.animation.play("icon");
			}
			else
			{
				newMod.icon.loadGraphic(Paths.image('unknownMod'));
			}
			newMod.icon.sprTracker = newMod.alphabet;
			newMod.icon.xAdd = -newMod.icon.width - 30;
			newMod.icon.yAdd = -45;
			add(newMod.icon);
			i++;
		}
		
		if(curSelected >= mods.length) curSelected = 0;
		
		if(mods.length < 1)
			bg.color = defaultColor;
		else
			bg.color = mods[curSelected].color;

		intendedColor = bg.color;

		for (mf in FileAPI.file.readDir(path))
			if (FileAPI.file.exists('mods/' + mf + '/pack.json'))
			{
				//trace(mf);
				var modname:String = FileAPI.file.parseJSON('mods/' + mf + '/pack.json').name;
				for (i in 0...mods.length)
					if (modname == mods[i].name)
						manList.push(modname);
			}

		changeSelection();
		updatePosition();

		FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);

		FlxG.mouse.visible = true;

		super.create();
	}

	override function openSubState(SubState:flixel.FlxSubState)
	{
		super.openSubState(SubState);
	}

	function getIntArray(max:Int):Array<Int>{
		var arr:Array<Int> = [];
		for (i in 0...max){
			arr.push(i);
		}
		return arr;
	}
	function addToModsList(values:Array<Dynamic>)
	{
		for (i in 0...modsList.length)
		{
			if(modsList[i][0] == values[0])
			{
				//trace(modsList[i][0], values[0]);
				return;
			}
		}
		modsList.push(values);
	}

	function updateButtonToggle()
	{
		/*if (modsList[curSelected][1])
		{
			buttonToggle.label.text = 'ON';
			buttonToggle.color = FlxColor.GREEN;
		}
		else
		{
			buttonToggle.label.text = 'OFF';
			buttonToggle.color = FlxColor.RED;
		}*/

		if (!manCheck(mods[curSelected].name))
		{
			installButton.label.text = 'Download';
			installButton.color = FlxColor.GREEN;
			updatesButton.color = FlxColor.GRAY;
		}
		else
		{
			installButton.label.text = 'Delete';
			installButton.color = FlxColor.RED;
			updatesButton.color = FlxColor.YELLOW;
		}
	}
	function manCheck(name:String)
	{
		for (m in manList)
			if (m == name)
				return true;
		return false;
	}

	function moveMod(change:Int, skipResetCheck:Bool = false)
	{
		if(mods.length > 1)
		{
			var doRestart:Bool = (mods[0].restart);

			var newPos:Int = curSelected + change;
			if(newPos < 0)
			{
				modsList.push(modsList.shift());
				mods.push(mods.shift());
			}
			else if(newPos >= mods.length)
			{
				modsList.insert(0, modsList.pop());
				mods.insert(0, mods.pop());
			}
			else
			{
				var lastArray:Array<Dynamic> = modsList[curSelected];
				modsList[curSelected] = modsList[newPos];
				modsList[newPos] = lastArray;

				var lastMod:ModsMenuState.ModMetadata = mods[curSelected];
				mods[curSelected] = mods[newPos];
				mods[newPos] = lastMod;
			}
			changeSelection(change);

			if(!doRestart) doRestart = mods[curSelected].restart;
			if(!skipResetCheck && doRestart) needaReset = true;
		}
	}

	/*function saveTxt()
	{
		var fileStr:String = '';
		for (values in modsList)
		{
			if(fileStr.length > 0) fileStr += '\n';
			fileStr += values[0] + '|' + (values[1] ? '1' : '0');
		}

		var path:String = 'modsList.txt';
		File.saveContent(path, fileStr);
	}*/

	var noModsSine:Float = 0;
	var canExit:Bool = true;
	override function update(elapsed:Float)
	{
		if(noModsTxt.visible)
		{
			noModsSine += 180 * elapsed;
			noModsTxt.alpha = 1 - Math.sin((Math.PI * noModsSine) / 180);
		}

		var back = controls.BACK || FlxG.mouse.justPressedRight;
		var up = controls.UI_UP_P || FlxG.mouse.wheel > 0;
		var down = controls.UI_DOWN_P || FlxG.mouse.wheel < 0;

		if(canExit && back)
		{
			if(colorTween != null) {
				colorTween.cancel();
			}
			FlxG.sound.play(Paths.sound('cancelMenu'));
			FlxG.mouse.visible = false;
			//saveTxt();
			if(needaReset)
			{
				//MusicBeatState.switchState(new TitleState());
				TitleState.initialized = false;
				TitleState.closedState = false;
				FlxG.sound.music.fadeOut(0.3);
				FlxG.camera.fade(FlxColor.BLACK, 0.5, false, FlxG.resetGame, false);
			}
			else
			{
				MusicBeatState.switchState(new MainMenuState());
			}
		}

		if(up)
		{
			changeSelection(-1);
			FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
		}
		if(down)
		{
			changeSelection(1);
			FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
		}
		updatePosition(elapsed);
		super.update(elapsed);
	}

	function setAllLabelsOffset(button:FlxButton, x:Float, y:Float)
	{
		for (point in button.labelOffsets)
		{
			point.set(x, y);
		}
	}

	function changeSelection(change:Int = 0)
	{
		if(mods.length < 1)
		{
			for (obj in visibleWhenHasMods)
			{
				obj.visible = false;
			}
			for (obj in visibleWhenNoMods)
			{
				obj.visible = true;
			}
			return;
		}
		
		for (obj in visibleWhenHasMods)
		{
			obj.visible = true;
		}
		for (obj in visibleWhenNoMods)
		{
			obj.visible = false;
		}

		curSelected += change;
		if(curSelected < 0)
			curSelected = mods.length - 1;
		else if(curSelected >= mods.length)
			curSelected = 0;

		var newColor:Int = mods[curSelected].color;
		if(newColor != intendedColor) {
			if(colorTween != null) {
				colorTween.cancel();
			}
			intendedColor = newColor;
			colorTween = FlxTween.color(bg, 1, bg.color, intendedColor, {
				onComplete: function(twn:FlxTween) {
					colorTween = null;
				}
			});
		}
		
		var i:Int = 0;
		for (mod in mods)
		{
			mod.alphabet.alpha = 0.6;
			if(i == curSelected)
			{
				mod.alphabet.alpha = 1;
				selector.sprTracker = mod.alphabet;
				descriptionTxt.text = mod.description;
				/*if (mod.restart){//finna make it to where if nothing changed then it won't reset
					descriptionTxt.text += " (This Mod will restart the game!)";
				}*/

				// correct layering
				var stuffArray:Array<FlxSprite> = [switchButton, /*installButton, updatesButton,*/ selector, descriptionTxt, mod.alphabet, mod.icon];
				for (obj in stuffArray)
				{
					remove(obj);
					insert(members.length, obj);
				}
				for (obj in buttonsArray)
				{
					remove(obj);
					insert(members.length, obj);
				}
			}
			i++;
		}
		updateButtonToggle();
	}

	function updatePosition(elapsed:Float = -1)
	{
		var i:Int = 0;
		for (mod in mods)
		{
			var intendedPos:Float = (i - curSelected) * 225 + 200;
			if(i > curSelected) intendedPos += 225;
			if(elapsed == -1)
			{
				mod.alphabet.y = intendedPos;
			}
			else
			{
				mod.alphabet.y = FlxMath.lerp(mod.alphabet.y, intendedPos, CoolUtil.boundTo(elapsed * 12, 0, 1));
			}

			if(i == curSelected)
			{
				descriptionTxt.y = mod.alphabet.y + 160;
				for (button in buttonsArray)
				{
					button.y = mod.alphabet.y + 320;
				}
			}
			i++;
		}
	}

	var cornerSize:Int = 11;
	function makeSelectorGraphic()
	{
		selector.makeGraphic(1100, 450, FlxColor.BLACK);
		selector.pixels.fillRect(new Rectangle(0, 190, selector.width, 5), 0x0);

		// Why did i do this? Because i'm a lmao stupid, of course
		// also i wanted to understand better how fillRect works so i did this shit lol???
		selector.pixels.fillRect(new Rectangle(0, 0, cornerSize, cornerSize), 0x0);														 //top left
		drawCircleCornerOnSelector(false, false);
		selector.pixels.fillRect(new Rectangle(selector.width - cornerSize, 0, cornerSize, cornerSize), 0x0);							 //top right
		drawCircleCornerOnSelector(true, false);
		selector.pixels.fillRect(new Rectangle(0, selector.height - cornerSize, cornerSize, cornerSize), 0x0);							 //bottom left
		drawCircleCornerOnSelector(false, true);
		selector.pixels.fillRect(new Rectangle(selector.width - cornerSize, selector.height - cornerSize, cornerSize, cornerSize), 0x0); //bottom right
		drawCircleCornerOnSelector(true, true);
	}

	function drawCircleCornerOnSelector(flipX:Bool, flipY:Bool)
	{
		var antiX:Float = (selector.width - cornerSize);
		var antiY:Float = flipY ? (selector.height - 1) : 0;
		if(flipY) antiY -= 2;
		selector.pixels.fillRect(new Rectangle((flipX ? antiX : 1), Std.int(Math.abs(antiY - 8)), 10, 3), FlxColor.BLACK);
		if(flipY) antiY += 1;
		selector.pixels.fillRect(new Rectangle((flipX ? antiX : 2), Std.int(Math.abs(antiY - 6)),  9, 2), FlxColor.BLACK);
		if(flipY) antiY += 1;
		selector.pixels.fillRect(new Rectangle((flipX ? antiX : 3), Std.int(Math.abs(antiY - 5)),  8, 1), FlxColor.BLACK);
		selector.pixels.fillRect(new Rectangle((flipX ? antiX : 4), Std.int(Math.abs(antiY - 4)),  7, 1), FlxColor.BLACK);
		selector.pixels.fillRect(new Rectangle((flipX ? antiX : 5), Std.int(Math.abs(antiY - 3)),  6, 1), FlxColor.BLACK);
		selector.pixels.fillRect(new Rectangle((flipX ? antiX : 6), Std.int(Math.abs(antiY - 2)),  5, 1), FlxColor.BLACK);
		selector.pixels.fillRect(new Rectangle((flipX ? antiX : 8), Std.int(Math.abs(antiY - 1)),  3, 1), FlxColor.BLACK);
	}
	/*function installMod() {
		var zipFilter:FileFilter = new FileFilter('ZIP', 'zip');
		_file = new FileReference();
		_file.addEventListener(Event.SELECT, onLoadComplete);
		_file.addEventListener(Event.CANCEL, onLoadCancel);
		_file.addEventListener(IOErrorEvent.IO_ERROR, onLoadError);
		_file.browse([zipFilter]);
		canExit = false;
	}*/
}
