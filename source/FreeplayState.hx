package;

import lime.app.Application;
import openfl.utils.Future;
import openfl.media.Sound;
import flixel.system.FlxSound;
#if sys
import smTools.SMFile;
import sys.FileSystem;
import sys.io.File;
#end
import Song.SwagSong;
import flixel.input.gamepad.FlxGamepad;
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
#if windows
import Discord.DiscordClient;
#end

using StringTools;

typedef SongData =
{
	var difficultyCount:Int;
}

class FreeplayState extends MusicBeatState
{
	public static var songs:Array<SongMetadata> = [];

	var selector:FlxText;
	public static var curSelected:Int = 0;
	public static var curDifficulty:Int = 0;
	var difficultyCount_primary:SongData;
	var difficultyName_primary:Array<String>;
	public static var difficultyCount:Int = 3; // var reduction part 1 (without this, var = difficultyCount.difficultyCount, lol)
	public static var difficultyName:String = "EASY";

	var playMusic:Bool = false;
	public static var chartingFromFreeplay:Bool = false;

	var scoreText:FlxText;
	var comboText:FlxText;
	var diffText:FlxText;
	public static var diffCalcText:FlxText;
	var previewtext:FlxText;
	var lerpScore:Int = 0;
	var intendedScore:Int = 0;
	var combo:String = '';

	private var grpSongs:FlxTypedGroup<Alphabet>;
	private var curPlaying:Bool = false;

	private var iconArray:Array<HealthIcon> = [];

	public static var openedPreview = false;

	public static var songData:Map<String,Array<SwagSong>> = [];

	public static function loadDiff(diff:Int, format:String, name:String, array:Array<SwagSong>)
	{
		try 
		{
			array.push(Song.loadFromJson(Highscore.formatSong(format, diff), name));
		}
		catch(ex)
		{
			// do nada
		}
	}

