package;

import flixel.input.keyboard.FlxKey;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.math.FlxMath;
import flixel.util.FlxColor;
import flash.display.BitmapData;
import editors.ChartingState;

using StringTools;

class Note extends FlxSprite
{
	public var strumTime:Float = 0;

	public var mustPress:Bool = false;
	public var noteData:Int = 0;
	public var canBeHit:Bool = false;
	public var tooLate:Bool = false;
	public var wasGoodHit:Bool = false;
	public var ignoreNote:Bool = false;
	public var hitByOpponent:Bool = false;
	public var noteWasHit:Bool = false;
	public var prevNote:Note;

	public var sustainLength:Float = 0;
	public var isSustainNote:Bool = false;
	public var noteType(default, set):String = null;

	public var eventName:String = '';
	public var eventLength:Int = 0;
	public var eventVal1:String = '';
	public var eventVal2:String = '';

	public var colorSwap:ColorSwap;
	public var inEditor:Bool = false;
	private var earlyHitMult:Float = 0.5;

	public static var swagWidth:Float = 160 * 0.7;
	public static var PURP_NOTE:Int = 0;
	public static var GREEN_NOTE:Int = 2;
	public static var BLUE_NOTE:Int = 1;
	public static var RED_NOTE:Int = 3;

	// Lua shit
	public var noteSplashDisabled:Bool = false;
	public var noteSplashTexture:String = null;
	public var noteSplashHue:Float = 0;
	public var noteSplashSat:Float = 0;
	public var noteSplashBrt:Float = 0;

	public var offsetX:Float = 0;
	public var offsetY:Float = 0;
	public var offsetAngle:Float = 0;
	public var multAlpha:Float = 1;

	public var copyX:Bool = true;
	public var copyY:Bool = true;
	public var copyAngle:Bool = true;
	public var copyAlpha:Bool = true;

	public var hitHealth:Float = 0.023;
	public var missHealth:Float = 0.0475;

	public var texture(default, set):String = null;

	public var noAnimation:Bool = false;
	public var hitCausesMiss:Bool = false;
	public var distance:Float = 2000;//plan on doing scroll directions soon -bb

	public var mania:Int = 1;

	var ogW:Float;
	var ogH:Float;

	var defaultWidth:Float = 0;
	var defaultHeight:Float = 0;

	private function set_texture(value:String):String {
		if(texture != value) {
			reloadNote('', value);
		}
		texture = value;
		return value;
	}

	private function set_noteType(value:String):String {
		noteSplashTexture = PlayState.SONG.splashSkin;
		colorSwap.hue = ClientPrefs.arrowHSV[Note.NoteData.getKeyMap(PlayState.mania, noteData, 0) % Note.NoteData.getAmmo(PlayState.mania)][0] / 360;
		colorSwap.saturation = ClientPrefs.arrowHSV[Note.NoteData.getKeyMap(PlayState.mania, noteData, 0) % Note.NoteData.getAmmo(PlayState.mania)][1] / 100;
		colorSwap.brightness = ClientPrefs.arrowHSV[Note.NoteData.getKeyMap(PlayState.mania, noteData, 0) % Note.NoteData.getAmmo(PlayState.mania)][2] / 100;

		if(noteData > -1 && noteType != value) {
			switch(value) {
				case 'Hurt Note':
					ignoreNote = mustPress;
					reloadNote('HURT');
					noteSplashTexture = 'HURTnoteSplashes';
					colorSwap.hue = 0;
					colorSwap.saturation = 0;
					colorSwap.brightness = 0;
					if(isSustainNote) {
						missHealth = 0.1;
					} else {
						missHealth = 0.3;
					}
					hitCausesMiss = true;
				case 'No Animation':
					noAnimation = true;
			}
			noteType = value;
		}
		noteSplashHue = colorSwap.hue;
		noteSplashSat = colorSwap.saturation;
		noteSplashBrt = colorSwap.brightness;
		return value;
	}

