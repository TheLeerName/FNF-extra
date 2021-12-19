package;

import Controls.Control;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.addons.transition.FlxTransitionableState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.input.keyboard.FlxKey;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.FlxCamera;
import flixel.math.FlxMath;

class PauseSubState extends MusicBeatSubstate
{
	var grpMenuShit:FlxTypedGroup<Alphabet>;

	var menuItems:Array<String> = [];
	var menuItemsOG:Array<String> = [];
	var difficultyChoices = [];
	var curSelected:Int = 0;
	var nullDiff:Bool = CoolUtil.parseDiffNames(Paths.formatToSongPath(PlayState.SONG.song), PlayState.storyDifficulty) == '' ? true : false;

	var pauseMusic:FlxSound;
	var practiceText:FlxText;
	//var botplayText:FlxText;
	var laneunderlayThing:FlxText;
	var scrollspeedThing:FlxText;

	public static var transCamera:FlxCamera;

	public function new(x:Float, y:Float)
	{
		super();

		if (nullDiff)
			menuItemsOG = ['Resume', 'Restart Song', /*'Toggle Practice Mode', 'Botplay',*/ 'Exit to menu'];
		else
			menuItemsOG = ['Resume', 'Restart Song', 'Change Difficulty', /*'Toggle Practice Mode', 'Botplay',*/ 'Exit to menu'];
		menuItems = menuItemsOG;

		for (i in 0...CoolUtil.parseDiffCount(Paths.formatToSongPath(PlayState.SONG.song))) {
			var diff:String = '' + CoolUtil.parseDiffNames(Paths.formatToSongPath(PlayState.SONG.song), i);
			difficultyChoices.push(diff);
		}
		difficultyChoices.push('BACK');

		pauseMusic = new FlxSound().loadEmbedded(Paths.music('breakfast'), true, true);
		pauseMusic.volume = 0;
		pauseMusic.play(false, FlxG.random.int(0, Std.int(pauseMusic.length / 2)));

		FlxG.sound.list.add(pauseMusic);

		var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		bg.alpha = 0;
		bg.scrollFactor.set();
		add(bg);

		var levelInfo:FlxText = new FlxText(20, 15, 0, "", 32);
		levelInfo.text += PlayState.SONG.song;
		levelInfo.scrollFactor.set();
		levelInfo.setFormat(Paths.font("vcr.ttf"), 32);
		levelInfo.updateHitbox();
		add(levelInfo);

		var levelDifficulty:FlxText = new FlxText(20, 15 + 32, 0, "", 32);
		levelDifficulty.text += CoolUtil.parseDiffNames(Paths.formatToSongPath(PlayState.SONG.song), PlayState.storyDifficulty);
		levelDifficulty.scrollFactor.set();
		levelDifficulty.setFormat(Paths.font('vcr.ttf'), 32);
		levelDifficulty.updateHitbox();
		add(levelDifficulty);

		var blueballedTxt:FlxText = new FlxText(20, 15 + 64, 0, "", 32);
		blueballedTxt.text = "Blueballed: " + PlayState.deathCounter;
		blueballedTxt.scrollFactor.set();
		blueballedTxt.setFormat(Paths.font('vcr.ttf'), 32);
		blueballedTxt.updateHitbox();
		add(blueballedTxt);

		practiceText = new FlxText(20, 15 + 101, 0, "PRACTICE MODE", 32);
		practiceText.scrollFactor.set();
		practiceText.setFormat(Paths.font('vcr.ttf'), 32);
		practiceText.x = FlxG.width - (practiceText.width + 20);
		practiceText.updateHitbox();
		practiceText.visible = PlayState.instance.practiceMode;
		add(practiceText);

		/*botplayText = new FlxText(20, FlxG.height - 40, 0, "BOTPLAY", 32);
		botplayText.scrollFactor.set();
		botplayText.setFormat(Paths.font('vcr.ttf'), 32);
		botplayText.x = FlxG.width - (botplayText.width + 20);
		botplayText.updateHitbox();
		botplayText.visible = PlayState.cpuControlled;
		add(botplayText);*/

		blueballedTxt.alpha = 0;
		levelDifficulty.alpha = 0;
		levelInfo.alpha = 0;

		levelInfo.x = FlxG.width - (levelInfo.width + 20);
		levelDifficulty.x = FlxG.width - (levelDifficulty.width + 20);
		blueballedTxt.x = FlxG.width - (blueballedTxt.width + 20);

		if (nullDiff)
		{
			blueballedTxt.y = 15 + 32;
			practiceText.y = 15 + 69;

			FlxTween.tween(bg, {alpha: 0.6}, 0.4, {ease: FlxEase.quartInOut});
			FlxTween.tween(levelInfo, {alpha: 1, y: 20}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.3});
			FlxTween.tween(blueballedTxt, {alpha: 1, y: blueballedTxt.y + 5}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.5});
		}
		else
		{
			FlxTween.tween(bg, {alpha: 0.6}, 0.4, {ease: FlxEase.quartInOut});
			FlxTween.tween(levelInfo, {alpha: 1, y: 20}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.3});
			FlxTween.tween(levelDifficulty, {alpha: 1, y: levelDifficulty.y + 5}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.5});
			FlxTween.tween(blueballedTxt, {alpha: 1, y: blueballedTxt.y + 5}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.7});
		}

		FlxTween.tween(bg, {alpha: 0.6}, 0.4, {ease: FlxEase.quartInOut});
		FlxTween.tween(levelInfo, {alpha: 1, y: 20}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.3});
		FlxTween.tween(levelDifficulty, {alpha: 1, y: levelDifficulty.y + 5}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.5});
		FlxTween.tween(blueballedTxt, {alpha: 1, y: blueballedTxt.y + 5}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.7});

		grpMenuShit = new FlxTypedGroup<Alphabet>();
		add(grpMenuShit);

		var funnyThing:FlxText = new FlxText(5, 18, 0, "Hello chat", 12);
		funnyThing.scrollFactor.set();
		funnyThing.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(funnyThing);

		laneunderlayThing = new FlxText(5, 38, 0, "Lane Underlay (Press Shift and Left or Right): " + ClientPrefs.laneUnderlay + "%", 12);
		laneunderlayThing.scrollFactor.set();
		laneunderlayThing.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(laneunderlayThing);

		scrollspeedThing = new FlxText(5, 58, 0, "Scroll Speed (Press Ctrl and Left or Right): " + FlxMath.roundDecimal(ClientPrefs.speed, 2), 12);
		scrollspeedThing.scrollFactor.set();
		scrollspeedThing.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(scrollspeedThing);

		for (i in 0...menuItems.length)
		{
			var songText:Alphabet = new Alphabet(0, (70 * i) + 30, menuItems[i], true, false);
			songText.isMenuItem = true;
			songText.targetY = i;
			grpMenuShit.add(songText);
		}

		changeSelection();

		ClientPrefs.speed = FlxMath.roundDecimal(PlayState.instance.songSpeed, 2);

		cameras = [FlxG.cameras.list[FlxG.cameras.list.length - 1]];
	}

	var holdTime:Float = 0;
	override function update(elapsed:Float)
	{
		if (pauseMusic.volume < 0.5)
			pauseMusic.volume += 0.01 * elapsed;

		super.update(elapsed);

		if (controls.UI_LEFT || controls.UI_RIGHT)
		{
			var add:Int = controls.UI_LEFT ? -1 : 1;
			if(holdTime > 0.5 || controls.UI_LEFT_P || controls.UI_RIGHT_P)
			{
				var mult:Int = 1;

				if (FlxG.keys.pressed.SHIFT)
				{
					if(holdTime > 1) mult = 2; // x2 speed after 1 second holding
					ClientPrefs.laneUnderlay += add * mult;
					if (ClientPrefs.laneUnderlay < 0) ClientPrefs.laneUnderlay = 0;
					else if (ClientPrefs.laneUnderlay > 100) ClientPrefs.laneUnderlay = 100;

					PlayState.laneunderlayOpponent.alpha = ClientPrefs.laneUnderlay / 100;
					PlayState.laneunderlay.alpha = ClientPrefs.laneUnderlay / 100;
					FlxG.save.data.laneUnderlay = ClientPrefs.laneUnderlay;
					FlxG.save.flush();
					laneunderlayThing.text = "Lane Underlay (Press Shift and Left or Right): " + ClientPrefs.laneUnderlay + "%";
				}
				else if (FlxG.keys.pressed.CONTROL)
				{
					if(holdTime > 1) mult = 4; // x4 speed after 1 second holding
					ClientPrefs.speed += (add * mult)/100;
					if (ClientPrefs.speed < 0.01) ClientPrefs.speed = 0.01;
					else if (ClientPrefs.speed > 10) ClientPrefs.speed = 10;

					PlayState.instance.songSpeed = FlxMath.roundDecimal(ClientPrefs.speed, 2);
					PlayState.instance.optionsWatermark.text =
						  (ClientPrefs.ghostTapping ? "GhosTap | " : "")
						+ (ClientPrefs.kadeInput ? "KadeInput | " : "")
						+ (FlxMath.roundDecimal(ClientPrefs.speed, 2) == FlxMath.roundDecimal(PlayState.instance.songSpeed_stat, 2) ? "Speed " + FlxMath.roundDecimal(PlayState.instance.songSpeed_stat, 2)
						: "Speed " + FlxMath.roundDecimal(ClientPrefs.speed, 2) + " (" + FlxMath.roundDecimal(PlayState.instance.songSpeed_stat, 2) + ")");
					scrollspeedThing.text = "Scroll Speed (Press Ctrl and Left or Right): " + FlxMath.roundDecimal(ClientPrefs.speed, 2);
				}
			}
			holdTime += elapsed;
		} else holdTime = 0;

		if (controls.UI_UP_P) changeSelection(-1);
		if (controls.UI_DOWN_P) changeSelection(1);

		if (controls.ACCEPT)
		{
			var daSelected:String = menuItems[curSelected];
			for (i in 0...difficultyChoices.length-1) {
				if(difficultyChoices[i] == daSelected) {
					var name:String = PlayState.SONG.song.toLowerCase();
					var poop = Highscore.formatSong(name, curSelected);
					PlayState.SONG = Song.loadFromJson(poop, name);
					PlayState.storyDifficulty = curSelected;
					CustomFadeTransition.nextCamera = transCamera;
					MusicBeatState.resetState();
					FlxG.sound.music.volume = 0;
					//PlayState.changedDifficulty = true;
					//PlayState.cpuControlled = false;
					return;
				}
			} 

			switch (daSelected)
			{
				case "Resume":
					close();
					MusicBeatState.canFullScreen = false;
				case 'Change Difficulty':
					menuItems = difficultyChoices;
					regenMenu();
				/*case 'Toggle Practice Mode':
					PlayState.practiceMode = !PlayState.practiceMode;
					PlayState.usedPractice = true;
					practiceText.visible = PlayState.practiceMode;*/
				case "Restart Song":
					CustomFadeTransition.nextCamera = transCamera;
					MusicBeatState.resetState();
					FlxG.sound.music.volume = 0;
					MusicBeatState.canFullScreen = false;
				/*case 'Botplay':
					PlayState.cpuControlled = !PlayState.cpuControlled;
					PlayState.usedPractice = true;
					botplayText.visible = PlayState.cpuControlled;*/
				case "Exit to menu":
					PlayState.deathCounter = 0;
					PlayState.seenCutscene = false;
					CustomFadeTransition.nextCamera = transCamera;
					/*if(PlayState.isStoryMode)
						MusicBeatState.switchState(new StoryMenuState());
					else*/
						MusicBeatState.switchState(new FreeplayState());
					FlxG.sound.playMusic(Paths.music('freakyMenu'));
					MusicBeatState.canFullScreen = true;
					/*PlayState.usedPractice = false;
					PlayState.changedDifficulty = false;
					PlayState.cpuControlled = false;*/

				case 'BACK':
					menuItems = menuItemsOG;
					regenMenu();
			}
		}
	}

	override function destroy()
	{
		pauseMusic.destroy();

		super.destroy();
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
			// item.setGraphicSize(Std.int(item.width * 0.8));

			if (item.targetY == 0)
			{
				item.alpha = 1;
				// item.setGraphicSize(Std.int(item.width));
			}
		}
	}

	function regenMenu():Void {
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