	override function create()
	{
		clean();

		if (!FlxG.sound.music.playing && !playMusic)
		{
			FlxG.sound.playMusic(Paths.music('freakyMenu'));
		}

		var initSonglist = CoolUtil.coolTextFile(Paths.txt('data/freeplaySonglist'));

		//var diffList = "";

		songData = [];
		songs = [];

		for (i in 0...initSonglist.length)
		{
			var data:Array<String> = initSonglist[i].split(':');
			var meta = new SongMetadata(data[0], Std.parseInt(data[2]), data[1]);
			var format = StringTools.replace(meta.songName, " ", "-");
			switch (format) {
				case 'Dad-Battle': format = 'Dadbattle';
				case 'Philly-Nice': format = 'Philly';
			}

			var diffs = [];
			var diffsThatExist = [];


			#if sys
			if (FileSystem.exists('assets/data/${format}/${format}-1.json'))
				diffsThatExist.push("1");
			if (FileSystem.exists('assets/data/${format}/${format}-2.json'))
				diffsThatExist.push("2");

			if (FileSystem.exists('assets/data/${format}/${format}-3.json'))
				diffsThatExist.push("3");
			if (FileSystem.exists('assets/data/${format}/${format}-4.json'))
				diffsThatExist.push("4");

			if (FileSystem.exists('assets/data/${format}/${format}-5.json'))
				diffsThatExist.push("5");
			if (FileSystem.exists('assets/data/${format}/${format}-6.json'))
				diffsThatExist.push("6");

			if (FileSystem.exists('assets/data/${format}/${format}-7.json'))
				diffsThatExist.push("7");
			if (FileSystem.exists('assets/data/${format}/${format}-8.json'))
				diffsThatExist.push("8");

			if (FileSystem.exists('assets/data/${format}/${format}-9.json'))
				diffsThatExist.push("9");
			if (FileSystem.exists('assets/data/${format}/${format}-10.json'))
				diffsThatExist.push("10");

			if (diffsThatExist.length == 0)
			{
				Application.current.window.alert("No difficulties found for chart, skipping.",meta.songName + " Chart");
				continue;
			}
			#else
			diffsThatExist = [/*"Easy",*/"1","2","3","4","5","6","7","8","9","10"];
			#end
			if (diffsThatExist.contains("1"))
				FreeplayState.loadDiff(0,format,meta.songName,diffs);
			if (diffsThatExist.contains("2"))
				FreeplayState.loadDiff(1,format,meta.songName,diffs);

			if (diffsThatExist.contains("3"))
				FreeplayState.loadDiff(2,format,meta.songName,diffs);
			if (diffsThatExist.contains("4"))
				FreeplayState.loadDiff(3,format,meta.songName,diffs);

			if (diffsThatExist.contains("5"))
				FreeplayState.loadDiff(4,format,meta.songName,diffs);
			if (diffsThatExist.contains("6"))
				FreeplayState.loadDiff(5,format,meta.songName,diffs);

			if (diffsThatExist.contains("7"))
				FreeplayState.loadDiff(6,format,meta.songName,diffs);
			if (diffsThatExist.contains("8"))
				FreeplayState.loadDiff(7,format,meta.songName,diffs);

			if (diffsThatExist.contains("9"))
				FreeplayState.loadDiff(8,format,meta.songName,diffs);
			if (diffsThatExist.contains("10"))
				FreeplayState.loadDiff(9,format,meta.songName,diffs);


			meta.diffs = diffsThatExist;

			//if (diffsThatExist.length != 10)
				//trace("I ONLY FOUND " + diffsThatExist);

			FreeplayState.songData.set(meta.songName,diffs);
			trace('loaded diffs for ' + meta.songName);
			songs.push(meta);
		}

		trace("tryin to load sm files");

		#if sys
		for(i in FileSystem.readDirectory("assets/sm/"))
		{
			trace(i);
			if (FileSystem.isDirectory("assets/sm/" + i))
			{
				trace("Reading SM file dir " + i);
				for (file in FileSystem.readDirectory("assets/sm/" + i))
				{
					if (file.contains(" "))
						FileSystem.rename("assets/sm/" + i + "/" + file,"assets/sm/" + i + "/" + file.replace(" ","_"));
					if (file.endsWith(".sm"))
					{
						trace("reading " + file);
						var file:SMFile = SMFile.loadFile("assets/sm/" + i + "/" + file.replace(" ","_"));
						trace("Converting " + file.header.TITLE);
						var data = file.convertToFNF("assets/sm/" + i + "/converted.json");
						var meta = new SongMetadata(file.header.TITLE, 0, "sm",file,"assets/sm/" + i);
						songs.push(meta);
						var song = Song.loadFromJsonRAW(data);
						songData.set(file.header.TITLE, [song,song,song]);
					}
				}
			}
		}
		#end

		//trace("\n" + diffList);

		/* 
			if (FlxG.sound.music != null)
			{
				if (!FlxG.sound.music.playing)
					FlxG.sound.playMusic(Paths.music('freakyMenu'));
			}
		 */

		 #if windows
		 // Updating Discord Rich Presence
		 DiscordClient.changePresence("In the Freeplay Menu", null);
		 #end

		var isDebug:Bool = false;

		#if debug
		isDebug = true;
		#end

		persistentUpdate = true;

		// LOAD MUSIC

		// LOAD CHARACTERS

		var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menuBGBlue'));
		bg.antialiasing = FlxG.save.data.antialiasing;
		add(bg);

		grpSongs = new FlxTypedGroup<Alphabet>();
		add(grpSongs);

		for (i in 0...songs.length)
		{
			var songText:Alphabet = new Alphabet(0, (70 * i) + 30, songs[i].songName, true, false, true);
			songText.isMenuItem = true;
			songText.targetY = i;
			grpSongs.add(songText);

			var icon:HealthIcon = new HealthIcon(songs[i].songCharacter);
			icon.sprTracker = songText;

			// using a FlxGroup is too much fuss!
			iconArray.push(icon);
			add(icon);

			// songText.x += 40;
			// DONT PUT X IN THE FIRST PARAMETER OF new ALPHABET() !!
			// songText.screenCenter(X);
		}

		scoreText = new FlxText(FlxG.width * 0.7, 5, 0, "", 32);
		// scoreText.autoSize = false;
		scoreText.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, RIGHT);
		// scoreText.alignment = RIGHT;

		var scoreBG:FlxSprite = new FlxSprite(scoreText.x - 6, 0).makeGraphic(Std.int(FlxG.width * 0.35), 105, 0xFF000000);
		scoreBG.alpha = 0.6;
		add(scoreBG);