	public function new(strumTime:Float, noteData:Int, ?prevNote:Note, ?sustainNote:Bool = false, ?inEditor:Bool = false)
	{
		super();

		if (prevNote == null)
			prevNote = this;

		this.prevNote = prevNote;
		isSustainNote = sustainNote;
		this.inEditor = inEditor;

		x += (ClientPrefs.middleScroll ? PlayState.STRUM_X_MIDDLESCROLL : PlayState.STRUM_X) + 50;
		// MAKE SURE ITS DEFINITELY OFF SCREEN?
		y -= 2000;
		this.strumTime = strumTime;
		if(!inEditor) this.strumTime += ClientPrefs.noteOffset;

		this.noteData = noteData;

		if(noteData > -1) {
			texture = '';
			colorSwap = new ColorSwap();
			shader = colorSwap.shader;

			x += swagWidth * (noteData % 4);
			if(!isSustainNote) { //Doing this 'if' check to fix the warnings on Senpai songs
				var animToPlay:String = '';
				animToPlay = Note.NoteData.getLetter(Note.NoteData.getKeyMap(PlayState.mania, noteData, 0));
				animation.play(animToPlay);
			}
		}

		// trace(prevNote);

		if (isSustainNote && prevNote != null)
		{
			alpha = 0.6;
			multAlpha = 0.6;
			if(ClientPrefs.downScroll) flipY = true;

			offsetX += width / 2;
			copyAngle = false;

			animation.play(Note.NoteData.getLetter(Note.NoteData.getKeyMap(PlayState.mania, noteData, 0)) + ' tail');

			updateHitbox();

			offsetX -= width / 2;

			//if (PlayState.isPixelStage)
				//offsetX += 30;

			if (prevNote.isSustainNote)
			{
				prevNote.animation.play(Note.NoteData.getLetter(Note.NoteData.getKeyMap(PlayState.mania, noteData, 0)) + ' hold');

				prevNote.scale.y *= Conductor.stepCrochet / 100 * 1.05;
				if(PlayState.instance != null)
				{
					prevNote.scale.y *= PlayState.instance.songSpeed;
				}

				//if(PlayState.isPixelStage) { no.
				//	prevNote.scale.y *= 1.19;
				//}
				prevNote.updateHitbox();
				// prevNote.setGraphicSize();
			}

			if(PlayState.isPixelStage) {
				//scale.y *= PlayState.daPixelZoom;
				updateHitbox();
			}
		} else if(!isSustainNote) {
			earlyHitMult = 1;
		}
		x += offsetX;
	}

	function reloadNote(?prefix:String = '', ?texture:String = '', ?suffix:String = '') {
		if(prefix == null) prefix = '';
		if(texture == null) texture = '';
		if(suffix == null) suffix = '';
		
		var skin:String = texture;
		if(texture.length < 1) {
			skin = PlayState.SONG.arrowSkin;
			if(skin == null || skin.length < 1) {
				skin = 'NOTE_assets';
			}
			if(PlayState.isPixelStage) {
				skin = 'PIXEL_'+skin;
			}
		}

		var animName:String = null;
		if(animation.curAnim != null) {
			animName = animation.curAnim.name;
		}

		var arraySkin:Array<String> = skin.split('/');
		arraySkin[arraySkin.length-1] = prefix + arraySkin[arraySkin.length-1] + suffix;

		var lastScaleY:Float = scale.y;
		var blahblah:String = arraySkin.join('/');
		frames = Paths.getSparrowAtlas(blahblah);

		defaultWidth = 157;
		defaultHeight = 154;

		loadNoteAnims();
		antialiasing = ClientPrefs.globalAntialiasing;
		if(isSustainNote) {
			scale.y = lastScaleY;
			if(ClientPrefs.keSustains) {
				scale.y *= 0.75;
			}
		}
		updateHitbox();

		if(animName != null)
			animation.play(animName, true);

		if(inEditor) {
			setGraphicSize(ChartingState.GRID_SIZE, ChartingState.GRID_SIZE);
			updateHitbox();
		}
	}

	function loadNoteAnims() {
		for (i in 0...9)
			{
				animation.addByPrefix(Note.NoteData.getLetter(i), Note.NoteData.getLetter(i) + '0');
	
				if (isSustainNote)
				{
					animation.addByPrefix(Note.NoteData.getLetter(i) + ' hold', Note.NoteData.getLetter(i) + ' hold');
					animation.addByPrefix(Note.NoteData.getLetter(i) + ' tail', Note.NoteData.getLetter(i) + ' tail');
				}
			}
				
			ogW = width;
			ogH = height;
			if (!isSustainNote)
				setGraphicSize(Std.int(defaultWidth * Note.NoteData.getScale(PlayState.mania)));
			else
				setGraphicSize(Std.int(defaultWidth * Note.NoteData.getScale(PlayState.mania)), Std.int(defaultHeight * Note.NoteData.getScale(0)));
			updateHitbox();
	}

	function loadPixelNoteAnims() {
		if(isSustainNote) {
			animation.add('purpleholdend', [PURP_NOTE + 4]);
			animation.add('greenholdend', [GREEN_NOTE + 4]);
			animation.add('redholdend', [RED_NOTE + 4]);
			animation.add('blueholdend', [BLUE_NOTE + 4]);

			animation.add('purplehold', [PURP_NOTE]);
			animation.add('greenhold', [GREEN_NOTE]);
			animation.add('redhold', [RED_NOTE]);
			animation.add('bluehold', [BLUE_NOTE]);
		} else {
			animation.add('greenScroll', [GREEN_NOTE + 4]);
			animation.add('redScroll', [RED_NOTE + 4]);
			animation.add('blueScroll', [BLUE_NOTE + 4]);
			animation.add('purpleScroll', [PURP_NOTE + 4]);
		}
	}

