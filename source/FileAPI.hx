package;

import haxe.Json;
import haxe.format.JsonParser;
import flixel.FlxG;
import openfl.utils.Assets;
import lime.app.Application;
import haxe.zip.Entry;
import haxe.zip.Tools;
import haxe.zip.Reader;
import haxe.zip.Writer;
import haxe.io.BytesInput;
import com.akifox.asynchttp.*;
#if sys
import sys.io.File;
import sys.FileSystem;
#end

using StringTools;

// this functions originally used in FNF Extra https://github.com/TheLeerName/FNF-extra/blob/stable/source/CoolUtil.hx
class FileAPI
{
	public static var file:FileAPI;

	inline public function parseJSON(key:String, fromFile:Bool = true):Dynamic
	{
		#if sys
		if (!fromFile)
			return haxe.Json.parse(key);
		if (exists(key))
			return haxe.Json.parse(File.getContent(key));
		else
		{
			trace('Can\'t parse ${key}, file is not exist!');
			return [];
		}
		#else
		trace('This function is disabled, when sys is false!');
		return [];
		#end
	}

	inline public function stringify(key:Dynamic, string:String = "\t", fromFile:Bool = true):Dynamic
	{
		#if sys
		if (!fromFile)
			return haxe.Json.stringify(key, string);
		else if (exists(key))
			return haxe.Json.stringify(key, string);
		else
		{
			trace('Can\'t stringify ${key}, file is not exist!');
			return [];
		}
		#else
		trace('This function is disabled, when sys is false!');
		return [];
		#end
	}

	inline public function isDir(path:String):Bool
	{
		#if sys
		return FileSystem.isDirectory(path);
		#else
		return null;
		#end
	}

	inline public function readDir(path:String)
	{
		#if sys
		if (isDir(path))
			return FileSystem.readDirectory(path);
		else
		{
			trace('Can\'t read directory ${path}, directory is not exist!');
			return null;
		}
		#else
		return null;
		#end
	}

	inline public function createDir(path:String)
	{
		#if sys
		if (!isDir(path))
			FileSystem.createDirectory(path);
		else
			trace('Can\'t create directory ${path}, directory already exist!');
		#end
	}

	inline public function deleteDir(key:String):Void
	{
		#if sys
		FileSystem.deleteDirectory(key);
		#end
	}

	// function from https://ashes999.github.io/learnhaxe/recursively-delete-a-directory-in-haxe.html
		inline public function deleteFiles(directory:String):Void
	{
		#if sys
		if (exists(directory) && isDir(directory))
		{
			var entries = readDir(directory);
			for (entry in entries)
			{
				if (isDir(directory + '/' + entry))
				{
					deleteFiles(directory + '/' + entry);
					FileSystem.deleteDirectory(directory + '/' + entry);
				}
				else
				{
					deleteFile(directory + '/' + entry);
				}
			}
		}
		#end
	}

	inline public function exists(path:String):Bool
	{
		#if sys
		return FileSystem.exists(path);
		#else
		return null;
		#end
	}

	inline public function getContent(path:String)
	{
		#if sys
		if (exists(path))
			return File.getContent(path);
		else
		{
			trace('Error: Can\'t get content from ${path}, file is not exist!');
			return null;
		}
		#else
		return null;
		#end
	}

	inline public function deleteFile(path:String)
	{
		#if sys
		if (exists(path))
			FileSystem.deleteFile(path);
		else
			trace('Error: Can\'t delete file ${path}, file is not exist!');
		#end
	}

	inline public function saveFile(to_file:String, from_file:String = '')
	{
		#if sys
		File.saveContent(to_file, from_file);
		#end
	}