		diffText = new FlxText(scoreText.x, scoreText.y + 36, 0, "", 24);
		diffText.font = scoreText.font;
		add(diffText);

		diffCalcText = new FlxText(scoreText.x, scoreText.y + 66, 0, "", 24);
		diffCalcText.font = scoreText.font;
		add(diffCalcText);

		previewtext = new FlxText(scoreText.x, scoreText.y + 94, 0, "" + (KeyBinds.gamepad ? "X" : "SPACE") + " to preview", 24);
		previewtext.font = scoreText.font;
		//add(previewtext);

		comboText = new FlxText(diffText.x + 100, diffText.y, 0, "", 24);
		comboText.font = diffText.font;
		add(comboText);

		add(scoreText);

		changeSelection();
		changeDiff();

		// FlxG.sound.playMusic(Paths.music('title'), 0);
		// FlxG.sound.music.fadeIn(2, 0, 0.8);
		selector = new FlxText();

		selector.size = 40;
		selector.text = ">";
		// add(selector);

		var swag:Alphabet = new Alphabet(1, 0, "swag");

		// JUST DOIN THIS SHIT FOR TESTING!!!
		/* 
			var md:String = Markdown.markdownToHtml(Assets.getText('CHANGELOG.md'));

			var texFel:TextField = new TextField();
			texFel.width = FlxG.width;
			texFel.height = FlxG.height;
			// texFel.
			texFel.htmlText = md;

			FlxG.stage.addChild(texFel);

			// scoreText.textField.htmlText = md;

			trace(md);
		 */

