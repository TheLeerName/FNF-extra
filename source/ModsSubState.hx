package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.text.FlxText;
import flixel.util.FlxTimer;
import flixel.addons.transition.FlxTransitionableState;

import openfl.net.FileReference;
import openfl.net.FileFilter;
import openfl.events.Event;
import openfl.events.IOErrorEvent;
import openfl.utils.ByteArray;

using StringTools;
	
class ModsSubState extends MusicBeatSubstate
{
	var bg:FlxSprite;
	var funnyText:FlxText;
	var mode:Int;
	var name:String;

	var path:String = DownloadsMenuState.path;

	public function new(name_:String, mode_:Int)
	{
		super();
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

	function exit()
	{
		FlxTween.tween(funnyText, {alpha: 0}, 0.4, {ease: FlxEase.quartInOut});
		FlxTween.tween(bg, {alpha: 0}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.3, onComplete: function(twn:FlxTween) {
			close();
			FlxG.switchState(new ModsMenuState());
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
	function copyFolder(to_folder:String, from_folder:String)
	{
		if (!FileAPI.file.exists(to_folder) && !FileAPI.file.isDir(to_folder))
			FileAPI.file.createDir(to_folder);
		for (entry in FileAPI.file.readDir(from_folder))
		{
			//trace(from_folder + '/' + entry);
			if (!FileAPI.file.isDir(from_folder + '/' + entry))
				FileAPI.file.copy(to_folder + '/' + entry, from_folder + '/' + entry);
			else
				copyFolder(to_folder + '/' + entry, from_folder + '/' + entry);
		}
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

		var fullPath:String = null;
		@:privateAccess
		if (_file.__path != null) fullPath = _file.__path;
		if (!FileAPI.file.exists('manifest/temp') && !FileAPI.file.isDir('manifest/temp'))
			FileAPI.file.createDir('manifest/temp');
		FileAPI.file.unpack(fullPath, 'manifest/temp/import');
		var paththree:String = findPACK('manifest/temp/import');
		if (paththree == null)
		{
			trace("Error importing mod: Not found pack.json");
			_file = null;
			FileAPI.file.deleteFiles('manifest/temp');
			FileAPI.file.deleteDir('manifest/temp');
			funnyText.text = 'Error importing mod: Not found pack.json.';
			new FlxTimer().start(1, function(tmr:FlxTimer) {
				exit();
			});
			return;
		}
		FileAPI.file.deleteFile(fullPath);
		var modname = FileAPI.file.parseJSON(paththree + '/pack.json').name;
		copyFolder('mods/' + modname, paththree);
		_file = null;
		FileAPI.file.deleteFiles('manifest/temp');
		FileAPI.file.deleteDir('manifest/temp');
		funnyText.text = 'Successfully imported ' + modname + '!';
		new FlxTimer().start(1, function(tmr:FlxTimer) {
			exit();
		});
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