	public function applyManiaChange()
	{
		loadNoteAnims();
		if (!isSustainNote)
		{
			var animToPlay:String = '';
			animToPlay = Note.NoteData.getLetter(Note.NoteData.getKeyMap(PlayState.mania, noteData, 0));
			animation.play(animToPlay);
		}

		if (isSustainNote && prevNote != null)
		{
			animation.play(Note.NoteData.getLetter(Note.NoteData.getKeyMap(PlayState.mania, noteData, 0)) + ' tail');
			if (prevNote.isSustainNote)
			{
				prevNote.animation.play(Note.NoteData.getLetter(Note.NoteData.getKeyMap(PlayState.mania, noteData, 0)) + ' hold');
				prevNote.updateHitbox();
			}
		}

		updateHitbox();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (mustPress)
		{
			// ok river
			if (strumTime > Conductor.songPosition - Conductor.safeZoneOffset
				&& strumTime < Conductor.songPosition + (Conductor.safeZoneOffset * earlyHitMult))
				canBeHit = true;
			else
				canBeHit = false;

			if (strumTime < Conductor.songPosition - Conductor.safeZoneOffset && !wasGoodHit)
				tooLate = true;
		}
		else
		{
			canBeHit = false;

			if (strumTime <= Conductor.songPosition)
				wasGoodHit = true;
		}

		if (tooLate && !inEditor)
		{
			if (alpha > 0.3)
				alpha = 0.3;
		}
	}
}

class NoteData
{
    public static var keyMaps:Map<Int, Array<Dynamic>> = [
        1       =>      [[4], [4]],
        2       =>      [[0, 3], [0, 3]],
        3       =>      [[0, 4, 3], [0, 4, 3]],
        4       =>      [[0, 1, 2, 3], [0, 1, 2, 3]],
        5       =>      [[0, 1, 4, 2, 3], [0, 1, 4, 2, 3]],
        6       =>      [[0, 2, 3, 5, 1, 8], [0, 2, 3, 0, 1, 3]],
        7       =>      [[0, 2, 3, 4, 5, 1, 8], [0, 2, 3, 4, 0, 1, 3]],
        8       =>      [[0, 1, 2, 3, 5, 6, 7, 8], [0, 1, 2, 3, 0, 1, 2, 3]],
        9       =>      [[0, 1, 2, 3, 4, 5, 6, 7, 8], [0, 1, 2, 3, 4, 0, 1, 2, 3]]
    ];

    public static function getKeyMap(mania:Int, key:Int, type:Int):Int
    {
        return keyMaps.get(mania)[type][key];
    }

    public static function getAmmo(mania:Int)
    {
		mania--;
        var ammo:Array<Int> = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];

		return ammo[mania];
    }

	public static function getAnimation(data:Int, type:Int) {
		var gfxDir:Array<String> = ['LEFT', 'DOWN', 'UP', 'RIGHT', 'SPACE'];
		var charDir:Array<String> = ['LEFT', 'DOWN', 'UP', 'RIGHT', 'UP'];

		var str:String = '';
		switch(type)
		{
			case 0:
				str = gfxDir[data];
			case 1:
				str = charDir[data];
		}

		return str;
	}

	public static function getLetter(data:Int) {
		var gfxLetter:Array<String> = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I'];

		return gfxLetter[data];
	}

	public static function getScale(mania:Int) {
		mania--;
		var scales:Array<Float> = [0.9, 0.85, 0.8, 0.7, 0.66, 0.6, 0.55, 0.50, 0.46, 0.39];

		return scales[mania];
	}

	public static function getSwagWidth(mania:Int) {
		mania--;
		var swidths:Array<Float> = [141, 124, 116, 108, 102, 93, 85, 77, 71, 60];

		return swidths[mania];
	}

	public static function getRestPosition(mania:Int) {
		mania--;
		var posRest:Array<Int> = [0, 0, 0, 0, 25, 32, 46, 52, 60, 65];

		return posRest[mania];
	}

	public static function getLessXStrumNote(mania:Int) {
		mania--;
		var lessX:Array<Int> = [0, 0, 0, 0, 0, 8, 7, 8, 8, 7];

		return lessX[mania];
	}

	public static function getXtraX(mania:Int) {
		mania--;
		var xtra:Array<Int> = [150, 89, 0, 0, 0, 0, 0, 0, 0, 0];

		return xtra[mania];
	}

	public static function getMiddleScrollSeparator(mania:Int) {
		mania--;
		var separator:Array<Int> = [0, 0, 1, 1, 2, 2, 2, 3, 3, 4];

		return separator[mania];
	}

	public static function getGridSize(mania:Int) {
		mania--;
		var gridSizes:Array<Int> = [40, 40, 40, 40, 40, 40, 40, 40, 40, 35];

		return gridSizes[mania];
	}
}