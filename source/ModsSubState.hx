package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.util.FlxColor;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.text.FlxText;
import flixel.util.FlxTimer;
import flixel.util.FlxColor;
import flixel.addons.transition.FlxTransitionableState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.ui.FlxButton;
import flixel.addons.ui.FlxInputText;
import openfl.desktop.ClipboardFormats;
import openfl.desktop.Clipboard;
import openfl.net.FileReference;
import openfl.net.FileFilter;
import openfl.events.Event;
import openfl.events.IOErrorEvent;
import openfl.utils.ByteArray;
import lime.app.Application;

using StringTools;
	
class ModsSubState extends MusicBeatSubstate
{
	var bg:FlxSprite;
	var funnyText:FlxText;
	var mode:Int;
	var name:String;

	var isImport = false;
	var inGB = false;

	var text1:FlxText;
	var inputURL:FlxInputText;
	var clearB:FlxButton;
	var accept:FlxButton;

	var text2:FlxText;
	var inputPath:FlxInputText;
	var clearB2:FlxButton;
	var browse:FlxButton;
	var accept2:FlxButton;

	var text_name:FlxText;
	var text_desc:FlxText;
	var text_files:FlxText;
	var text_altfiles:FlxText;

	var texts:FlxTypedGroup<FlxText>;
	var buttons:FlxTypedGroup<FlxButton>;

	var path:String = DownloadsMenuState.path;

