package;

import flixel.FlxG;
import flixel.FlxSprite;

using StringTools;

class StrumNote extends FlxSprite
{
	private var colorSwap:ColorSwap;
	public var resetAnim:Float = 0;
	private var noteData:Int = 0;
	public var direction:Float = 30;//plan on doing scroll directions soon -bb

	public var mania:Int = 1;

	private var player:Int;

	private var skinThing:Array<String> = ['static', 'pressed'];
	
	public var texture(default, set):String = null;
	private function set_texture(value:String):String {
		if(texture != value) {
			texture = value;
			reloadNote();
		}
		return value;
	}

	public function new(x:Float, y:Float, leData:Int, player:Int) {
		colorSwap = new ColorSwap();
		shader = colorSwap.shader;
		noteData = leData;
		this.player = player;
		this.noteData = leData;
		super(x, y);

		var stat:String = Note.NoteData.getAnimation(Note.NoteData.getKeyMap(PlayState.mania, leData, 1), 0);
		var pres:String = Note.NoteData.getLetter(Note.NoteData.getKeyMap(PlayState.mania, leData, 0));
		skinThing[0] = stat;
		skinThing[1] = pres;

		var skin:String = 'NOTE_assets';
		if(PlayState.isPixelStage) skin = 'PIXEL_' + skin;
		if(PlayState.SONG.arrowSkin != null && PlayState.SONG.arrowSkin.length > 1) skin = PlayState.SONG.arrowSkin;
		texture = skin; //Load texture and anims

		scrollFactor.set();
	}

	public function reloadNote()
	{
		var lastAnim:String = null;
		if(animation.curAnim != null) lastAnim = animation.curAnim.name;

		frames = Paths.getSparrowAtlas(texture);

		antialiasing = ClientPrefs.globalAntialiasing;

		setGraphicSize(Std.int(width * Note.NoteData.getScale(PlayState.mania)));

		animation.addByPrefix('static', 'arrow' + skinThing[0]);
		animation.addByPrefix('pressed', skinThing[1] + ' press', 24, false);
		animation.addByPrefix('confirm', skinThing[1] + ' confirm', 24, false);

		updateHitbox();

		if(lastAnim != null)
		{
			playAnim(lastAnim, true);
		}
	}

	public function postAddedToGroup() {
		playAnim('static');
		switch (PlayState.mania)
		{
			case 1 | 2 | 3:
				x += width * noteData;
			case 4:
				x += (Note.swagWidth * noteData);
			default:
				x += ((width - Note.NoteData.getLessXStrumNote(PlayState.mania)) * noteData);
		}

		x += Note.NoteData.getXtraX(PlayState.mania);
	
		//trace((width * Note.NoteData.getScale(PlayState.SONG.mania)) * noteData);
		x += 50;
		x += ((FlxG.width / 2) * player);
		ID = noteData;
		
		//trace(width);
	
		x -= Note.NoteData.getRestPosition(PlayState.mania);
	
		//if (PlayState.mania == 8 || PlayState.mania == 7 || PlayState.mania == 6)
		//	x -= 25;
	}

	override function update(elapsed:Float) {
		if(resetAnim > 0) {
			resetAnim -= elapsed;
			if(resetAnim <= 0) {
				playAnim('static');
				resetAnim = 0;
			}
		}
		if(animation.curAnim != null){ //my bad i was upset
			if(animation.curAnim.name == 'confirm' && !PlayState.isPixelStage) {
				centerOrigin();
			}
		}

		super.update(elapsed);
	}

	public function playAnim(anim:String, ?force:Bool = false) {
		animation.play(anim, force);
		centerOffsets();
		centerOrigin();
		if(animation.curAnim == null || animation.curAnim.name == 'static') {
			colorSwap.hue = 0;
			colorSwap.saturation = 0;
			colorSwap.brightness = 0;
		} else {
			colorSwap.hue = ClientPrefs.arrowHSV[Note.NoteData.getKeyMap(PlayState.mania, noteData, 0) % Note.NoteData.getAmmo(PlayState.mania)][0] / 360;
			colorSwap.saturation = ClientPrefs.arrowHSV[Note.NoteData.getKeyMap(PlayState.mania, noteData, 0) % Note.NoteData.getAmmo(PlayState.mania)][1] / 100;
			colorSwap.brightness = ClientPrefs.arrowHSV[Note.NoteData.getKeyMap(PlayState.mania, noteData, 0) % Note.NoteData.getAmmo(PlayState.mania)][2] / 100;

			if(animation.curAnim.name == 'confirm' && !PlayState.isPixelStage) {
				centerOrigin();
			}
		}
	}
}
