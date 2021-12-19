package;

import flixel.FlxG;
import flixel.FlxSprite;

class NoteSplash extends FlxSprite
{
	public var colorSwap:ColorSwap = null;
	private var idleAnim:String;
	private var textureLoaded:String = null;

	var sc:Array<Float> = [0, 1.3, 1.2, 1.1, 1, 1, 0.9, 0.8, 0.7, 0.6, 0.5];

	public function new(x:Float = 0, y:Float = 0, ?note:Int = 0) {
		super(x, y);

		var skin:String = 'noteSplashes';
		if(PlayState.SONG.splashSkin != null && PlayState.SONG.splashSkin.length > 0) skin = PlayState.SONG.splashSkin;

		loadAnims(skin);
		
		colorSwap = new ColorSwap();
		shader = colorSwap.shader;

		setupNoteSplash(x, y, note);
		antialiasing = ClientPrefs.globalAntialiasing;
	}

	public function setupNoteSplash(x:Float, y:Float, note:Int = 0, texture:String = null, hueColor:Float = 0, satColor:Float = 0, brtColor:Float = 0) {
		setPosition(x - Note.swagWidth * 0.95, y - Note.swagWidth);
		setGraphicSize(Std.int(width * sc[PlayState.mania]));

		alpha = 0.6;

		if(texture == null) {
			texture = 'noteSplashes';
			if(PlayState.SONG.splashSkin != null && PlayState.SONG.splashSkin.length > 0) texture = PlayState.SONG.splashSkin;
		}

		if(textureLoaded != texture) {
			loadAnims(texture);
		}
		colorSwap.hue = hueColor;
		colorSwap.saturation = satColor;
		colorSwap.brightness = brtColor;

		var animNum:Int = FlxG.random.int(1, 2);
		if (animNum == 1) setPosition(x - (Note.swagWidth * 0.95) + 10 * (sc[PlayState.mania]), y - (Note.swagWidth) + 10 * (sc[PlayState.mania]));

		offset.set(10, 10);

		animation.play('note' + Note.NoteData.getKeyMap(PlayState.mania, note, 0) + '-' + animNum, true);
		if(animation.curAnim != null)animation.curAnim.frameRate = 24 + FlxG.random.int(-2, 2);
	}

	function loadAnims(skin:String) {
		frames = Paths.getSparrowAtlas(skin);
		for (i in 1...3) {
			animation.addByPrefix('note0-' + i, 'note splash A ' + i, 24, false);
			animation.addByPrefix('note1-' + i, 'note splash B ' + i, 24, false);
			animation.addByPrefix('note2-' + i, 'note splash C ' + i, 24, false);
			animation.addByPrefix('note3-' + i, 'note splash D ' + i, 24, false);
			animation.addByPrefix('note4-' + i, 'note splash E ' + i, 24, false);
			animation.addByPrefix('note5-' + i, 'note splash F ' + i, 24, false);
			animation.addByPrefix('note6-' + i, 'note splash G ' + i, 24, false);
			animation.addByPrefix('note7-' + i, 'note splash H ' + i, 24, false);
			animation.addByPrefix('note8-' + i, 'note splash I ' + i, 24, false);
			animation.addByPrefix('note9-' + i, 'note splash E ' + i, 24, false);
		}
	}

	override function update(elapsed:Float) {
		if(animation.curAnim != null)if(animation.curAnim.finished) kill();

		super.update(elapsed);
	}
}