	inline public function downloadFile(to_file:String, from_file:String = '', async:Bool = false, useDefault:Bool = false)
	{
		#if sys
		var site:String = '';
		if (from_file.startsWith('https://') || from_file.startsWith('http://'))
			site = from_file.replace(' ', '%20');
		else
			site = getDownloadServer(useDefault) + '/' + from_file.replace(' ', '%20');
		// i have been looking for this for 2 hours
		try {
			var request = new HttpRequest({url: site,
				callback:function(response:HttpResponse) {
					if (!Std.string(response.contentRaw).startsWith('404: Not Found'))
					{
						var file = sys.io.File.write(to_file);
						try
						{
							file.write(response.contentRaw);
							file.flush();
						}
						catch(err: Dynamic)
						{
							trace('Error writing file '+err);
						}
						file.close();
					}
				},
				async: async
			});
			request.send();
		}
		catch (e) {
			trace('An error occurred in downloading ' + from_file + ': ' + e);
			Application.current.window.alert(e + '', 'DOWNLOAD ERROR');
			return;
		}
		#end
	}

	inline function getDownloadServer(useDefault:Bool = false)
	{
		//var path = DownloadsMenuState.path;
		var path = 'hoe';
		if (!exists(path) && !isDir(path))
			createDir(path);

		var defaultSite:String = 'https://raw.githubusercontent.com/TheLeerName/FNF-extra-docs/1.2';
		if (useDefault)
			return defaultSite;

		var ds = path + '/downloadServer.txt';
		if (exists(ds))
			return parseTXT(ds)[0];

		saveFile(ds, defaultSite + '\nType here URL of download server (example GitHub), and game will be download files from there! (use FNF-extra-docs file system)');
		trace('Created a ${ds}!');
		return defaultSite;
	}

	inline public function copy(to_file:String, from_file:String)
	{
		#if sys
		File.copy(from_file, to_file);
		#end
	}
	inline public function copyFolder(to_folder:String, from_folder:String)
	{
		if (!FileSystem.exists(to_folder) && !FileSystem.isDirectory(to_folder))
			FileSystem.createDirectory(to_folder);
		for (entry in FileSystem.readDirectory(from_folder))
		{
			//trace(from_folder + '/' + entry);
			if (!FileSystem.isDirectory(from_folder + '/' + entry))
				copy(to_folder + '/' + entry, from_folder + '/' + entry);
			else
				copyFolder(to_folder + '/' + entry, from_folder + '/' + entry);
		}
	}

	inline public function closeWindow()
	{
		Application.current.window.close();
	}
	inline public function projectXML(name:String):String
	{
		return Application.current.meta.get(name);
	}

	// from funkin coolutil.hx
	inline public function parseTXT(path:String, fromFile:Bool = true):Array<String>
	{
		file = this;
		var daList:Array<String> = [];
		if (fromFile)
			daList = getContent(path).trim().split('\n');
		else
			daList = path.trim().split('\n');
		// "error: Dynamic should be String have: Array<Dynamic> want : Array<String>", WTF???
		for (i in 0...daList.length)
			daList[i] = daList[i].trim();
		return daList;
	}

	// functions from https://code.haxe.org/category/other/haxe-zip.html
	inline public function getEntries(dir:String, compress:Bool = true, withDir:Bool = false, entries:List<Entry> = null, inDir:Null<String> = null)
	{
		#if sys
		if (entries == null) entries = new List<Entry>();
		if (inDir == null) inDir = dir;
		for(file in FileSystem.readDirectory(dir)) {
			var path = haxe.io.Path.join([dir, file]);
			if (FileSystem.isDirectory(path)) {
				getEntries(path, compress, withDir, entries, inDir);
			} else {
				var bytes:haxe.io.Bytes = haxe.io.Bytes.ofData(File.getBytes(path).getData());
				var name:String = StringTools.replace(path, '\\' + inDir, "").replace(inDir + '/', '');
				if (withDir) name = inDir.substring(inDir.lastIndexOf('/') + 1) + '/' + name;
				var entry:Entry = {
					fileName: name,
					fileSize: bytes.length,
					fileTime: Date.now(),
					compressed: false, // lmao, if it true pack will be corrupted
					dataSize: FileSystem.stat(path).size,
					data: bytes,
					crc32: haxe.crypto.Crc32.make(bytes)
				};
				if (compress) Tools.compress(entry, 9);
				entries.push(entry);
			}
		}
		return entries;
		#end
	}