		super.create();
	}

	public function addSong(songName:String, weekNum:Int, songCharacter:String)
	{
		songs.push(new SongMetadata(songName, weekNum, songCharacter));
	}

	public function addWeek(songs:Array<String>, weekNum:Int, ?songCharacters:Array<String>)
	{
		if (songCharacters == null)
			songCharacters = ['dad'];

		var num:Int = 0;
		for (song in songs)
		{
			addSong(song, weekNum, songCharacters[num]);

			if (songCharacters.length != 1)
				num++;
		}
	}
	
	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (FlxG.sound.music.volume < 0.7)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

		lerpScore = Math.floor(FlxMath.lerp(lerpScore, intendedScore, 0.4));

		if (Math.abs(lerpScore - intendedScore) <= 10)
			lerpScore = intendedScore;

		scoreText.text = "PERSONAL BEST:" + lerpScore;
		comboText.text = combo + '\n';

		if (FlxG.sound.music.volume > 0.8)
			FlxG.sound.music.volume -= 0.5 * FlxG.elapsed;

		var gamepad:FlxGamepad = FlxG.gamepads.lastActive;
		if (gamepad != null)
		{
			if (gamepad.justPressed.DPAD_UP) changeSelection(-1);
			if (gamepad.justPressed.DPAD_DOWN) changeSelection(1);
			if (gamepad.justPressed.DPAD_LEFT) changeDiff(-1);
			if (gamepad.justPressed.DPAD_RIGHT) changeDiff(1);

			//if (gamepad.justPressed.X && !openedPreview) openSubState(new DiffOverview());
		}

		if (controls.BACK) FlxG.switchState(new MainMenuState());

		if (FlxG.keys.justPressed.UP) changeSelection(-1);
		if (FlxG.keys.justPressed.DOWN) changeSelection(1);
		if (FlxG.keys.justPressed.LEFT) changeDiff(-1);
		if (FlxG.keys.justPressed.RIGHT) changeDiff(1);

		if (FlxG.keys.justPressed.SPACE)
		{
			playMusic = !playMusic;
			if (playMusic)
				FlxG.sound.playMusic(Paths.inst(songs[curSelected].songName), 0);
			else
			{
				FlxG.sound.playMusic(Paths.music('freakyMenu'), 0);
			}
		}

		//if (FlxG.keys.justPressed.SPACE && !openedPreview) openSubState(new DiffOverview());

		if (FlxG.keys.justPressed.ENTER) loadSong(false);
		if (FlxG.keys.justPressed.SEVEN) loadSong(true);
	}

	function loadSong(isCharting:Bool = false)
	{
		// adjusting the song name to be compatible
		var songFormat = StringTools.replace(songs[curSelected].songName, " ", "-");
		switch (songFormat) {
			case 'Dad-Battle': songFormat = 'Dadbattle';
			case 'Philly-Nice': songFormat = 'Philly';
		}
		var hmm;
		try
		{
			hmm = songData.get(songs[curSelected].songName)[curDifficulty];
			if (hmm == null)
				return;
		}
		catch(ex)
		{
			return;
		}

		PlayState.SONG = Song.conversionChecks(hmm);
		PlayState.isStoryMode = false;
		PlayState.storyDifficulty = curDifficulty;
		PlayState.storyWeek = songs[curSelected].week;
		trace('CUR WEEK' + PlayState.storyWeek);
		#if sys
		if (songs[curSelected].songCharacter == "sm")
			{
				PlayState.isSM = true;
				PlayState.sm = songs[curSelected].sm;
				PlayState.pathToSm = songs[curSelected].path;
			}
		else
			PlayState.isSM = false;
		#else
		PlayState.isSM = false;
		#end

		if (isCharting)
		{
			LoadingState.loadAndSwitchState(new ChartingState());
			chartingFromFreeplay = true;
		}
		else
			LoadingState.loadAndSwitchState(new PlayState());
		clean();
	}

	function changeDiff(change:Int = 0)
	{
		//difficultyCount_primary = haxe.Json.parse(Assets.getText(Paths.json('${songs[curSelected].songName.toLowerCase()}/songData')));
		difficultyCount_primary = CoolUtil.parseSongJSON('${songs[curSelected].songName.toLowerCase()}/songData');
		difficultyCount = difficultyCount_primary.difficultyCount - 1;

		/*if (!songs[curSelected].diffs.contains(CoolUtil.difficultyFromInt(curDifficulty + change)))
			return;*/

		curDifficulty += change;

		if (curDifficulty < 0)
			curDifficulty = difficultyCount;
		if (curDifficulty > difficultyCount)
			curDifficulty = 0;

		difficultyName_primary = CoolUtil.coolTextFile(Paths.txt('data/${songs[curSelected].songName.toLowerCase()}/diffNames'));
		difficultyName = difficultyName_primary[curDifficulty];

		// adjusting the highscore song name to be compatible (changeDiff)
		var songHighscore = StringTools.replace(songs[curSelected].songName, " ", "-");
		switch (songHighscore) {
			case 'Dad-Battle': songHighscore = 'Dadbattle';
			case 'Philly-Nice': songHighscore = 'Philly';
		}

		#if !switch
		intendedScore = Highscore.getScore(songHighscore, curDifficulty);
		combo = Highscore.getCombo(songHighscore, curDifficulty);
		#end
		diffCalcText.text = 'RATING: ${DiffCalc.CalculateDiff(songData.get(songs[curSelected].songName)[curDifficulty])}';

		//diffText.text = CoolUtil.difficultyFromInt(curDifficulty).toUpperCase();
		trace((curDifficulty + 1) + " | " + (difficultyCount + 1));
		diffText.text = difficultyName.toUpperCase() + " (" + (curDifficulty + 1) + "/" + (difficultyCount + 1) + ")";
	}

	function changeSelection(change:Int = 0)
	{
		FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);

		// error message
		if (difficultyCount < 1 || difficultyCount > 9)
		{
			trace
			(
				"diff count is "
				+ difficultyCount
				+ ", its " + (difficultyCount > 9 ? "more than 10" : "less than 1")
				+ " lol! starting error window..."
			);
			Application.current.window.alert
			(
				"Value of difficulty count is "
				+ difficultyCount
				+ ", its " + (difficultyCount > 9 ? "more than 10!" : "less than 1!")
				+ " Try putting a value between 1 and 10."

				, "DIFFICULTY SYSTEM ERROR"
			);

			FlxG.switchState(new MainMenuState());
			return;
		}
		curDifficulty = 0;

		curSelected += change;

		if (curSelected < 0)
			curSelected = songs.length - 1;
		if (curSelected >= songs.length)
			curSelected = 0;

		//difficultyCount_primary = haxe.Json.parse(Assets.getText(Paths.json('${songs[curSelected].songName.toLowerCase()}/songData')));
		difficultyCount_primary = CoolUtil.parseSongJSON('${songs[curSelected].songName.toLowerCase()}/songData');
		difficultyCount = difficultyCount_primary.difficultyCount - 1;

		difficultyName_primary = CoolUtil.coolTextFile(Paths.txt('data/${songs[curSelected].songName.toLowerCase()}/diffNames'));
		difficultyName = difficultyName_primary[curDifficulty];

		trace((curDifficulty + 1) + " | " + (difficultyCount + 1));
		diffText.text = difficultyName.toUpperCase() + " (" + (curDifficulty + 1) + "/" + (difficultyCount + 1) + ")";

		/*if (songs[curSelected].diffs.length != 3)
		{
			switch(songs[curSelected].diffs[0])
			{
				case "1":
					curDifficulty = 0;
				case "2":
					curDifficulty = 1;
				case "3":
					curDifficulty = 2;
				case "4":
					curDifficulty = 3;
				case "5":
					curDifficulty = 4;
				case "6":
					curDifficulty = 5;
				case "7":
					curDifficulty = 6;
				case "8":
					curDifficulty = 7;
				case "9":
					curDifficulty = 8;
				case "10":
					curDifficulty = 9;
			}
		}*/

		// selector.y = (70 * curSelected) + 30;

		// adjusting the highscore song name to be compatible (changeSelection)
		// would read original scores if we didn't change packages
		var songHighscore = StringTools.replace(songs[curSelected].songName, " ", "-");
		switch (songHighscore) {
			case 'Dad-Battle': songHighscore = 'Dadbattle';
			case 'Philly-Nice': songHighscore = 'Philly';
		}

		#if !switch
		intendedScore = Highscore.getScore(songHighscore, curDifficulty);
		combo = Highscore.getCombo(songHighscore, curDifficulty);
		// lerpScore = 0;
		#end

		diffCalcText.text = 'RATING: ${DiffCalc.CalculateDiff(songData.get(songs[curSelected].songName)[curDifficulty])}';
		//diffText.text = CoolUtil.difficultyFromInt(curDifficulty).toUpperCase();

		#if PRELOAD_ALL
		if (songs[curSelected].songCharacter == "sm")
		{
			var data = songs[curSelected];
			trace("Loading " + data.path + "/" + data.sm.header.MUSIC);
			var bytes = File.getBytes(data.path + "/" + data.sm.header.MUSIC);
			var sound = new Sound();
			sound.loadCompressedDataFromByteArray(bytes.getData(), bytes.length);
			FlxG.sound.playMusic(sound);
		}
		else if (playMusic)
			FlxG.sound.playMusic(Paths.inst(songs[curSelected].songName), 0);
		#end

		var hmm;
			try
			{
				hmm = songData.get(songs[curSelected].songName)[curDifficulty];
				if (hmm != null)
					Conductor.changeBPM(hmm.bpm);
			}
			catch(ex)
			{}

		if (openedPreview)
		{
			closeSubState();
			openSubState(new DiffOverview());
		}

		var bullShit:Int = 0;

		for (i in 0...iconArray.length)
		{
			iconArray[i].alpha = 0.6;
		}

		iconArray[curSelected].alpha = 1;

		for (item in grpSongs.members)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;

			item.alpha = 0.6;
			// item.setGraphicSize(Std.int(item.width * 0.8));

			if (item.targetY == 0)
			{
				item.alpha = 1;
				// item.setGraphicSize(Std.int(item.width));
			}
		}
	}
}

class SongMetadata
{
	public var songName:String = "";
	public var week:Int = 0;
	#if sys
	public var sm:SMFile;
	public var path:String;
	#end
	public var songCharacter:String = "";

	public var diffs = [];

	#if sys
	public function new(song:String, week:Int, songCharacter:String, ?sm:SMFile = null, ?path:String = "")
	{
		this.songName = song;
		this.week = week;
		this.songCharacter = songCharacter;
		this.sm = sm;
		this.path = path;
	}
	#else
	public function new(song:String, week:Int, songCharacter:String)
	{
		this.songName = song;
		this.week = week;
		this.songCharacter = songCharacter;
	}
	#end
}