	public function new(name_:String, mode_:Int)
	{
		super();
		buttons = new FlxTypedGroup<FlxButton>();
		texts = new FlxTypedGroup<FlxText>();
		mode = mode_;
		name = name_;
		bg = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		bg.alpha = 0;
		bg.scrollFactor.set();
		add(bg);

		funnyText = new FlxText(0, FlxG.height * 0.25, FlxG.width, '', 30);
		funnyText.setFormat(Paths.font("vcr.ttf"), 30, FlxColor.WHITE, CENTER, FlxColor.BLACK);
		funnyText.alpha = 0;
		add(funnyText);

		switch (mode)
		{
			case 1:
				funnyText.text = 'Downloading ' + name + '...';
			case 2:
				funnyText.text = 'Deleting ' + name + '...';
			case 3:
				funnyText.text = 'Importing mod...';
			case 4:
				funnyText.text = 'Exporting ' + name + '...';
			case 5:
				funnyText.text = 'Updating ' + name + '...';
			case 6:
				var y = FlxG.height * 0.2;
				text1 = new FlxText(0, y, FlxG.width, 'Enter URL of GameBanana Mod or direct link to mod', 30);
				text1.setFormat(Paths.font("vcr.ttf"), 30, FlxColor.WHITE, CENTER, FlxColor.BLACK);
				text1.alpha = 0;
				add(text1);

				y += 75;
				inputURL = new FlxInputText(200, y, 880, '', 16);

				y += 25;
				clearB = new FlxButton(197, y, 'CLEAR', function() {
					if (inputURL.text.length < 1)
						return;
					FlxG.sound.play(Paths.sound('cancelMenu'));
					inputURL.text = '';
				}); 
				clearB.setGraphicSize(200, 35);
				clearB.updateHitbox();
				clearB.label.fieldWidth = 200;
				clearB.color = FlxColor.RED;
				clearB.label.setFormat(Paths.font("vcr.ttf"), 24, FlxColor.BLACK, CENTER);
				setAllLabelsOffset(clearB, -2, 3);
				clearB.alpha = 0;
				add(clearB);

				// Other methods of import mod present:
				// 1. gamebanana.com/mods, menu with files and alternative file sources
				// 2. drive.google.com, a little corrected direct download link
				// If you know more file hosting websites, pls create issue in gihtub FNF Extra <3
				accept = new FlxButton(883, y, 'CONFIRM', function() {
					FlxG.sound.play(Paths.sound('scrollMenu'), 0.6);
					var ina:String = inputURL.text;
					if (!ina.contains('https://') && !ina.contains('http://'))
						ina = 'http://' + ina;

					if (ina.startsWith('https://drive.google.com/file/d/') || ina.startsWith('http://drive.google.com/file/d/'))
					{
						var id = ina.substring(ina.lastIndexOf('drive.google.com/file/d/') + 24);
						if (id.contains('/')) id = id.substring(0, id.indexOf('/'));
						//trace(id);
						ina = 'https://drive.google.com/u/1/uc?id=' + id + '&export=download&confirm=t';
						//trace(ina);
						trace('hello there! u choosed google drive method of import mod!');
						var th = FileAPI.file.unpackMod(ina, true);
						if (th.length < 2)
							return;
						inputURL.text = '';
						exit();
						return;
					}
					else if (ina.startsWith('https://gamebanana.com/mods/') || ina.startsWith('http://gamebanana.com/mods/'))
					{
						inGB = true;
						trace('hello there! u choosed gamebanana method of import mod!');
						try {
							var modid = ina.substring(ina.lastIndexOf('gamebanana.com/mods/') + 20);
							if (modid.contains('/')) modid = modid.substring(0, modid.indexOf('/'));
							//trace(modid);
							FileAPI.file.downloadFile('manifest/poop.html', ina);
							var modth = FileAPI.file.getContent('manifest/poop.html');
							FileAPI.file.deleteFile('manifest/poop.html');
							var modname = null;
							var moddesc = null;
							if (modth.contains('<title>'))
							{
								modname = modth.substring(modth.lastIndexOf('<title>') + 7, modth.lastIndexOf('</title>'));
								modname = modname.substring(0, modname.indexOf(' ['));
							}
							if (modth.contains('id="ItemProfileModule"'))
							{
								modth = modth.substring(modth.indexOf('id="ItemProfileModule"') + 22);
								modth = modth.substring(0, modth.indexOf('</module>'));
								if (modth.contains('<article class="RichText">'))
								{
									var d = modth.substring(modth.lastIndexOf('<article class="RichText">') + 26, modth.lastIndexOf('</article>'));
									var moddescar:Array<String> = d.split('<br>');
									for (i in 0...moddescar.length)
										if (moddescar[i].contains('<a'))
										{
											var oi = moddescar[i].split('<a');
											for (i1 in 0...oi.length)
												if (oi[i1].contains('>') && oi[i1].contains('<'))
													oi[i1] = oi[i1].substring(oi[i1].indexOf('>') + 1, oi[i1].indexOf('<'));
											moddescar[i] = oi.join('');
										}
									moddesc = moddescar.join('\n');
								}
							}
							trace(modname);
							FileAPI.file.downloadFile('manifest/poop.json', 'https://gamebanana.com/apiv8/Mod/' + modid + '/DownloadPage');
							// https://github.com/ShadowMario/FNF-PsychEngine/pull/7973, thx <3
							try
							{
								var files_:Dynamic = FileAPI.file.parseJSON('manifest/poop.json');
								FileAPI.file.deleteFile('manifest/poop.json');
								inputURL.destroy();
								inputPath.destroy();
								text1.alpha = 0;
								clearB.alpha = 0;
								accept.alpha = 0;
								text2.alpha = 0;
								browse.alpha = 0;
								clearB2.alpha = 0;
								accept2.alpha = 0;

								var y_ = FlxG.height * 0.1;
								var files = [];
								for(i in 0...files_._aFiles.length)
										if (!files_._aFiles[i]._bContainsExe)
											files.push(files_._aFiles[i]);

								if (modname != null)
								{
									text_name = new FlxText(0, y_, FlxG.width, modname, 30);
									text_name.setFormat(Paths.font("vcr.ttf"), 30, FlxColor.WHITE, CENTER, FlxColor.BLACK);
									add(text_name);
									texts.add(text_name);
									y_ += 75;
								}

								if (moddesc != null)
								{
									text_desc = new FlxText(100, y_, FlxG.width, moddesc, 24);
									text_desc.setFormat(Paths.font("vcr.ttf"), 24, FlxColor.WHITE, LEFT, FlxColor.BLACK);
									add(text_desc);
									texts.add(text_desc);
									y_ += text_desc.height + 50;
								}

								if (files.length > 0)
								{
									text_files = new FlxText(200, y_, FlxG.width, 'Files', 30);
									text_files.setFormat(Paths.font("vcr.ttf"), 30, FlxColor.WHITE, LEFT, FlxColor.BLACK);
									add(text_files);
									texts.add(text_files);
									y_ += 50;
								}

								for(i in 0...files.length)
								{
									var hu = new FlxButton(100, y_, files[i]._sFile, function() {
										var th = FileAPI.file.unpackMod('https://gamebanana.com/dl/' + files[i]._idRow, true);
										if (th.length < 2)
											return;
										inputURL.text = '';
										exit();
										return;
									});
									hu.setGraphicSize(1000, 35);
									hu.updateHitbox();
									hu.label.fieldWidth = 1000;
									hu.label.setFormat(Paths.font("vcr.ttf"), 24, FlxColor.BLACK, CENTER);
									add(hu);
									buttons.add(hu);

									y_ += 40;
								}

								var altfiles:Array<Dynamic> = [];
								for(i in 0...files_._aAlternateFileSources.length)
								{
									var url:String = files_._aAlternateFileSources[i].url;
									if (url.contains('\\'))
										url.replace('\\', '');

									if (url.startsWith('https://drive.google.com/file/d/'))
										altfiles.push({url: 'https://drive.google.com/u/1/' + url.substring(url.lastIndexOf('https://drive.google.com/file/d/'), url.lastIndexOf('/edit')) + '&export=download&confirm=t', description: files_._aAlternateFileSources[i].description});
									else if (url.startsWith('http://drive.google.com/file/d/'))
										altfiles.push({url: 'https://drive.google.com/u/1/' + url.substring(url.lastIndexOf('http://drive.google.com/file/d/'), url.lastIndexOf('/edit')) + '&export=download&confirm=t', description: files_._aAlternateFileSources[i].description});
								}

								if (altfiles.length > 0)
								{
									y_ += 50;
									text_altfiles = new FlxText(200, y_, FlxG.width, 'Alternate File Sources', 30);
									text_altfiles.setFormat(Paths.font("vcr.ttf"), 30, FlxColor.WHITE, LEFT, FlxColor.BLACK);
									add(text_altfiles);
									texts.add(text_altfiles);
									y_ += 50;
								}

								for(i in 0...altfiles.length)
								{
									var hu = new FlxButton(100, y_, altfiles[i].description, function() {
										var th = FileAPI.file.unpackMod(altfiles[i].url, true);
										if (th.length < 2)
											return;
										inputURL.text = '';
										exit();
										return;
									});
									hu.setGraphicSize(1000, 35);
									hu.updateHitbox();
									hu.label.fieldWidth = 1000;
									hu.label.setFormat(Paths.font("vcr.ttf"), 24, FlxColor.BLACK, CENTER);
									add(hu);
									buttons.add(hu);

									y_ += 40;
								}
							}
							catch (e) {
								trace("Error importing mod from GameBanana (i think problem in gamebanana api): " + e);
								Application.current.window.alert('I think problem in GameBanana API. ' + e, 'IMPORT MOD ERROR');
								if (FileAPI.file.exists('manifest/poop.json'))
									FileAPI.file.deleteFile('manifest/poop.json');
								return;
							}
							
						}
						catch (e) {
							trace("Error importing mod from GameBanana (try check connection to internet): " + e);
							Application.current.window.alert('Try check connection to Internet. ' + e, 'IMPORT MOD ERROR');
							if (FileAPI.file.exists('manifest/poop.json'))
								FileAPI.file.deleteFile('manifest/poop.json');
							return;
						}
					}
					else
					{
						trace('hello there! u choosed default method of import mod!');
						var th = FileAPI.file.unpackMod(ina, true);
						if (th.length < 2)
							return;
						inputURL.text = '';
						exit();
						return;
					}
				});
				accept.setGraphicSize(200, 35);
				accept.updateHitbox();
				accept.label.fieldWidth = 200;
				accept.color = FlxColor.LIME;
				accept.label.setFormat(Paths.font("vcr.ttf"), 24, FlxColor.BLACK, CENTER);
				setAllLabelsOffset(accept, -2, 3);
				accept.alpha = 0;
				add(accept);

				y += 150;
				text2 = new FlxText(0, y, FlxG.width, 'Or enter path to ZIP pack', 30);
				text2.setFormat(Paths.font("vcr.ttf"), 30, FlxColor.WHITE, CENTER, FlxColor.BLACK);
				text2.alpha = 0;
				add(text2);

				y += 75;
				inputPath = new FlxInputText(200, y, 732, '', 16);

				browse = new FlxButton(933, y - 2, 'Browse...', function() {
					FlxG.sound.play(Paths.sound('scrollMenu'), 0.6);
					var zipFilter:FileFilter = new FileFilter('ZIP', 'zip');
					_file = new FileReference();
					_file.addEventListener(Event.SELECT, onLoadComplete);
					_file.addEventListener(Event.CANCEL, onLoadCancel);
					_file.addEventListener(IOErrorEvent.IO_ERROR, onLoadError);
					_file.browse([zipFilter]);
				});
				browse.setGraphicSize(150, 27);
				browse.updateHitbox();
				browse.label.fieldWidth = 150;
				browse.label.setFormat(Paths.font("vcr.ttf"), 22, FlxColor.BLACK, CENTER);
				setAllLabelsOffset(browse, 0, 0);
				browse.alpha = 0;
				add(browse);

				y += 27;
				clearB2 = new FlxButton(197, y, 'CLEAR', function() {
					if (inputPath.text.length < 1)
						return;
					FlxG.sound.play(Paths.sound('cancelMenu'));
					inputPath.text = '';
				});
				clearB2.setGraphicSize(200, 35);
				clearB2.updateHitbox();
				clearB2.label.fieldWidth = 200;
				clearB2.color = FlxColor.RED;
				clearB2.label.setFormat(Paths.font("vcr.ttf"), 24, FlxColor.BLACK, CENTER);
				setAllLabelsOffset(clearB2, -2, 3);
				clearB2.alpha = 0;
				add(clearB2);

				accept2 = new FlxButton(736, y, 'CONFIRM', function() {
					if (inputPath.text.length < 1)
						return;
					FlxG.sound.play(Paths.sound('scrollMenu'), 0.6);
					FileAPI.file.unpackMod(inputPath.text, false);
					exit();
				});
				accept2.setGraphicSize(200, 35);
				accept2.updateHitbox();
				accept2.label.fieldWidth = 200;
				accept2.color = FlxColor.LIME;
				accept2.label.setFormat(Paths.font("vcr.ttf"), 24, FlxColor.BLACK, CENTER);
				setAllLabelsOffset(accept2, -2, 3);
				accept2.alpha = 0;
				add(accept2);

				FlxTween.tween(bg, {alpha: 0.95}, 0.4, {ease: FlxEase.quartInOut});

				FlxTween.tween(text1, {alpha: 1}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.3});
				FlxTween.tween(clearB, {alpha: 1}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.3});
				FlxTween.tween(accept, {alpha: 1}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.3, onComplete: function (twn:FlxTween) {
					add(inputURL);
				}});

				FlxTween.tween(text2, {alpha: 1}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.7});
				FlxTween.tween(browse, {alpha: 1}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.7});
				FlxTween.tween(clearB2, {alpha: 1}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.7});
				FlxTween.tween(accept2, {alpha: 1}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.7, onComplete: function (twn:FlxTween) {
					isImport = true;
					add(inputPath);
				}});
				return;
		}
		FlxTween.tween(bg, {alpha: 0.95}, 0.4, {ease: FlxEase.quartInOut});
		FlxTween.tween(funnyText, {alpha: 1}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.3, onComplete: function (twn:FlxTween) {
			switch (mode)
			{
				case 1:
					downloadMod(name);
				case 2:
					deleteMod(name);
				case 3:
					importMod();
				case 4:
					exportMod(name);
				case 5:
					deleteMod(name, false);
					downloadMod(name);
			}
		}});
	}

	var m = 80;
	override function update(elapsed:Float)
	{
		if (controls.BACK && isImport)
		{
			if (!inputURL.hasFocus && !inputPath.hasFocus)
			{
				exit(true, false);
			}
		}

		if (inGB)
		{
			if (controls.UI_UP || controls.UI_DOWN)
			{
				var ukr = m * (controls.UI_DOWN ? -0.5 : 0.5);
				for (obj in texts.members)
						obj.y += ukr;
				for (obj in buttons.members)
						obj.y += ukr;
			}
			if (FlxG.mouse.wheel != 0)
			{
				for (obj in texts.members)
						obj.y += FlxG.mouse.wheel * m;
				for (obj in buttons.members)
						obj.y += FlxG.mouse.wheel * m;
			}
		}

		if (FlxG.keys.pressed.CONTROL && FlxG.keys.justPressed.V && isImport)
		{
			if (inputURL.hasFocus)
			{
				var paste = Clipboard.generalClipboard.getData(ClipboardFormats.TEXT_FORMAT);
				//trace(paste);
				if (paste != null)
				{
					inputURL.text = inputURL.text.substring(0, inputURL.caretIndex - 1) + paste + inputURL.text.substring(inputURL.caretIndex);
					inputURL.caretIndex += paste.length;
				}
				else
				{
					inputURL.text = inputURL.text.substring(0, inputURL.caretIndex - 1) + inputURL.text.substring(inputURL.caretIndex);
					inputURL.caretIndex--;
				}
			}
			if (inputPath.hasFocus)
			{
				var paste = Clipboard.generalClipboard.getData(ClipboardFormats.TEXT_FORMAT);
				//trace(paste);
				if (paste != null)
				{
					inputPath.text = inputPath.text.substring(0, inputPath.caretIndex - 1) + paste + inputPath.text.substring(inputPath.caretIndex);
					inputPath.caretIndex += paste.length;
				}
				else
				{
					inputPath.text = inputPath.text.substring(0, inputPath.caretIndex - 1) + inputPath.text.substring(inputPath.caretIndex);
					inputPath.caretIndex--;
				}
			}
		}
		super.update(elapsed);
	}

	function setAllLabelsOffset(button:FlxButton, x:Float, y:Float)
	{
		for (point in button.labelOffsets)
		{
			point.set(x, y);
		}
	}

	function exit(sound:Bool = false, reset:Bool = true)
	{
		if (isImport)
		{
			FlxTween.tween(text1, {alpha: 0}, 0.4, {ease: FlxEase.quartInOut});
			FlxTween.tween(clearB, {alpha: 0}, 0.4, {ease: FlxEase.quartInOut});
			FlxTween.tween(accept, {alpha: 0}, 0.4, {ease: FlxEase.quartInOut});

			FlxTween.tween(text2, {alpha: 0}, 0.4, {ease: FlxEase.quartInOut, onStart: function (twn:FlxTween) {
				inputURL.destroy();
				inputPath.destroy();
			}});
			FlxTween.tween(browse, {alpha: 0}, 0.4, {ease: FlxEase.quartInOut});
			FlxTween.tween(clearB2, {alpha: 0}, 0.4, {ease: FlxEase.quartInOut});
			FlxTween.tween(accept2, {alpha: 0}, 0.4, {ease: FlxEase.quartInOut, onComplete: function (twn:FlxTween) {
				isImport = false;
				close();
				if (reset) FlxG.switchState(new ModsMenuState());
				if (sound) FlxG.sound.play(Paths.sound('cancelMenu'));
			}});
		}
		else
		{
			FlxTween.tween(funnyText, {alpha: 0}, 0.4, {ease: FlxEase.quartInOut});
		}

		FlxTween.tween(bg, {alpha: 0}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.3, onComplete: function(twn:FlxTween) {
			if (!isImport)
			{
				close();
				if (reset) FlxG.switchState(new ModsMenuState());
				if (sound) FlxG.sound.play(Paths.sound('cancelMenu'));
			}
		}});
	}

	var _file:FileReference = null;

	function downloadMod(name:String, withClose:Bool = true)
	{
		FileAPI.file.createDir('mods/' + name);
		FileAPI.file.copy('mods/${name}/pack.json', path + '/${name}/pack.json');
		if (FileAPI.file.exists(path + '/${name}/pack.png'))
			FileAPI.file.copy('mods/${name}/pack.png', path + '/${name}/pack.png');
		if (FileAPI.file.exists(path + '/${name}/pack.xml'))
			FileAPI.file.copy('mods/${name}/pack.xml', path + '/${name}/pack.xml');

		var json = FileAPI.file.parseJSON('mods/${name}/pack.json');
		var site = 'downloads/${name}/assets.zip';
		if (json.downloadLink != null)
			site = json.downloadLink;
		FileAPI.file.downloadFile('mods/${name}/assets.zip', site);
		FileAPI.file.unpack('mods/${name}/assets.zip', 'mods/${name}');
		FileAPI.file.deleteFile('mods/${name}/assets.zip');
		//json.needDownload = false;
		//FileAPI.file.saveFile('mods/${name}/pack.json', FileAPI.file.stringify(json, '\t', false));
		if (withClose)
		{
			funnyText.text = 'Successfully downloaded ' + name + '!';
			new FlxTimer().start(1, function(tmr:FlxTimer) {
				exit();
			});
		}
	}
	function deleteMod(name:String, withClose:Bool = true)
	{
		FileAPI.file.deleteFiles('mods/${name}');
		FileAPI.file.deleteDir('mods/${name}');
		var _modsList = FileAPI.file.parseTXT(path + '/downloadList.txt');
		var _modsList1 = [];
		var int = 0;
		for (i in 0..._modsList.length)
		{
			if (!_modsList[int].contains(name))
			{
				_modsList1[i] = _modsList[int];
				int++;
			}
		}
		int = 0;
		FileAPI.file.saveFile('downloadList.txt', _modsList1.join('\n'));
		if (withClose)
		{
			funnyText.text = 'Successfully deleted ' + name + '!';
			new FlxTimer().start(1, function(tmr:FlxTimer) {
				exit();
			});
		}
	}
	function importMod()
	{
		var zipFilter:FileFilter = new FileFilter('ZIP', 'zip');
		_file = new FileReference();
		_file.addEventListener(Event.SELECT, onLoadComplete);
		_file.addEventListener(Event.CANCEL, onLoadCancel);
		_file.addEventListener(IOErrorEvent.IO_ERROR, onLoadError);
		_file.browse([zipFilter]);
	}
	function exportMod(name:String)
	{
		if (!FileAPI.file.exists('manifest/temp') && !FileAPI.file.isDir('manifest/temp'))
			FileAPI.file.createDir('manifest/temp');
		FileAPI.file.pack('mods/${name}', 'manifest/temp/${name}.zip', true, true);
		var data:ByteArray = ByteArray.fromFile('manifest/temp/${name}.zip');
		if ((data != null) && (data.length > 0))
		{
			_file = new FileReference();
			_file.addEventListener(Event.SELECT, onSaveComplete);
			_file.addEventListener(Event.CANCEL, onSaveCancel);
			_file.addEventListener(IOErrorEvent.IO_ERROR, onSaveError);
			_file.save(data, '${name}.zip');
			FileAPI.file.deleteFiles('manifest/temp');
			FileAPI.file.deleteDir('manifest/temp');
		}
	}
	function findPACK(folder:String)
	{
		//trace(folder);
		if (!FileAPI.file.exists(folder + '/pack.json'))
		{
			var dir = FileAPI.file.readDir(folder);
			for (i in 0...dir.length)
				if (FileAPI.file.isDir(folder + '/' + dir[i]))
					if (findPACK(folder + '/' + dir[i]) != null)
						return folder + '/' + dir[i];
			return null;
		}
		else
			return folder;
	}
	function onLoadCancel(_):Void
	{
		_file.removeEventListener(Event.SELECT, onLoadComplete);
		_file.removeEventListener(Event.CANCEL, onLoadCancel);
		_file.removeEventListener(IOErrorEvent.IO_ERROR, onLoadError);
		_file = null;
		trace("Cancelled importing mod.");
		funnyText.text = 'Cancelled importing mod.';
		new FlxTimer().start(1, function(tmr:FlxTimer) {
			exit();
		});
		if (FileAPI.file.exists('manifest/temp') && FileAPI.file.isDir('manifest/temp'))
		{
			FileAPI.file.deleteFiles('manifest/temp');
			FileAPI.file.deleteDir('manifest/temp');
		}
	}
	function onLoadComplete(_):Void
	{
		_file.removeEventListener(Event.SELECT, onLoadComplete);
		_file.removeEventListener(Event.CANCEL, onLoadCancel);
		_file.removeEventListener(IOErrorEvent.IO_ERROR, onLoadError);

		@:privateAccess var fullPath:String = _file.__path;
		inputPath.text = fullPath;
		inputPath.caretIndex += fullPath.length;
		_file = null;
	}
	function onLoadError(_):Void
	{
		_file.removeEventListener(Event.SELECT, onLoadComplete);
		_file.removeEventListener(Event.CANCEL, onLoadCancel);
		_file.removeEventListener(IOErrorEvent.IO_ERROR, onLoadError);
		_file = null;
		trace("Error importing mod.");
		funnyText.text = 'Error importing mod.';
		new FlxTimer().start(1, function(tmr:FlxTimer) {
			exit();
		});
		if (FileAPI.file.exists('manifest/temp') && FileAPI.file.isDir('manifest/temp'))
		{
			FileAPI.file.deleteFiles('manifest/temp');
			FileAPI.file.deleteDir('manifest/temp');
		}
	}

	function onSaveComplete(_):Void
	{
		_file.removeEventListener(Event.SELECT, onSaveComplete);
		_file.removeEventListener(Event.CANCEL, onSaveCancel);
		_file.removeEventListener(IOErrorEvent.IO_ERROR, onSaveError);
		_file = null;
		funnyText.text = 'Successfully exported ' + name + '!';
		new FlxTimer().start(1, function(tmr:FlxTimer) {
			exit();
		});
		if (FileAPI.file.exists('manifest/temp') && FileAPI.file.isDir('manifest/temp'))
		{
			FileAPI.file.deleteFiles('manifest/temp');
			FileAPI.file.deleteDir('manifest/temp');
		}
	}
	function onSaveCancel(_):Void
	{
		_file.removeEventListener(Event.COMPLETE, onSaveComplete);
		_file.removeEventListener(Event.CANCEL, onSaveCancel);
		_file.removeEventListener(IOErrorEvent.IO_ERROR, onSaveError);
		_file = null;
		trace("Cancelled exporting mod.");
		funnyText.text = 'Cancelled exporting mod.';
		new FlxTimer().start(1, function(tmr:FlxTimer) {
			exit();
		});
		if (FileAPI.file.exists('manifest/temp') && FileAPI.file.isDir('manifest/temp'))
		{
			FileAPI.file.deleteFiles('manifest/temp');
			FileAPI.file.deleteDir('manifest/temp');
		}
	}
	function onSaveError(_):Void
	{
		_file.removeEventListener(Event.COMPLETE, onSaveComplete);
		_file.removeEventListener(Event.CANCEL, onSaveCancel);
		_file.removeEventListener(IOErrorEvent.IO_ERROR, onSaveError);
		_file = null;
		trace("Error exporting mod.");
		funnyText.text = 'Error exporting mod.';
		new FlxTimer().start(1, function(tmr:FlxTimer) {
			exit();
		});
		if (FileAPI.file.exists('manifest/temp') && FileAPI.file.isDir('manifest/temp'))
		{
			FileAPI.file.deleteFiles('manifest/temp');
			FileAPI.file.deleteDir('manifest/temp');
		}
	}
}