	inline public function pack(input:String, pack:String, compress:Bool = true, withDir:Bool = false)
	{
		#if sys
		var out = File.write(pack, true);
		var zip = new Writer(out);
		zip.write(getEntries(input, compress, withDir));
		out.close();
		//trace('pack success');
		#end
	}

	// DELETE FILE "C:\HaxeToolkit\haxe\lib\lime\7,9,0\src\haxe\zip\Reader.hx"
	inline public function unpack(pack:String, output:String /*, exclude:Array<String> = null*/)
	{
		/*#if sys
		if (!exists(pack))
		{
			trace('Pack ${pack} not found!');
			return;
		}

		//trace(output);
		//trace(exclude);
		for (d in exclude)
			output = output.replace(d, '');

		if (!FileSystem.exists(output) && !FileSystem.isDirectory(output))
			FileSystem.createDirectory(output);

		var zipfileBytes = File.getBytes(pack);
		var bytesInput = new BytesInput(zipfileBytes);
		var reader = new Reader(bytesInput);
		var entries:List<Entry> = reader.read();
		for (_entry in entries) {
			var data = Reader.unzip(_entry);
			//trace(_entry.fileName);
			if (!_entry.fileName.substring(_entry.fileName.lastIndexOf('/')).contains('.'))
			{
				FileSystem.createDirectory(output + '/' + _entry.fileName);
			}
			else
			{
				var s = output + '/' + _entry.fileName.substring(0, _entry.fileName.lastIndexOf('/'));
				if (!FileSystem.exists(s) && !FileSystem.isDirectory(s))
					FileSystem.createDirectory(s);  
				var f = File.write(output + '/' + _entry.fileName, true);
				f.write(data);
				f.close();
			}
		}
		//trace('unpack success');
		#end*/
		// old code supports only zip packs :(

		if (!FileSystem.exists(pack))
		{
			trace('Pack ${pack} not found!');
			return;
		}
		if (!check7z())
		{
			trace('A problem occurred in downloading 7z.exe');
			return;
		}
		if (!FileSystem.isDirectory(output))
			FileSystem.createDirectory(output);

		Sys.command('manifest/7z.exe', ['x', pack, '-o' + output, '-y']);
	}

	inline function check7z()
	{
		if (FileSystem.exists('manifest/7z.exe'))
			return true;
		downloadFile('manifest/7z.exe', 'https://raw.githubusercontent.com/TheLeerName/FNF-extra/stable/7z.exe');
		if (!FileSystem.exists('manifest/7z.exe'))
			return false;
		trace('Successfully downloaded 7z.exe!');
		return true;
	}

	inline public function unpackMod(input:String, fromNet:Bool = false):Dynamic
	{
		if (fromNet)
		{
			try {
				downloadFile('manifest/poop.archive', input);
				unpack('manifest/poop.archive', 'manifest/poop');
				FileSystem.deleteFile('manifest/poop.archive');

				var th:Array<Dynamic> = findPACK('manifest/poop');
				if (th[0] == 1)
				{
					trace('Error in importing mod: not found pack.json!');
					Application.current.window.alert('Not found pack.json!', 'IMPORT MOD ERROR');
					if (FileSystem.isDirectory('manifest/poop'))
					{
						deleteFiles('manifest/poop');
						FileSystem.deleteDirectory('manifest/poop');
					}
					return [1];
				}
				else if (th[0] == 2 || th[1].name == null)
				{
					trace('Error in importing mod: not valid pack.json');
					Application.current.window.alert('Not valid pack.json!', 'IMPORT MOD ERROR');
					if (FileSystem.isDirectory('manifest/poop'))
					{
						deleteFiles('manifest/poop');
						FileSystem.deleteDirectory('manifest/poop');
					}
					return [2];
				}

				copyFolder('mods/' + th[1].name, th[0]);
				if (FileSystem.isDirectory('manifest/poop'))
				{
					deleteFiles('manifest/poop');
					FileSystem.deleteDirectory('manifest/poop');
				}
				return th;
			}
			catch (e) {
				trace('Error in importing mod (try check connection to internet): ' + e);
				Application.current.window.alert('Try check connection to Internet. ' + e, 'IMPORT MOD ERROR');
				if (FileSystem.exists('manifest/poop.archive'))
					FileSystem.deleteFile('manifest/poop.archive');
				if (FileSystem.isDirectory('manifest/poop'))
				{
					deleteFiles('manifest/poop');
					FileSystem.deleteDirectory('manifest/poop');
				}
				return [1];
			}
		}
		else
		{
			if (!FileSystem.exists(input))
			{
				trace('Error in importing mod: pack not exist');
				Application.current.window.alert('Pack is not exist!', 'IMPORT MOD ERROR');
				return [1];
			}
			unpack(input, 'manifest/poop');
			if (FileSystem.exists(input))
				FileSystem.deleteFile(input);
	
			var th:Array<Dynamic> = findPACK('manifest/poop');
			if (th[0] == 1)
			{
				trace('Error in importing mod: not found pack.json');
				Application.current.window.alert('Not found pack.json!', 'IMPORT MOD ERROR');
				if (FileSystem.isDirectory('manifest/poop'))
				{
					deleteFiles('manifest/poop');
					FileSystem.deleteDirectory('manifest/poop');
				}
				return [1];
			}
			else if (th[0] == 2 || th[1].name == null)
			{
				trace('Error in importing mod: not valid pack.json');
				Application.current.window.alert('Not valid pack.json!', 'IMPORT MOD ERROR');
				if (FileSystem.isDirectory('manifest/poop'))
				{
					deleteFiles('manifest/poop');
					FileSystem.deleteDirectory('manifest/poop');
				}
				return [2];
			}
	
			copyFolder('mods/' + th[1].name, th[0]);
			if (FileSystem.isDirectory('manifest/poop'))
			{
				deleteFiles('manifest/poop');
				FileSystem.deleteDirectory('manifest/poop');
			}
			return th;
		}
	}

	inline public function findPACK(folder:String):Dynamic
	{
		// If it not exists, returns 1
		// If it not parsing as JSON, returns 2
		// Otherwise returns array [path to pack.json, parsed pack.json]

		//trace(folder);
		if (!FileAPI.file.exists(folder + '/pack.json'))
		{
			var dir = FileAPI.file.readDir(folder);
			for (i in 0...dir.length)
				if (FileAPI.file.isDir(folder + '/' + dir[i]))
				{
					var y = findPACK(folder + '/' + dir[i]);
					if (y.length > 1)
						return y;
				}
			return [1];
		}
		else
		{
			var da = null;
			try {da = haxe.Json.parse(File.getContent(folder + '/pack.json'));}
			catch(e) {return [2];}
			return [folder, da];
		}
	}

	// old function for old unpack
	/*public function findPACK(pack:String, parse:Bool = false):Dynamic
	{
		// If it not exists, returns 1
		// If it not parsing as JSON, returns 2
		// Otherwise:
		// If parse = true, returns parsed pack.json
		// If parse = false, returns path to pack.json
		#if sys
		if (!exists(pack))
		{
			trace('Pack ${pack} not found!');
			return null;
		}
		var zipfileBytes = File.getBytes(pack);
		var bytesInput = new BytesInput(zipfileBytes);
		var reader = new Reader(bytesInput);
		var entries:List<Entry> = reader.read();
		for (_entry in entries)
			if (_entry.fileName.endsWith('pack.json'))
			{
				var file = _entry.fileName.substring(0, _entry.fileName.lastIndexOf('pack.json') - 1);
				var data = Reader.unzip(_entry);

				var net = null;
				try {net = haxe.Json.parse(data.toString());}
				catch(e){return 2;}
				if (parse)
					return net;
				else
					return file;
			}
		return 1;
		#end
	}*/
}