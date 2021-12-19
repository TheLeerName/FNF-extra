package;

import flixel.FlxG;
import flixel.input.FlxInput;
import flixel.input.actions.FlxAction;
import flixel.input.actions.FlxActionInput;
import flixel.input.actions.FlxActionInputDigital;
import flixel.input.actions.FlxActionManager;
import flixel.input.actions.FlxActionSet;
import flixel.input.gamepad.FlxGamepadButton;
import flixel.input.gamepad.FlxGamepadInputID;
import flixel.input.keyboard.FlxKey;

#if (haxe >= "4.0.0")
enum abstract Action(String) to String from String
{
	var UI_UP = "ui_up";
	var UI_LEFT = "ui_left";
	var UI_RIGHT = "ui_right";
	var UI_DOWN = "ui_down";
	var UI_UP_P = "ui_up-press";
	var UI_LEFT_P = "ui_left-press";
	var UI_RIGHT_P = "ui_right-press";
	var UI_DOWN_P = "ui_down-press";
	var UI_UP_R = "ui_up-release";
	var UI_LEFT_R = "ui_left-release";
	var UI_RIGHT_R = "ui_right-release";
	var UI_DOWN_R = "ui_down-release";
	var NOTE_UP = "note_up";
	var NOTE_LEFT = "note_left";
	var NOTE_RIGHT = "note_right";
	var NOTE_DOWN = "note_down";
	var NOTE_UP_P = "note_up-press";
	var NOTE_LEFT_P = "note_left-press";
	var NOTE_RIGHT_P = "note_right-press";
	var NOTE_DOWN_P = "note_down-press";
	var NOTE_UP_R = "note_up-release";
	var NOTE_LEFT_R = "note_left-release";
	var NOTE_RIGHT_R = "note_right-release";
	var NOTE_DOWN_R = "note_down-release";
	var ACCEPT = "accept";
	var BACK = "back";
	var PAUSE = "pause";
	var RESET = "reset";

	var ONE1 = 'one1';
	var ONE1_P = 'one1-press';
	var ONE1_R = 'one1-release';

	var TWO1 = 'two1';
	var TWO1_P = 'two1-press';
	var TWO1_R = 'two1-release';
	var TWO2 = 'two2';
	var TWO2_P = 'two2-press';
	var TWO2_R = 'two2-release';

	var THREE1 = 'three1';
	var THREE1_P = 'three1-press';
	var THREE1_R = 'three1-release';
	var THREE2 = 'three2';
	var THREE2_P = 'three2-press';
	var THREE2_R = 'three2-release';
	var THREE3 = 'three3';
	var THREE3_P = 'three3-press';
	var THREE3_R = 'three3-release';

	var FIVE1 = 'five1';
	var FIVE1_P = 'five1-press';
	var FIVE1_R = 'five1-release';
	var FIVE2 = 'five2';
	var FIVE2_P = 'five2-press';
	var FIVE2_R = 'five2-release';
	var FIVE3 = 'five3';
	var FIVE3_P = 'five3-press';
	var FIVE3_R = 'five3-release';
	var FIVE4 = 'five4';
	var FIVE4_P = 'five4-press';
	var FIVE4_R = 'five4-release';
	var FIVE5 = 'five5';
	var FIVE5_P = 'five5-press';
	var FIVE5_R = 'five5-release';

	var SIX1 = 'six1';
	var SIX1_P = 'six1-press';
	var SIX1_R = 'six1-release';
	var SIX2 = 'six2';
	var SIX2_P = 'six2-press';
	var SIX2_R = 'six2-release';
	var SIX3 = 'six3';
	var SIX3_P = 'six3-press';
	var SIX3_R = 'six3-release';
	var SIX4 = 'six4';
	var SIX4_P = 'six4-press';
	var SIX4_R = 'six4-release';
	var SIX5 = 'six5';
	var SIX5_P = 'six5-press';
	var SIX5_R = 'six5-release';
	var SIX6 = 'six6';
	var SIX6_P = 'six6-press';
	var SIX6_R = 'six6-release';

	var SEVEN1 = 'seven1';
	var SEVEN1_P = 'seven1-press';
	var SEVEN1_R = 'seven1-release';
	var SEVEN2 = 'seven2';
	var SEVEN2_P = 'seven2-press';
	var SEVEN2_R = 'seven2-release';
	var SEVEN3 = 'seven3';
	var SEVEN3_P = 'seven3-press';
	var SEVEN3_R = 'seven3-release';
	var SEVEN4 = 'seven4';
	var SEVEN4_P = 'seven4-press';
	var SEVEN4_R = 'seven4-release';
	var SEVEN5 = 'seven5';
	var SEVEN5_P = 'seven5-press';
	var SEVEN5_R = 'seven5-release';
	var SEVEN6 = 'seven6';
	var SEVEN6_P = 'seven6-press';
	var SEVEN6_R = 'seven6-release';
	var SEVEN7 = 'seven7';
	var SEVEN7_P = 'seven7-press';
	var SEVEN7_R = 'seven7-release';

	var EIGHT1 = 'eight1';
	var EIGHT1_P = 'eight1-press';
	var EIGHT1_R = 'eight1-release';
	var EIGHT2 = 'eight2';
	var EIGHT2_P = 'eight2-press';
	var EIGHT2_R = 'eight2-release';
	var EIGHT3 = 'eight3';
	var EIGHT3_P = 'eight3-press';
	var EIGHT3_R = 'eight3-release';
	var EIGHT4 = 'eight4';
	var EIGHT4_P = 'eight4-press';
	var EIGHT4_R = 'eight4-release';
	var EIGHT5 = 'eight5';
	var EIGHT5_P = 'eight5-press';
	var EIGHT5_R = 'eight5-release';
	var EIGHT6 = 'eight6';
	var EIGHT6_P = 'eight6-press';
	var EIGHT6_R = 'eight6-release';
	var EIGHT7 = 'eight7';
	var EIGHT7_P = 'eight7-press';
	var EIGHT7_R = 'eight7-release';
	var EIGHT8 = 'eight8';
	var EIGHT8_P = 'eight8-press';
	var EIGHT8_R = 'eight8-release';

	var NINE1 = 'nine1';
	var NINE1_P = 'nine1-press';
	var NINE1_R = 'nine1-release';
	var NINE2 = 'nine2';
	var NINE2_P = 'nine2-press';
	var NINE2_R = 'nine2-release';
	var NINE3 = 'nine3';
	var NINE3_P = 'nine3-press';
	var NINE3_R = 'nine3-release';
	var NINE4 = 'nine4';
	var NINE4_P = 'nine4-press';
	var NINE4_R = 'nine4-release';
	var NINE5 = 'nine5';
	var NINE5_P = 'nine5-press';
	var NINE5_R = 'nine5-release';
	var NINE6 = 'nine6';
	var NINE6_P = 'nine6-press';
	var NINE6_R = 'nine6-release';
	var NINE7 = 'nine7';
	var NINE7_P = 'nine7-press';
	var NINE7_R = 'nine7-release';
	var NINE8 = 'nine8';
	var NINE8_P = 'nine8-press';
	var NINE8_R = 'nine8-release';
	var NINE9 = 'nine9';
	var NINE9_P = 'nine9-press';
	var NINE9_R = 'nine9-release';

	/*var TEN1 = 'ten1';
	var TEN1_P = 'ten1-press';
	var TEN1_R = 'ten1-release';
	var TEN2 = 'ten2';
	var TEN2_P = 'ten2-press';
	var TEN2_R = 'ten2-release';
	var TEN3 = 'ten3';
	var TEN3_P = 'ten3-press';
	var TEN3_R = 'ten3-release';
	var TEN4 = 'ten4';
	var TEN4_P = 'ten4-press';
	var TEN4_R = 'ten4-release';
	var TEN5 = 'ten5';
	var TEN5_P = 'ten5-press';
	var TEN5_R = 'ten5-release';
	var TEN6 = 'ten6';
	var TEN6_P = 'ten6-press';
	var TEN6_R = 'ten6-release';
	var TEN7 = 'ten7';
	var TEN7_P = 'ten7-press';
	var TEN7_R = 'ten7-release';
	var TEN8 = 'ten8';
	var TEN8_P = 'ten8-press';
	var TEN8_R = 'ten8-release';
	var TEN9 = 'ten9';
	var TEN9_P = 'ten9-press';
	var TEN9_R = 'ten9-release';
	var TEN10 = 'ten10';
	var TEN10_P = 'ten10-press';
	var TEN10_R = 'ten10-release';*/
}
#else
@:enum
abstract Action(String) to String from String
{
	var UI_UP = "ui_up";
	var UI_LEFT = "ui_left";
	var UI_RIGHT = "ui_right";
	var UI_DOWN = "ui_down";
	var UI_UP_P = "ui_up-press";
	var UI_LEFT_P = "ui_left-press";
	var UI_RIGHT_P = "ui_right-press";
	var UI_DOWN_P = "ui_down-press";
	var UI_UP_R = "ui_up-release";
	var UI_LEFT_R = "ui_left-release";
	var UI_RIGHT_R = "ui_right-release";
	var UI_DOWN_R = "ui_down-release";
	var NOTE_UP = "note_up";
	var NOTE_LEFT = "note_left";
	var NOTE_RIGHT = "note_right";
	var NOTE_DOWN = "note_down";
	var NOTE_UP_P = "note_up-press";
	var NOTE_LEFT_P = "note_left-press";
	var NOTE_RIGHT_P = "note_right-press";
	var NOTE_DOWN_P = "note_down-press";
	var NOTE_UP_R = "note_up-release";
	var NOTE_LEFT_R = "note_left-release";
	var NOTE_RIGHT_R = "note_right-release";
	var NOTE_DOWN_R = "note_down-release";
	var ACCEPT = "accept";
	var BACK = "back";
	var PAUSE = "pause";
	var RESET = "reset";

	var ONE1 = 'one1';
	var ONE1_P = 'one1-press';
	var ONE1_R = 'one1-release';

	var TWO1 = 'two1';
	var TWO1_P = 'two1-press';
	var TWO1_R = 'two1-release';
	var TWO2 = 'two2';
	var TWO2_P = 'two2-press';
	var TWO2_R = 'two2-release';

	var THREE1 = 'three1';
	var THREE1_P = 'three1-press';
	var THREE1_R = 'three1-release';
	var THREE2 = 'three2';
	var THREE2_P = 'three2-press';
	var THREE2_R = 'three2-release';
	var THREE3 = 'three3';
	var THREE3_P = 'three3-press';
	var THREE3_R = 'three3-release';

	var FIVE1 = 'five1';
	var FIVE1_P = 'five1-press';
	var FIVE1_R = 'five1-release';
	var FIVE2 = 'five2';
	var FIVE2_P = 'five2-press';
	var FIVE2_R = 'five2-release';
	var FIVE3 = 'five3';
	var FIVE3_P = 'five3-press';
	var FIVE3_R = 'five3-release';
	var FIVE4 = 'five4';
	var FIVE4_P = 'five4-press';
	var FIVE4_R = 'five4-release';
	var FIVE5 = 'five5';
	var FIVE5_P = 'five5-press';
	var FIVE5_R = 'five5-release';

	var SIX1 = 'six1';
	var SIX1_P = 'six1-press';
	var SIX1_R = 'six1-release';
	var SIX2 = 'six2';
	var SIX2_P = 'six2-press';
	var SIX2_R = 'six2-release';
	var SIX3 = 'six3';
	var SIX3_P = 'six3-press';
	var SIX3_R = 'six3-release';
	var SIX4 = 'six4';
	var SIX4_P = 'six4-press';
	var SIX4_R = 'six4-release';
	var SIX5 = 'six5';
	var SIX5_P = 'six5-press';
	var SIX5_R = 'six5-release';
	var SIX6 = 'six6';
	var SIX6_P = 'six6-press';
	var SIX6_R = 'six6-release';

	var SEVEN1 = 'seven1';
	var SEVEN1_P = 'seven1-press';
	var SEVEN1_R = 'seven1-release';
	var SEVEN2 = 'seven2';
	var SEVEN2_P = 'seven2-press';
	var SEVEN2_R = 'seven2-release';
	var SEVEN3 = 'seven3';
	var SEVEN3_P = 'seven3-press';
	var SEVEN3_R = 'seven3-release';
	var SEVEN4 = 'seven4';
	var SEVEN4_P = 'seven4-press';
	var SEVEN4_R = 'seven4-release';
	var SEVEN5 = 'seven5';
	var SEVEN5_P = 'seven5-press';
	var SEVEN5_R = 'seven5-release';
	var SEVEN6 = 'seven6';
	var SEVEN6_P = 'seven6-press';
	var SEVEN6_R = 'seven6-release';
	var SEVEN7 = 'seven7';
	var SEVEN7_P = 'seven7-press';
	var SEVEN7_R = 'seven7-release';

	var EIGHT1 = 'eight1';
	var EIGHT1_P = 'eight1-press';
	var EIGHT1_R = 'eight1-release';
	var EIGHT2 = 'eight2';
	var EIGHT2_P = 'eight2-press';
	var EIGHT2_R = 'eight2-release';
	var EIGHT3 = 'eight3';
	var EIGHT3_P = 'eight3-press';
	var EIGHT3_R = 'eight3-release';
	var EIGHT4 = 'eight4';
	var EIGHT4_P = 'eight4-press';
	var EIGHT4_R = 'eight4-release';
	var EIGHT5 = 'eight5';
	var EIGHT5_P = 'eight5-press';
	var EIGHT5_R = 'eight5-release';
	var EIGHT6 = 'eight6';
	var EIGHT6_P = 'eight6-press';
	var EIGHT6_R = 'eight6-release';
	var EIGHT7 = 'eight7';
	var EIGHT7_P = 'eight7-press';
	var EIGHT7_R = 'eight7-release';
	var EIGHT8 = 'eight8';
	var EIGHT8_P = 'eight8-press';
	var EIGHT8_R = 'eight8-release';

	var NINE1 = 'nine1';
	var NINE1_P = 'nine1-press';
	var NINE1_R = 'nine1-release';
	var NINE2 = 'nine2';
	var NINE2_P = 'nine2-press';
	var NINE2_R = 'nine2-release';
	var NINE3 = 'nine3';
	var NINE3_P = 'nine3-press';
	var NINE3_R = 'nine3-release';
	var NINE4 = 'nine4';
	var NINE4_P = 'nine4-press';
	var NINE4_R = 'nine4-release';
	var NINE5 = 'nine5';
	var NINE5_P = 'nine5-press';
	var NINE5_R = 'nine5-release';
	var NINE6 = 'nine6';
	var NINE6_P = 'nine6-press';
	var NINE6_R = 'nine6-release';
	var NINE7 = 'nine7';
	var NINE7_P = 'nine7-press';
	var NINE7_R = 'nine7-release';
	var NINE8 = 'nine8';
	var NINE8_P = 'nine8-press';
	var NINE8_R = 'nine8-release';
	var NINE9 = 'nine9';
	var NINE9_P = 'nine9-press';
	var NINE9_R = 'nine9-release';

	/*var TEN1 = 'ten1';
	var TEN1_P = 'ten1-press';
	var TEN1_R = 'ten1-release';
	var TEN2 = 'ten2';
	var TEN2_P = 'ten2-press';
	var TEN2_R = 'ten2-release';
	var TEN3 = 'ten3';
	var TEN3_P = 'ten3-press';
	var TEN3_R = 'ten3-release';
	var TEN4 = 'ten4';
	var TEN4_P = 'ten4-press';
	var TEN4_R = 'ten4-release';
	var TEN5 = 'ten5';
	var TEN5_P = 'ten5-press';
	var TEN5_R = 'ten5-release';
	var TEN6 = 'ten6';
	var TEN6_P = 'ten6-press';
	var TEN6_R = 'ten6-release';
	var TEN7 = 'ten7';
	var TEN7_P = 'ten7-press';
	var TEN7_R = 'ten7-release';
	var TEN8 = 'ten8';
	var TEN8_P = 'ten8-press';
	var TEN8_R = 'ten8-release';
	var TEN9 = 'ten9';
	var TEN9_P = 'ten9-press';
	var TEN9_R = 'ten9-release';
	var TEN10 = 'ten10';
	var TEN10_P = 'ten10-press';
	var TEN10_R = 'ten10-release';*/
}
#end

enum Device
{
	Keys;
	Gamepad(id:Int);
}

/**
 * Since, in many cases multiple actions should use similar keys, we don't want the
 * rebinding UI to list every action. ActionBinders are what the user percieves as
 * an input so, for instance, they can't set jump-press and jump-release to different keys.
 */
enum Control
{
	UI_UP;
	UI_LEFT;
	UI_RIGHT;
	UI_DOWN;
	NOTE_UP;
	NOTE_LEFT;
	NOTE_RIGHT;
	NOTE_DOWN;
	RESET;
	ACCEPT;
	BACK;
	PAUSE;
	
	ONE1;

	TWO1;
	TWO2;

	THREE1;
	THREE2;
	THREE3;

	FIVE1;
	FIVE2;
	FIVE3;
	FIVE4;
	FIVE5;

	SIX1;
	SIX2;
	SIX3;
	SIX4;
	SIX5;
	SIX6;

	SEVEN1;
	SEVEN2;
	SEVEN3;
	SEVEN4;
	SEVEN5;
	SEVEN6;
	SEVEN7;

	EIGHT1;
	EIGHT2;
	EIGHT3;
	EIGHT4;
	EIGHT5;
	EIGHT6;
	EIGHT7;
	EIGHT8;

	NINE1;
	NINE2;
	NINE3;
	NINE4;
	NINE5;
	NINE6;
	NINE7;
	NINE8;
	NINE9;

	/*TEN1;
	TEN2;
	TEN3;
	TEN4;
	TEN5;
	TEN6;
	TEN7;
	TEN8;
	TEN9;
	TEN10;*/
}

enum KeyboardScheme
{
	Solo;
	Duo(first:Bool);
	None;
	Custom;
}

/**
 * A list of actions that a player would invoke via some input device.
 * Uses FlxActions to funnel various inputs to a single action.
 * 
 * btw zoro is noob
 * he uses like 3 more functions
 * over here we swag with the ultra complicated
 * flx action set controls code
 * 
 * :getfake:
 * 
 * I ALSO TOOK THE TIME TO MAKE CONTROLS FOR EACH AMMO
 * PLEASE CREDIT ME I FEEL DEAD
 */
class Controls extends FlxActionSet
{
	var _ui_up = new FlxActionDigital(Action.UI_UP);
	var _ui_left = new FlxActionDigital(Action.UI_LEFT);
	var _ui_right = new FlxActionDigital(Action.UI_RIGHT);
	var _ui_down = new FlxActionDigital(Action.UI_DOWN);
	var _ui_upP = new FlxActionDigital(Action.UI_UP_P);
	var _ui_leftP = new FlxActionDigital(Action.UI_LEFT_P);
	var _ui_rightP = new FlxActionDigital(Action.UI_RIGHT_P);
	var _ui_downP = new FlxActionDigital(Action.UI_DOWN_P);
	var _ui_upR = new FlxActionDigital(Action.UI_UP_R);
	var _ui_leftR = new FlxActionDigital(Action.UI_LEFT_R);
	var _ui_rightR = new FlxActionDigital(Action.UI_RIGHT_R);
	var _ui_downR = new FlxActionDigital(Action.UI_DOWN_R);
	var _note_up = new FlxActionDigital(Action.NOTE_UP);
	var _note_left = new FlxActionDigital(Action.NOTE_LEFT);
	var _note_right = new FlxActionDigital(Action.NOTE_RIGHT);
	var _note_down = new FlxActionDigital(Action.NOTE_DOWN);
	var _note_upP = new FlxActionDigital(Action.NOTE_UP_P);
	var _note_leftP = new FlxActionDigital(Action.NOTE_LEFT_P);
	var _note_rightP = new FlxActionDigital(Action.NOTE_RIGHT_P);
	var _note_downP = new FlxActionDigital(Action.NOTE_DOWN_P);
	var _note_upR = new FlxActionDigital(Action.NOTE_UP_R);
	var _note_leftR = new FlxActionDigital(Action.NOTE_LEFT_R);
	var _note_rightR = new FlxActionDigital(Action.NOTE_RIGHT_R);
	var _note_downR = new FlxActionDigital(Action.NOTE_DOWN_R);
	var _accept = new FlxActionDigital(Action.ACCEPT);
	var _back = new FlxActionDigital(Action.BACK);
	var _pause = new FlxActionDigital(Action.PAUSE);
	var _reset = new FlxActionDigital(Action.RESET);

	var _one1 = new FlxActionDigital(Action.ONE1);
	var _one1P = new FlxActionDigital(Action.ONE1_P);
	var _one1R = new FlxActionDigital(Action.ONE1_R);

	var _two1 = new FlxActionDigital(Action.TWO1);
	var _two1P = new FlxActionDigital(Action.TWO1_P);
	var _two1R = new FlxActionDigital(Action.TWO1_R);
	var _two2 = new FlxActionDigital(Action.TWO2);
	var _two2P = new FlxActionDigital(Action.TWO2_P);
	var _two2R = new FlxActionDigital(Action.TWO2_R);

	var _three1 = new FlxActionDigital(Action.THREE1);
	var _three1P = new FlxActionDigital(Action.THREE1_P);
	var _three1R = new FlxActionDigital(Action.THREE1_R);
	var _three2 = new FlxActionDigital(Action.THREE2);
	var _three2P = new FlxActionDigital(Action.THREE2_P);
	var _three2R = new FlxActionDigital(Action.THREE2_R);
	var _three3 = new FlxActionDigital(Action.THREE3);
	var _three3P = new FlxActionDigital(Action.THREE3_P);
	var _three3R = new FlxActionDigital(Action.THREE3_R);

	var _five1 = new FlxActionDigital(Action.FIVE1);
	var _five1P = new FlxActionDigital(Action.FIVE1_P);
	var _five1R = new FlxActionDigital(Action.FIVE1_R);
	var _five2 = new FlxActionDigital(Action.FIVE2);
	var _five2P = new FlxActionDigital(Action.FIVE2_P);
	var _five2R = new FlxActionDigital(Action.FIVE2_R);
	var _five3 = new FlxActionDigital(Action.FIVE3);
	var _five3P = new FlxActionDigital(Action.FIVE3_P);
	var _five3R = new FlxActionDigital(Action.FIVE3_R);
	var _five4 = new FlxActionDigital(Action.FIVE4);
	var _five4P = new FlxActionDigital(Action.FIVE4_P);
	var _five4R = new FlxActionDigital(Action.FIVE4_R);
	var _five5 = new FlxActionDigital(Action.FIVE5);
	var _five5P = new FlxActionDigital(Action.FIVE5_P);
	var _five5R = new FlxActionDigital(Action.FIVE5_R);

	var _six1 = new FlxActionDigital(Action.SIX1);
	var _six1P = new FlxActionDigital(Action.SIX1_P);
	var _six1R = new FlxActionDigital(Action.SIX1_R);
	var _six2 = new FlxActionDigital(Action.SIX2);
	var _six2P = new FlxActionDigital(Action.SIX2_P);
	var _six2R = new FlxActionDigital(Action.SIX2_R);
	var _six3 = new FlxActionDigital(Action.SIX3);
	var _six3P = new FlxActionDigital(Action.SIX3_P);
	var _six3R = new FlxActionDigital(Action.SIX3_R);
	var _six4 = new FlxActionDigital(Action.SIX4);
	var _six4P = new FlxActionDigital(Action.SIX4_P);
	var _six4R = new FlxActionDigital(Action.SIX4_R);
	var _six5 = new FlxActionDigital(Action.SIX5);
	var _six5P = new FlxActionDigital(Action.SIX5_P);
	var _six5R = new FlxActionDigital(Action.SIX5_R);
	var _six6 = new FlxActionDigital(Action.SIX6);
	var _six6P = new FlxActionDigital(Action.SIX6_P);
	var _six6R = new FlxActionDigital(Action.SIX6_R);

	var _sev1 = new FlxActionDigital(Action.SEVEN1);
	var _sev1P = new FlxActionDigital(Action.SEVEN1_P);
	var _sev1R = new FlxActionDigital(Action.SEVEN1_R);
	var _sev2 = new FlxActionDigital(Action.SEVEN2);
	var _sev2P = new FlxActionDigital(Action.SEVEN2_P);
	var _sev2R = new FlxActionDigital(Action.SEVEN2_R);
	var _sev3 = new FlxActionDigital(Action.SEVEN3);
	var _sev3P = new FlxActionDigital(Action.SEVEN3_P);
	var _sev3R = new FlxActionDigital(Action.SEVEN3_R);
	var _sev4 = new FlxActionDigital(Action.SEVEN4);
	var _sev4P = new FlxActionDigital(Action.SEVEN4_P);
	var _sev4R = new FlxActionDigital(Action.SEVEN4_R);
	var _sev5 = new FlxActionDigital(Action.SEVEN5);
	var _sev5P = new FlxActionDigital(Action.SEVEN5_P);
	var _sev5R = new FlxActionDigital(Action.SEVEN5_R);
	var _sev6 = new FlxActionDigital(Action.SEVEN6);
	var _sev6P = new FlxActionDigital(Action.SEVEN6_P);
	var _sev6R = new FlxActionDigital(Action.SEVEN6_R);
	var _sev7 = new FlxActionDigital(Action.SEVEN7);
	var _sev7P = new FlxActionDigital(Action.SEVEN7_P);
	var _sev7R = new FlxActionDigital(Action.SEVEN7_R);

	var _eig1 = new FlxActionDigital(Action.EIGHT1);
	var _eig1P = new FlxActionDigital(Action.EIGHT1_P);
	var _eig1R = new FlxActionDigital(Action.EIGHT1_R);
	var _eig2 = new FlxActionDigital(Action.EIGHT2);
	var _eig2P = new FlxActionDigital(Action.EIGHT2_P);
	var _eig2R = new FlxActionDigital(Action.EIGHT2_R);
	var _eig3 = new FlxActionDigital(Action.EIGHT3);
	var _eig3P = new FlxActionDigital(Action.EIGHT3_P);
	var _eig3R = new FlxActionDigital(Action.EIGHT3_R);
	var _eig4 = new FlxActionDigital(Action.EIGHT4);
	var _eig4P = new FlxActionDigital(Action.EIGHT4_P);
	var _eig4R = new FlxActionDigital(Action.EIGHT4_R);
	var _eig5 = new FlxActionDigital(Action.EIGHT5);
	var _eig5P = new FlxActionDigital(Action.EIGHT5_P);
	var _eig5R = new FlxActionDigital(Action.EIGHT5_R);
	var _eig6 = new FlxActionDigital(Action.EIGHT6);
	var _eig6P = new FlxActionDigital(Action.EIGHT6_P);
	var _eig6R = new FlxActionDigital(Action.EIGHT6_R);
	var _eig7 = new FlxActionDigital(Action.EIGHT7);
	var _eig7P = new FlxActionDigital(Action.EIGHT7_P);
	var _eig7R = new FlxActionDigital(Action.EIGHT7_R);
	var _eig8 = new FlxActionDigital(Action.EIGHT8);
	var _eig8P = new FlxActionDigital(Action.EIGHT8_P);
	var _eig8R = new FlxActionDigital(Action.EIGHT8_R);

	var _nin1 = new FlxActionDigital(Action.NINE1);
	var _nin1P = new FlxActionDigital(Action.NINE1_P);
	var _nin1R = new FlxActionDigital(Action.NINE1_R);
	var _nin2 = new FlxActionDigital(Action.NINE2);
	var _nin2P = new FlxActionDigital(Action.NINE2_P);
	var _nin2R = new FlxActionDigital(Action.NINE2_R);
	var _nin3 = new FlxActionDigital(Action.NINE3);
	var _nin3P = new FlxActionDigital(Action.NINE3_P);
	var _nin3R = new FlxActionDigital(Action.NINE3_R);
	var _nin4 = new FlxActionDigital(Action.NINE4);
	var _nin4P = new FlxActionDigital(Action.NINE4_P);
	var _nin4R = new FlxActionDigital(Action.NINE4_R);
	var _nin5 = new FlxActionDigital(Action.NINE5);
	var _nin5P = new FlxActionDigital(Action.NINE5_P);
	var _nin5R = new FlxActionDigital(Action.NINE5_R);
	var _nin6 = new FlxActionDigital(Action.NINE6);
	var _nin6P = new FlxActionDigital(Action.NINE6_P);
	var _nin6R = new FlxActionDigital(Action.NINE6_R);
	var _nin7 = new FlxActionDigital(Action.NINE7);
	var _nin7P = new FlxActionDigital(Action.NINE7_P);
	var _nin7R = new FlxActionDigital(Action.NINE7_R);
	var _nin8 = new FlxActionDigital(Action.NINE8);
	var _nin8P = new FlxActionDigital(Action.NINE8_P);
	var _nin8R = new FlxActionDigital(Action.NINE8_R);
	var _nin9 = new FlxActionDigital(Action.NINE9);
	var _nin9P = new FlxActionDigital(Action.NINE9_P);
	var _nin9R = new FlxActionDigital(Action.NINE9_R);

	/*var _ten1 = new FlxActionDigital(Action.TEN1);
	var _ten1P = new FlxActionDigital(Action.TEN1_P);
	var _ten1R = new FlxActionDigital(Action.TEN1_R);
	var _ten2 = new FlxActionDigital(Action.TEN2);
	var _ten2P = new FlxActionDigital(Action.TEN2_P);
	var _ten2R = new FlxActionDigital(Action.TEN2_R);
	var _ten3 = new FlxActionDigital(Action.TEN3);
	var _ten3P = new FlxActionDigital(Action.TEN3_P);
	var _ten3R = new FlxActionDigital(Action.TEN3_R);
	var _ten4 = new FlxActionDigital(Action.TEN4);
	var _ten4P = new FlxActionDigital(Action.TEN4_P);
	var _ten4R = new FlxActionDigital(Action.TEN4_R);
	var _ten5 = new FlxActionDigital(Action.TEN5);
	var _ten5P = new FlxActionDigital(Action.TEN5_P);
	var _ten5R = new FlxActionDigital(Action.TEN5_R);
	var _ten6 = new FlxActionDigital(Action.TEN6);
	var _ten6P = new FlxActionDigital(Action.TEN6_P);
	var _ten6R = new FlxActionDigital(Action.TEN6_R);
	var _ten7 = new FlxActionDigital(Action.TEN7);
	var _ten7P = new FlxActionDigital(Action.TEN7_P);
	var _ten7R = new FlxActionDigital(Action.TEN7_R);
	var _ten8 = new FlxActionDigital(Action.TEN8);
	var _ten8P = new FlxActionDigital(Action.TEN8_P);
	var _ten8R = new FlxActionDigital(Action.TEN8_R);
	var _ten9 = new FlxActionDigital(Action.TEN9);
	var _ten9P = new FlxActionDigital(Action.TEN9_P);
	var _ten9R = new FlxActionDigital(Action.TEN9_R);
	var _ten10 = new FlxActionDigital(Action.TEN10);
	var _ten10P = new FlxActionDigital(Action.TEN10_P);
	var _ten10R = new FlxActionDigital(Action.TEN10_R);*/

	#if (haxe >= "4.0.0")
	var byName:Map<String, FlxActionDigital> = [];
	#else
	var byName:Map<String, FlxActionDigital> = new Map<String, FlxActionDigital>();
	#end

	public var gamepadsAdded:Array<Int> = [];
	public var keyboardScheme = KeyboardScheme.None;

	public var UI_UP(get, never):Bool;

	inline function get_UI_UP()
		return _ui_up.check();

	public var UI_LEFT(get, never):Bool;

	inline function get_UI_LEFT()
		return _ui_left.check();

	public var UI_RIGHT(get, never):Bool;

	inline function get_UI_RIGHT()
		return _ui_right.check();

	public var UI_DOWN(get, never):Bool;

	inline function get_UI_DOWN()
		return _ui_down.check();

	public var UI_UP_P(get, never):Bool;

	inline function get_UI_UP_P()
		return _ui_upP.check();

	public var UI_LEFT_P(get, never):Bool;

	inline function get_UI_LEFT_P()
		return _ui_leftP.check();

	public var UI_RIGHT_P(get, never):Bool;

	inline function get_UI_RIGHT_P()
		return _ui_rightP.check();

	public var UI_DOWN_P(get, never):Bool;

	inline function get_UI_DOWN_P()
		return _ui_downP.check();

	public var UI_UP_R(get, never):Bool;

	inline function get_UI_UP_R()
		return _ui_upR.check();

	public var UI_LEFT_R(get, never):Bool;

	inline function get_UI_LEFT_R()
		return _ui_leftR.check();

	public var UI_RIGHT_R(get, never):Bool;

	inline function get_UI_RIGHT_R()
		return _ui_rightR.check();

	public var UI_DOWN_R(get, never):Bool;

	inline function get_UI_DOWN_R()
		return _ui_downR.check();

	public var NOTE_UP(get, never):Bool;

	inline function get_NOTE_UP()
		return _note_up.check();

	public var NOTE_LEFT(get, never):Bool;

	inline function get_NOTE_LEFT()
		return _note_left.check();

	public var NOTE_RIGHT(get, never):Bool;

	inline function get_NOTE_RIGHT()
		return _note_right.check();

	public var NOTE_DOWN(get, never):Bool;

	inline function get_NOTE_DOWN()
		return _note_down.check();

	public var NOTE_UP_P(get, never):Bool;

	inline function get_NOTE_UP_P()
		return _note_upP.check();

	public var NOTE_LEFT_P(get, never):Bool;

	inline function get_NOTE_LEFT_P()
		return _note_leftP.check();

	public var NOTE_RIGHT_P(get, never):Bool;

	inline function get_NOTE_RIGHT_P()
		return _note_rightP.check();

	public var NOTE_DOWN_P(get, never):Bool;

	inline function get_NOTE_DOWN_P()
		return _note_downP.check();

	public var NOTE_UP_R(get, never):Bool;

	inline function get_NOTE_UP_R()
		return _note_upR.check();

	public var NOTE_LEFT_R(get, never):Bool;

	inline function get_NOTE_LEFT_R()
		return _note_leftR.check();

	public var NOTE_RIGHT_R(get, never):Bool;

	inline function get_NOTE_RIGHT_R()
		return _note_rightR.check();

	public var NOTE_DOWN_R(get, never):Bool;

	inline function get_NOTE_DOWN_R()
		return _note_downR.check();

	public var ACCEPT(get, never):Bool;

	inline function get_ACCEPT()
		return _accept.check();

	public var BACK(get, never):Bool;

	inline function get_BACK()
		return _back.check();

	public var PAUSE(get, never):Bool;

	inline function get_PAUSE()
		return _pause.check();

	public var RESET(get, never):Bool;

	inline function get_RESET()
		return _reset.check();

	public var ONE1(get, never):Bool; inline function get_ONE1() {return _one1.check();}
	public var ONE1_P(get, never):Bool; inline function get_ONE1_P() {return _one1P.check();}
	public var ONE1_R(get, never):Bool; inline function get_ONE1_R() {return _one1R.check();}

	public var TWO1(get, never):Bool; inline function get_TWO1() {return _two1.check();}
	public var TWO1_P(get, never):Bool; inline function get_TWO1_P() {return _two1P.check();}
	public var TWO1_R(get, never):Bool; inline function get_TWO1_R() {return _two1R.check();}
	public var TWO2(get, never):Bool; inline function get_TWO2() {return _two2.check();}
	public var TWO2_P(get, never):Bool; inline function get_TWO2_P() {return _two2P.check();}
	public var TWO2_R(get, never):Bool; inline function get_TWO2_R() {return _two2R.check();}

	public var THREE1(get, never):Bool; inline function get_THREE1() {return _three1.check();}
	public var THREE1_P(get, never):Bool; inline function get_THREE1_P() {return _three1P.check();}
	public var THREE1_R(get, never):Bool; inline function get_THREE1_R() {return _three1R.check();}
	public var THREE2(get, never):Bool; inline function get_THREE2() {return _three2.check();}
	public var THREE2_P(get, never):Bool; inline function get_THREE2_P() {return _three2P.check();}
	public var THREE2_R(get, never):Bool; inline function get_THREE2_R() {return _three2R.check();}
	public var THREE3(get, never):Bool; inline function get_THREE3() {return _three3.check();}
	public var THREE3_P(get, never):Bool; inline function get_THREE3_P() {return _three3P.check();}
	public var THREE3_R(get, never):Bool; inline function get_THREE3_R() {return _three3R.check();}

	public var FIVE1(get, never):Bool; inline function get_FIVE1() {return _five1.check();}
	public var FIVE1_P(get, never):Bool; inline function get_FIVE1_P() {return _five1P.check();}
	public var FIVE1_R(get, never):Bool; inline function get_FIVE1_R() {return _five1R.check();}
	public var FIVE2(get, never):Bool; inline function get_FIVE2() {return _five2.check();}
	public var FIVE2_P(get, never):Bool; inline function get_FIVE2_P() {return _five2P.check();}
	public var FIVE2_R(get, never):Bool; inline function get_FIVE2_R() {return _five2R.check();}
	public var FIVE3(get, never):Bool; inline function get_FIVE3() {return _five3.check();}
	public var FIVE3_P(get, never):Bool; inline function get_FIVE3_P() {return _five3P.check();}
	public var FIVE3_R(get, never):Bool; inline function get_FIVE3_R() {return _five3R.check();}
	public var FIVE4(get, never):Bool; inline function get_FIVE4() {return _five4.check();}
	public var FIVE4_P(get, never):Bool; inline function get_FIVE4_P() {return _five4P.check();}
	public var FIVE4_R(get, never):Bool; inline function get_FIVE4_R() {return _five4R.check();}
	public var FIVE5(get, never):Bool; inline function get_FIVE5() {return _five5.check();}
	public var FIVE5_P(get, never):Bool; inline function get_FIVE5_P() {return _five5P.check();}
	public var FIVE5_R(get, never):Bool; inline function get_FIVE5_R() {return _five5R.check();}

	public var SIX1(get, never):Bool; inline function get_SIX1() {return _six1.check();}
	public var SIX1_P(get, never):Bool; inline function get_SIX1_P() {return _six1P.check();}
	public var SIX1_R(get, never):Bool; inline function get_SIX1_R() {return _six1R.check();}
	public var SIX2(get, never):Bool; inline function get_SIX2() {return _six2.check();}
	public var SIX2_P(get, never):Bool; inline function get_SIX2_P() {return _six2P.check();}
	public var SIX2_R(get, never):Bool; inline function get_SIX2_R() {return _six2R.check();}
	public var SIX3(get, never):Bool; inline function get_SIX3() {return _six3.check();}
	public var SIX3_P(get, never):Bool; inline function get_SIX3_P() {return _six3P.check();}
	public var SIX3_R(get, never):Bool; inline function get_SIX3_R() {return _six3R.check();}
	public var SIX4(get, never):Bool; inline function get_SIX4() {return _six4.check();}
	public var SIX4_P(get, never):Bool; inline function get_SIX4_P() {return _six4P.check();}
	public var SIX4_R(get, never):Bool; inline function get_SIX4_R() {return _six4R.check();}
	public var SIX5(get, never):Bool; inline function get_SIX5() {return _six5.check();}
	public var SIX5_P(get, never):Bool; inline function get_SIX5_P() {return _six5P.check();}
	public var SIX5_R(get, never):Bool; inline function get_SIX5_R() {return _six5R.check();}
	public var SIX6(get, never):Bool; inline function get_SIX6() {return _six6.check();}
	public var SIX6_P(get, never):Bool; inline function get_SIX6_P() {return _six6P.check();}
	public var SIX6_R(get, never):Bool; inline function get_SIX6_R() {return _six6R.check();}

	public var SEVEN1(get, never):Bool; inline function get_SEVEN1() {return _sev1.check();}
	public var SEVEN1_P(get, never):Bool; inline function get_SEVEN1_P() {return _sev1P.check();}
	public var SEVEN1_R(get, never):Bool; inline function get_SEVEN1_R() {return _sev1R.check();}
	public var SEVEN2(get, never):Bool; inline function get_SEVEN2() {return _sev2.check();}
	public var SEVEN2_P(get, never):Bool; inline function get_SEVEN2_P() {return _sev2P.check();}
	public var SEVEN2_R(get, never):Bool; inline function get_SEVEN2_R() {return _sev2R.check();}
	public var SEVEN3(get, never):Bool; inline function get_SEVEN3() {return _sev3.check();}
	public var SEVEN3_P(get, never):Bool; inline function get_SEVEN3_P() {return _sev3P.check();}
	public var SEVEN3_R(get, never):Bool; inline function get_SEVEN3_R() {return _sev3R.check();}
	public var SEVEN4(get, never):Bool; inline function get_SEVEN4() {return _sev4.check();}
	public var SEVEN4_P(get, never):Bool; inline function get_SEVEN4_P() {return _sev4P.check();}
	public var SEVEN4_R(get, never):Bool; inline function get_SEVEN4_R() {return _sev4R.check();}
	public var SEVEN5(get, never):Bool; inline function get_SEVEN5() {return _sev5.check();}
	public var SEVEN5_P(get, never):Bool; inline function get_SEVEN5_P() {return _sev5P.check();}
	public var SEVEN5_R(get, never):Bool; inline function get_SEVEN5_R() {return _sev5R.check();}
	public var SEVEN6(get, never):Bool; inline function get_SEVEN6() {return _sev6.check();}
	public var SEVEN6_P(get, never):Bool; inline function get_SEVEN6_P() {return _sev6P.check();}
	public var SEVEN6_R(get, never):Bool; inline function get_SEVEN6_R() {return _sev6R.check();}
	public var SEVEN7(get, never):Bool; inline function get_SEVEN7() {return _sev7.check();}
	public var SEVEN7_P(get, never):Bool; inline function get_SEVEN7_P() {return _sev7P.check();}
	public var SEVEN7_R(get, never):Bool; inline function get_SEVEN7_R() {return _sev7R.check();}

	public var EIGHT1(get, never):Bool; inline function get_EIGHT1() {return _eig1.check();}
	public var EIGHT1_P(get, never):Bool; inline function get_EIGHT1_P() {return _eig1P.check();}
	public var EIGHT1_R(get, never):Bool; inline function get_EIGHT1_R() {return _eig1R.check();}
	public var EIGHT2(get, never):Bool; inline function get_EIGHT2() {return _eig2.check();}
	public var EIGHT2_P(get, never):Bool; inline function get_EIGHT2_P() {return _eig2P.check();}
	public var EIGHT2_R(get, never):Bool; inline function get_EIGHT2_R() {return _eig2R.check();}
	public var EIGHT3(get, never):Bool; inline function get_EIGHT3() {return _eig3.check();}
	public var EIGHT3_P(get, never):Bool; inline function get_EIGHT3_P() {return _eig3P.check();}
	public var EIGHT3_R(get, never):Bool; inline function get_EIGHT3_R() {return _eig3R.check();}
	public var EIGHT4(get, never):Bool; inline function get_EIGHT4() {return _eig4.check();}
	public var EIGHT4_P(get, never):Bool; inline function get_EIGHT4_P() {return _eig4P.check();}
	public var EIGHT4_R(get, never):Bool; inline function get_EIGHT4_R() {return _eig4R.check();}
	public var EIGHT5(get, never):Bool; inline function get_EIGHT5() {return _eig5.check();}
	public var EIGHT5_P(get, never):Bool; inline function get_EIGHT5_P() {return _eig5P.check();}
	public var EIGHT5_R(get, never):Bool; inline function get_EIGHT5_R() {return _eig5R.check();}
	public var EIGHT6(get, never):Bool; inline function get_EIGHT6() {return _eig6.check();}
	public var EIGHT6_P(get, never):Bool; inline function get_EIGHT6_P() {return _eig6P.check();}
	public var EIGHT6_R(get, never):Bool; inline function get_EIGHT6_R() {return _eig6R.check();}
	public var EIGHT7(get, never):Bool; inline function get_EIGHT7() {return _eig7.check();}
	public var EIGHT7_P(get, never):Bool; inline function get_EIGHT7_P() {return _eig7P.check();}
	public var EIGHT7_R(get, never):Bool; inline function get_EIGHT7_R() {return _eig7R.check();}
	public var EIGHT8(get, never):Bool; inline function get_EIGHT8() {return _eig8.check();}
	public var EIGHT8_P(get, never):Bool; inline function get_EIGHT8_P() {return _eig8P.check();}
	public var EIGHT8_R(get, never):Bool; inline function get_EIGHT8_R() {return _eig8R.check();}

	public var NINE1(get, never):Bool; inline function get_NINE1() {return _nin1.check();}
	public var NINE1_P(get, never):Bool; inline function get_NINE1_P() {return _nin1P.check();}
	public var NINE1_R(get, never):Bool; inline function get_NINE1_R() {return _nin1R.check();}
	public var NINE2(get, never):Bool; inline function get_NINE2() {return _nin2.check();}
	public var NINE2_P(get, never):Bool; inline function get_NINE2_P() {return _nin2P.check();}
	public var NINE2_R(get, never):Bool; inline function get_NINE2_R() {return _nin2R.check();}
	public var NINE3(get, never):Bool; inline function get_NINE3() {return _nin3.check();}
	public var NINE3_P(get, never):Bool; inline function get_NINE3_P() {return _nin3P.check();}
	public var NINE3_R(get, never):Bool; inline function get_NINE3_R() {return _nin3R.check();}
	public var NINE4(get, never):Bool; inline function get_NINE4() {return _nin4.check();}
	public var NINE4_P(get, never):Bool; inline function get_NINE4_P() {return _nin4P.check();}
	public var NINE4_R(get, never):Bool; inline function get_NINE4_R() {return _nin4R.check();}
	public var NINE5(get, never):Bool; inline function get_NINE5() {return _nin5.check();}
	public var NINE5_P(get, never):Bool; inline function get_NINE5_P() {return _nin5P.check();}
	public var NINE5_R(get, never):Bool; inline function get_NINE5_R() {return _nin5R.check();}
	public var NINE6(get, never):Bool; inline function get_NINE6() {return _nin6.check();}
	public var NINE6_P(get, never):Bool; inline function get_NINE6_P() {return _nin6P.check();}
	public var NINE6_R(get, never):Bool; inline function get_NINE6_R() {return _nin6R.check();}
	public var NINE7(get, never):Bool; inline function get_NINE7() {return _nin7.check();}
	public var NINE7_P(get, never):Bool; inline function get_NINE7_P() {return _nin7P.check();}
	public var NINE7_R(get, never):Bool; inline function get_NINE7_R() {return _nin7R.check();}
	public var NINE8(get, never):Bool; inline function get_NINE8() {return _nin8.check();}
	public var NINE8_P(get, never):Bool; inline function get_NINE8_P() {return _nin8P.check();}
	public var NINE8_R(get, never):Bool; inline function get_NINE8_R() {return _nin8R.check();}
	public var NINE9(get, never):Bool; inline function get_NINE9() {return _nin9.check();}
	public var NINE9_P(get, never):Bool; inline function get_NINE9_P() {return _nin9P.check();}
	public var NINE9_R(get, never):Bool; inline function get_NINE9_R() {return _nin9R.check();}
	
	#if (haxe >= "4.0.0")
	public function new(name, scheme = None)
	{
		super(name);

		add(_ui_up);
		add(_ui_left);
		add(_ui_right);
		add(_ui_down);
		add(_ui_upP);
		add(_ui_leftP);
		add(_ui_rightP);
		add(_ui_downP);
		add(_ui_upR);
		add(_ui_leftR);
		add(_ui_rightR);
		add(_ui_downR);
		add(_note_up);
		add(_note_left);
		add(_note_right);
		add(_note_down);
		add(_note_upP);
		add(_note_leftP);
		add(_note_rightP);
		add(_note_downP);
		add(_note_upR);
		add(_note_leftR);
		add(_note_rightR);
		add(_note_downR);
		add(_accept);
		add(_back);
		add(_pause);
		add(_reset);

		add(_one1); add(_one1P); add(_one1R);

		add(_two1); add(_two1P); add(_two1R);
		add(_two2); add(_two2P); add(_two2R);

		add(_three1); add(_three1P); add(_three1R);
		add(_three2); add(_three2P); add(_three2R);
		add(_three3); add(_three3P); add(_three3R);

		add(_five1); add(_five1P); add(_five1R); 
		add(_five2); add(_five2P); add(_five2R);
		add(_five3); add(_five3P); add(_five3R);
		add(_five4); add(_five4P); add(_five4R);
		add(_five5); add(_five5P); add(_five5R);

		add(_six1); add(_six1P); add(_six1R);
		add(_six2); add(_six2P); add(_six2R);
		add(_six3); add(_six3P); add(_six3R);
		add(_six4); add(_six4P); add(_six4R);
		add(_six5); add(_six5P); add(_six5R);
		add(_six6); add(_six6P); add(_six6R);

		add(_sev1); add(_sev1P); add(_sev1R);
		add(_sev2); add(_sev2P); add(_sev2R);
		add(_sev3); add(_sev3P); add(_sev3R);
		add(_sev4); add(_sev4P); add(_sev4R);
		add(_sev5); add(_sev5P); add(_sev5R);
		add(_sev6); add(_sev6P); add(_sev6R);
		add(_sev7); add(_sev7P); add(_sev7R);

		add(_eig1); add(_eig1P); add(_eig1R);
		add(_eig2); add(_eig2P); add(_eig2R);
		add(_eig3); add(_eig3P); add(_eig3R);
		add(_eig4); add(_eig4P); add(_eig4R);
		add(_eig5); add(_eig5P); add(_eig5R);
		add(_eig6); add(_eig6P); add(_eig6R);
		add(_eig7); add(_eig7P); add(_eig7R);
		add(_eig8); add(_eig8P); add(_eig8R);

		add(_nin1); add(_nin1P); add(_nin1R);
		add(_nin2); add(_nin2P); add(_nin2R);
		add(_nin3); add(_nin3P); add(_nin3R);
		add(_nin4); add(_nin4P); add(_nin4R);
		add(_nin5); add(_nin5P); add(_nin5R);
		add(_nin6); add(_nin6P); add(_nin6R);
		add(_nin7); add(_nin7P); add(_nin7R);
		add(_nin8); add(_nin8P); add(_nin8R);
		add(_nin9); add(_nin9P); add(_nin9R);
		
		for (action in digitalActions)
			byName[action.name] = action;

		setKeyboardScheme(scheme, false);
	}
	#else
	public function new(name, scheme:KeyboardScheme = null)
	{
		super(name);

		add(_ui_up);
		add(_ui_left);
		add(_ui_right);
		add(_ui_down);
		add(_ui_upP);
		add(_ui_leftP);
		add(_ui_rightP);
		add(_ui_downP);
		add(_ui_upR);
		add(_ui_leftR);
		add(_ui_rightR);
		add(_ui_downR);
		add(_note_up);
		add(_note_left);
		add(_note_right);
		add(_note_down);
		add(_note_upP);
		add(_note_leftP);
		add(_note_rightP);
		add(_note_downP);
		add(_note_upR);
		add(_note_leftR);
		add(_note_rightR);
		add(_note_downR);
		add(_accept);
		add(_back);
		add(_pause);
		add(_reset);

		add(_one1); add(_one1P); add(_one1R);

		add(_two1); add(_two1P); add(_two1R);
		add(_two2); add(_two2P); add(_two2R);

		add(_three1); add(_three1P); add(_three1R);
		add(_three2); add(_three2P); add(_three2R);
		add(_three3); add(_three3P); add(_three3R);

		add(_five1); add(_five1P); add(_five1R); 
		add(_five2); add(_five2P); add(_five2R);
		add(_five3); add(_five3P); add(_five3R);
		add(_five4); add(_five4P); add(_five4R);
		add(_five5); add(_five5P); add(_five5R);

		add(_six1); add(_six1P); add(_six1R);
		add(_six2); add(_six2P); add(_six2R);
		add(_six3); add(_six3P); add(_six3R);
		add(_six4); add(_six4P); add(_six4R);
		add(_six5); add(_six5P); add(_six5R);
		add(_six6); add(_six6P); add(_six6R);

		add(_sev1); add(_sev1P); add(_sev1R);
		add(_sev2); add(_sev2P); add(_sev2R);
		add(_sev3); add(_sev3P); add(_sev3R);
		add(_sev4); add(_sev4P); add(_sev4R);
		add(_sev5); add(_sev5P); add(_sev5R);
		add(_sev6); add(_sev6P); add(_sev6R);
		add(_sev7); add(_sev7P); add(_sev7R);

		add(_eig1); add(_eig1P); add(_eig1R);
		add(_eig2); add(_eig2P); add(_eig2R);
		add(_eig3); add(_eig3P); add(_eig3R);
		add(_eig4); add(_eig4P); add(_eig4R);
		add(_eig5); add(_eig5P); add(_eig5R);
		add(_eig6); add(_eig6P); add(_eig6R);
		add(_eig7); add(_eig7P); add(_eig7R);
		add(_eig8); add(_eig8P); add(_eig8R);

		add(_nin1); add(_nin1P); add(_nin1R);
		add(_nin2); add(_nin2P); add(_nin2R);
		add(_nin3); add(_nin3P); add(_nin3R);
		add(_nin4); add(_nin4P); add(_nin4R);
		add(_nin5); add(_nin5P); add(_nin5R);
		add(_nin6); add(_nin6P); add(_nin6R);
		add(_nin7); add(_nin7P); add(_nin7R);
		add(_nin8); add(_nin8P); add(_nin8R);
		add(_nin9); add(_nin9P); add(_nin9R);
		
		for (action in digitalActions)
			byName[action.name] = action;
			
		if (scheme == null)
			scheme = None;
		setKeyboardScheme(scheme, false);
	}
	#end

	override function update()
	{
		super.update();
	}

	// inline
	public function checkByName(name:Action):Bool
	{
		#if debug
		if (!byName.exists(name))
			throw 'Invalid name: $name';
		#end
		return byName[name].check();
	}

	public function getDialogueName(action:FlxActionDigital):String
	{
		var input = action.inputs[0];
		return switch input.device
		{
			case KEYBOARD: return '[${(input.inputID : FlxKey)}]';
			case GAMEPAD: return '(${(input.inputID : FlxGamepadInputID)})';
			case device: throw 'unhandled device: $device';
		}
	}

	public function getDialogueNameFromToken(token:String):String
	{
		return getDialogueName(getActionFromControl(Control.createByName(token.toUpperCase())));
	}

	function getActionFromControl(control:Control):FlxActionDigital
	{
		return switch (control)
		{
			case UI_UP: _ui_up;
			case UI_DOWN: _ui_down;
			case UI_LEFT: _ui_left;
			case UI_RIGHT: _ui_right;
			case NOTE_UP: _note_up;
			case NOTE_DOWN: _note_down;
			case NOTE_LEFT: _note_left;
			case NOTE_RIGHT: _note_right;
			case ACCEPT: _accept;
			case BACK: _back;
			case PAUSE: _pause;
			case RESET: _reset;
		
			case ONE1: _one1;

			case TWO1: _two1;
			case TWO2: _two2;

			case THREE1: _three1;
			case THREE2: _three2;
			case THREE3: _three3;
			
			case FIVE1: _five1;
			case FIVE2: _five2;
			case FIVE3: _five3;
			case FIVE4: _five4; 
			case FIVE5: _five5;

			case SIX1: _six1;
			case SIX2: _six2;
			case SIX3: _six3;
			case SIX4: _six4;
			case SIX5: _six5;
			case SIX6: _six6;

			case SEVEN1: _sev1;
			case SEVEN2: _sev2;
			case SEVEN3: _sev3;
			case SEVEN4: _sev4;
			case SEVEN5: _sev5;
			case SEVEN6: _sev6;
			case SEVEN7: _sev7;

			case EIGHT1: _eig1;
			case EIGHT2: _eig2;
			case EIGHT3: _eig3;
			case EIGHT4: _eig4;
			case EIGHT5: _eig5;
			case EIGHT6: _eig6;
			case EIGHT7: _eig7;
			case EIGHT8: _eig8;

			case NINE1: _nin1;
			case NINE2: _nin2;
			case NINE3: _nin3;
			case NINE4: _nin4;
			case NINE5: _nin5;
			case NINE6: _nin6;
			case NINE7: _nin7;
			case NINE8: _nin8;
			case NINE9: _nin9;

			/*case TEN1: _ten1;
			case TEN2: _ten2;
			case TEN3: _ten3;
			case TEN4: _ten4;
			case TEN5: _ten5;
			case TEN6: _ten6;
			case TEN7: _ten7;
			case TEN8: _ten8;
			case TEN9: _ten9;
			case TEN10: _ten10;*/
		}
	}

	static function init():Void
	{
		var actions = new FlxActionManager();
		FlxG.inputs.add(actions);
	}

	/**
	 * Calls a function passing each action bound by the specified control
	 * @param control
	 * @param func
	 * @return ->Void)
	 */
	function forEachBound(control:Control, func:FlxActionDigital->FlxInputState->Void)
	{
		switch (control)
		{
			case UI_UP:
				func(_ui_up, PRESSED);
				func(_ui_upP, JUST_PRESSED);
				func(_ui_upR, JUST_RELEASED);
			case UI_LEFT:
				func(_ui_left, PRESSED);
				func(_ui_leftP, JUST_PRESSED);
				func(_ui_leftR, JUST_RELEASED);
			case UI_RIGHT:
				func(_ui_right, PRESSED);
				func(_ui_rightP, JUST_PRESSED);
				func(_ui_rightR, JUST_RELEASED);
			case UI_DOWN:
				func(_ui_down, PRESSED);
				func(_ui_downP, JUST_PRESSED);
				func(_ui_downR, JUST_RELEASED);
			case NOTE_UP:
				func(_note_up, PRESSED);
				func(_note_upP, JUST_PRESSED);
				func(_note_upR, JUST_RELEASED);
			case NOTE_LEFT:
				func(_note_left, PRESSED);
				func(_note_leftP, JUST_PRESSED);
				func(_note_leftR, JUST_RELEASED);
			case NOTE_RIGHT:
				func(_note_right, PRESSED);
				func(_note_rightP, JUST_PRESSED);
				func(_note_rightR, JUST_RELEASED);
			case NOTE_DOWN:
				func(_note_down, PRESSED);
				func(_note_downP, JUST_PRESSED);
				func(_note_downR, JUST_RELEASED);
			case ACCEPT:
				func(_accept, JUST_PRESSED);
			case BACK:
				func(_back, JUST_PRESSED);
			case PAUSE:
				func(_pause, JUST_PRESSED);
			case RESET:
				func(_reset, JUST_PRESSED);

			case ONE1:
				func(_one1, PRESSED);
				func(_one1P, JUST_PRESSED);
				func(_one1R, JUST_RELEASED);
			case TWO1:
				func(_two1, PRESSED);
				func(_two1P, JUST_PRESSED);
				func(_two1R, JUST_RELEASED);
			case TWO2:
				func(_two2, PRESSED);
				func(_two2P, JUST_PRESSED);
				func(_two2R, JUST_RELEASED);
			case THREE1:
				func(_three1, PRESSED); func(_three1P, JUST_PRESSED); func(_three1R, JUST_RELEASED);
			case THREE2: 
				func(_three2, PRESSED); func(_three2P, JUST_PRESSED); func(_three2R, JUST_RELEASED);
			case THREE3:
				func(_three3, PRESSED); func(_three3P, JUST_PRESSED); func(_three3R, JUST_RELEASED);

			case FIVE1:
				func(_five1, PRESSED); func(_five1P, JUST_PRESSED); func(_five1R, JUST_RELEASED);
			case FIVE2:
				func(_five2, PRESSED); func(_five2P, JUST_PRESSED); func(_five2R, JUST_RELEASED);
			case FIVE3:
				func(_five3, PRESSED); func(_five3P, JUST_PRESSED); func(_five3R, JUST_RELEASED);
			case FIVE4:
				func(_five4, PRESSED); func(_five4P, JUST_PRESSED); func(_five4R, JUST_RELEASED);
			case FIVE5:
				func(_five5, PRESSED); func(_five5P, JUST_PRESSED); func(_five5R, JUST_RELEASED);

			case SIX1:
				func(_six1, PRESSED); func(_six1P, JUST_PRESSED); func(_six1R, JUST_RELEASED);
			case SIX2:
				func(_six2, PRESSED); func(_six2P, JUST_PRESSED); func(_six2R, JUST_RELEASED);
			case SIX3:
				func(_six3, PRESSED); func(_six3P, JUST_PRESSED); func(_six3R, JUST_RELEASED);
			case SIX4:
				func(_six4, PRESSED); func(_six4P, JUST_PRESSED); func(_six4R, JUST_RELEASED);
			case SIX5:
				func(_six5, PRESSED); func(_six5P, JUST_PRESSED); func(_six5R, JUST_RELEASED);	
			case SIX6:
				func(_six6, PRESSED); func(_six6P, JUST_PRESSED); func(_six6R, JUST_RELEASED);

			case SEVEN1:
				func(_sev1, PRESSED); func(_sev1P, JUST_PRESSED); func(_sev1R, JUST_RELEASED);
			case SEVEN2:
				func(_sev2, PRESSED); func(_sev2P, JUST_PRESSED); func(_sev2R, JUST_RELEASED);
			case SEVEN3:
				func(_sev3, PRESSED); func(_sev3P, JUST_PRESSED); func(_sev3R, JUST_RELEASED);
			case SEVEN4:
				func(_sev4, PRESSED); func(_sev4P, JUST_PRESSED); func(_sev4R, JUST_RELEASED);
			case SEVEN5:
				func(_sev5, PRESSED); func(_sev5P, JUST_PRESSED); func(_sev5R, JUST_RELEASED);	
			case SEVEN6:
				func(_sev6, PRESSED); func(_sev6P, JUST_PRESSED); func(_sev6R, JUST_RELEASED);
			case SEVEN7:
				func(_sev7, PRESSED); func(_sev7P, JUST_PRESSED); func(_sev7R, JUST_RELEASED);

			case EIGHT1:
				func(_eig1, PRESSED); func(_eig1P, JUST_PRESSED); func(_eig1R, JUST_RELEASED);
			case EIGHT2:
				func(_eig2, PRESSED); func(_eig2P, JUST_PRESSED); func(_eig2R, JUST_RELEASED);
			case EIGHT3:
				func(_eig3, PRESSED); func(_eig3P, JUST_PRESSED); func(_eig3R, JUST_RELEASED);
			case EIGHT4:
				func(_eig4, PRESSED); func(_eig4P, JUST_PRESSED); func(_eig4R, JUST_RELEASED);
			case EIGHT5:
				func(_eig5, PRESSED); func(_eig5P, JUST_PRESSED); func(_eig5R, JUST_RELEASED);	
			case EIGHT6:
				func(_eig6, PRESSED); func(_eig6P, JUST_PRESSED); func(_eig6R, JUST_RELEASED);
			case EIGHT7:
				func(_eig7, PRESSED); func(_eig7P, JUST_PRESSED); func(_eig7R, JUST_RELEASED);
			case EIGHT8:
				func(_eig8, PRESSED); func(_eig8P, JUST_PRESSED); func(_eig8R, JUST_RELEASED);

			case NINE1:
				func(_nin1, PRESSED); func(_nin1P, JUST_PRESSED); func(_nin1R, JUST_RELEASED);
			case NINE2:
				func(_nin2, PRESSED); func(_nin2P, JUST_PRESSED); func(_nin2R, JUST_RELEASED);
			case NINE3:
				func(_nin3, PRESSED); func(_nin3P, JUST_PRESSED); func(_nin3R, JUST_RELEASED);
			case NINE4:
				func(_nin4, PRESSED); func(_nin4P, JUST_PRESSED); func(_nin4R, JUST_RELEASED);
			case NINE5:
				func(_nin5, PRESSED); func(_nin5P, JUST_PRESSED); func(_nin5R, JUST_RELEASED);	
			case NINE6:
				func(_nin6, PRESSED); func(_nin6P, JUST_PRESSED); func(_nin6R, JUST_RELEASED);
			case NINE7:
				func(_nin7, PRESSED); func(_nin7P, JUST_PRESSED); func(_nin7R, JUST_RELEASED);
			case NINE8:
				func(_nin8, PRESSED); func(_nin8P, JUST_PRESSED); func(_nin8R, JUST_RELEASED);
			case NINE9:
				func(_nin9, PRESSED); func(_nin9P, JUST_PRESSED); func(_nin9R, JUST_RELEASED);

			/*case TEN1:
				func(_ten1, PRESSED); func(_ten1P, JUST_PRESSED); func(_ten1R, JUST_RELEASED);
			case TEN2:
				func(_ten2, PRESSED); func(_ten2P, JUST_PRESSED); func(_ten2R, JUST_RELEASED);
			case TEN3:
				func(_ten3, PRESSED); func(_ten3P, JUST_PRESSED); func(_ten3R, JUST_RELEASED);
			case TEN4:
				func(_ten4, PRESSED); func(_ten4P, JUST_PRESSED); func(_ten4R, JUST_RELEASED);
			case TEN5:
				func(_ten5, PRESSED); func(_ten5P, JUST_PRESSED); func(_ten5R, JUST_RELEASED);	
			case TEN6:
				func(_ten6, PRESSED); func(_ten6P, JUST_PRESSED); func(_ten6R, JUST_RELEASED);
			case TEN7:
				func(_ten7, PRESSED); func(_ten7P, JUST_PRESSED); func(_ten7R, JUST_RELEASED);
			case TEN8:
				func(_ten8, PRESSED); func(_ten8P, JUST_PRESSED); func(_ten8R, JUST_RELEASED);
			case TEN9:
				func(_ten9, PRESSED); func(_ten9P, JUST_PRESSED); func(_ten9R, JUST_RELEASED);
			case TEN10:
				func(_ten10, PRESSED); func(_ten10P, JUST_PRESSED); func(_ten10R, JUST_RELEASED);*/
		}
	}

	public function replaceBinding(control:Control, device:Device, ?toAdd:Int, ?toRemove:Int)
	{
		if (toAdd == toRemove)
			return;

		switch (device)
		{
			case Keys:
				if (toRemove != null)
					unbindKeys(control, [toRemove]);
				if (toAdd != null)
					bindKeys(control, [toAdd]);

			case Gamepad(id):
				if (toRemove != null)
					unbindButtons(control, id, [toRemove]);
				if (toAdd != null)
					bindButtons(control, id, [toAdd]);
		}
	}

	public function copyFrom(controls:Controls, ?device:Device)
	{
		#if (haxe >= "4.0.0")
		for (name => action in controls.byName)
		{
			for (input in action.inputs)
			{
				if (device == null || isDevice(input, device))
					byName[name].add(cast input);
			}
		}
		#else
		for (name in controls.byName.keys())
		{
			var action = controls.byName[name];
			for (input in action.inputs)
			{
				if (device == null || isDevice(input, device))
				byName[name].add(cast input);
			}
		}
		#end

		switch (device)
		{
			case null:
				// add all
				#if (haxe >= "4.0.0")
				for (gamepad in controls.gamepadsAdded)
					if (!gamepadsAdded.contains(gamepad))
						gamepadsAdded.push(gamepad);
				#else
				for (gamepad in controls.gamepadsAdded)
					if (gamepadsAdded.indexOf(gamepad) == -1)
					  gamepadsAdded.push(gamepad);
				#end

				mergeKeyboardScheme(controls.keyboardScheme);

			case Gamepad(id):
				gamepadsAdded.push(id);
			case Keys:
				mergeKeyboardScheme(controls.keyboardScheme);
		}
	}

	inline public function copyTo(controls:Controls, ?device:Device)
	{
		controls.copyFrom(this, device);
	}

	function mergeKeyboardScheme(scheme:KeyboardScheme):Void
	{
		if (scheme != None)
		{
			switch (keyboardScheme)
			{
				case None:
					keyboardScheme = scheme;
				default:
					keyboardScheme = Custom;
			}
		}
	}

	/**
	 * Sets all actions that pertain to the binder to trigger when the supplied keys are used.
	 * If binder is a literal you can inline this
	 */
	public function bindKeys(control:Control, keys:Array<FlxKey>)
	{
		var copyKeys:Array<FlxKey> = keys.copy();
		for (i in 0...copyKeys.length) {
			if(i == NONE) copyKeys.remove(i);
		}

		#if (haxe >= "4.0.0")
		inline forEachBound(control, (action, state) -> addKeys(action, copyKeys, state));
		#else
		forEachBound(control, function(action, state) addKeys(action, copyKeys, state));
		#end
	}

	/**
	 * Sets all actions that pertain to the binder to trigger when the supplied keys are used.
	 * If binder is a literal you can inline this
	 */
	public function unbindKeys(control:Control, keys:Array<FlxKey>)
	{
		var copyKeys:Array<FlxKey> = keys.copy();
		for (i in 0...copyKeys.length) {
			if(i == NONE) copyKeys.remove(i);
		}

		#if (haxe >= "4.0.0")
		inline forEachBound(control, (action, _) -> removeKeys(action, copyKeys));
		#else
		forEachBound(control, function(action, _) removeKeys(action, copyKeys));
		#end
	}

	inline static function addKeys(action:FlxActionDigital, keys:Array<FlxKey>, state:FlxInputState)
	{
		for (key in keys)
			if(key != NONE)
				action.addKey(key, state);
	}

	static function removeKeys(action:FlxActionDigital, keys:Array<FlxKey>)
	{
		var i = action.inputs.length;
		while (i-- > 0)
		{
			var input = action.inputs[i];
			if (input.device == KEYBOARD && keys.indexOf(cast input.inputID) != -1)
				action.remove(input);
		}
	}

	public function setKeyboardScheme(scheme:KeyboardScheme, reset = true)
	{
		if (reset)
			removeKeyboard();

		keyboardScheme = scheme;
		var keysMap = ClientPrefs.keyBinds;
		
		#if (haxe >= "4.0.0")
		switch (scheme)
		{
			case Solo |	Duo(true) | Duo(false):	//too much spam
				inline bindKeys(Control.UI_UP, keysMap.get('ui_up'));
				inline bindKeys(Control.UI_DOWN, keysMap.get('ui_down'));
				inline bindKeys(Control.UI_LEFT, keysMap.get('ui_left'));
				inline bindKeys(Control.UI_RIGHT, keysMap.get('ui_right'));
				inline bindKeys(Control.NOTE_UP, keysMap.get('note_up'));
				inline bindKeys(Control.NOTE_DOWN, keysMap.get('note_down'));
				inline bindKeys(Control.NOTE_LEFT, keysMap.get('note_left'));
				inline bindKeys(Control.NOTE_RIGHT, keysMap.get('note_right'));

				inline bindKeys(Control.ACCEPT, keysMap.get('accept'));
				inline bindKeys(Control.BACK, keysMap.get('back'));
				inline bindKeys(Control.PAUSE, keysMap.get('pause'));
				inline bindKeys(Control.RESET, keysMap.get('reset'));

				inline bindKeys(Control.ONE1, keysMap.get('note_one1'));

				inline bindKeys(Control.TWO1, keysMap.get('note_two1'));
				inline bindKeys(Control.TWO2, keysMap.get('note_two2'));
				
				inline bindKeys(Control.THREE1, keysMap.get('note_three1'));
				inline bindKeys(Control.THREE2, keysMap.get('note_three2'));
				inline bindKeys(Control.THREE3, keysMap.get('note_three3'));

				inline bindKeys(Control.FIVE1, keysMap.get('note_five1'));
				inline bindKeys(Control.FIVE2, keysMap.get('note_five2'));
				inline bindKeys(Control.FIVE3, keysMap.get('note_five3'));
				inline bindKeys(Control.FIVE4, keysMap.get('note_five4'));
				inline bindKeys(Control.FIVE5, keysMap.get('note_five5'));

				inline bindKeys(Control.SIX1, keysMap.get('note_six1'));
				inline bindKeys(Control.SIX2, keysMap.get('note_six2'));
				inline bindKeys(Control.SIX3, keysMap.get('note_six3'));
				inline bindKeys(Control.SIX4, keysMap.get('note_six4'));
				inline bindKeys(Control.SIX5, keysMap.get('note_six5'));
				inline bindKeys(Control.SIX6, keysMap.get('note_six6'));

				inline bindKeys(Control.SEVEN1, keysMap.get('note_seven1'));
				inline bindKeys(Control.SEVEN2, keysMap.get('note_seven2'));
				inline bindKeys(Control.SEVEN3, keysMap.get('note_seven3'));
				inline bindKeys(Control.SEVEN4, keysMap.get('note_seven4'));
				inline bindKeys(Control.SEVEN5, keysMap.get('note_seven5'));
				inline bindKeys(Control.SEVEN6, keysMap.get('note_seven6'));
				inline bindKeys(Control.SEVEN7, keysMap.get('note_seven7'));

				inline bindKeys(Control.EIGHT1, keysMap.get('note_eight1'));
				inline bindKeys(Control.EIGHT2, keysMap.get('note_eight2'));
				inline bindKeys(Control.EIGHT3, keysMap.get('note_eight3'));
				inline bindKeys(Control.EIGHT4, keysMap.get('note_eight4'));
				inline bindKeys(Control.EIGHT5, keysMap.get('note_eight5'));
				inline bindKeys(Control.EIGHT6, keysMap.get('note_eight6'));
				inline bindKeys(Control.EIGHT7, keysMap.get('note_eight7'));
				inline bindKeys(Control.EIGHT8, keysMap.get('note_eight8'));

				inline bindKeys(Control.NINE1, keysMap.get('note_nine1'));
				inline bindKeys(Control.NINE2, keysMap.get('note_nine2'));
				inline bindKeys(Control.NINE3, keysMap.get('note_nine3'));
				inline bindKeys(Control.NINE4, keysMap.get('note_nine4'));
				inline bindKeys(Control.NINE5, keysMap.get('note_nine5'));
				inline bindKeys(Control.NINE6, keysMap.get('note_nine6'));
				inline bindKeys(Control.NINE7, keysMap.get('note_nine7'));
				inline bindKeys(Control.NINE8, keysMap.get('note_nine8'));
				inline bindKeys(Control.NINE9, keysMap.get('note_nine9'));

				/*inline bindKeys(Control.TEN1, keysMap.get('note_ten1'));
				inline bindKeys(Control.TEN2, keysMap.get('note_ten2'));
				inline bindKeys(Control.TEN3, keysMap.get('note_ten3'));
				inline bindKeys(Control.TEN4, keysMap.get('note_ten4'));
				inline bindKeys(Control.TEN5, keysMap.get('note_ten5'));
				inline bindKeys(Control.TEN6, keysMap.get('note_ten6'));
				inline bindKeys(Control.TEN7, keysMap.get('note_ten7'));
				inline bindKeys(Control.TEN8, keysMap.get('note_ten8'));
				inline bindKeys(Control.TEN9, keysMap.get('note_ten9'));
				inline bindKeys(Control.TEN10, keysMap.get('note_ten10'));*/
			case None: // nothing
			case Custom: // nothing
		}
		#else
		switch (scheme)
		{
			case Solo:
				bindKeys(Control.UI_UP, [W, FlxKey.UP]);
				bindKeys(Control.UI_DOWN, [S, FlxKey.DOWN]);
				bindKeys(Control.UI_LEFT, [A, FlxKey.LEFT]);
				bindKeys(Control.UI_RIGHT, [D, FlxKey.RIGHT]);
				bindKeys(Control.NOTE_UP, [W, FlxKey.UP]);
				bindKeys(Control.NOTE_DOWN, [S, FlxKey.DOWN]);
				bindKeys(Control.NOTE_LEFT, [A, FlxKey.LEFT]);
				bindKeys(Control.NOTE_RIGHT, [D, FlxKey.RIGHT]);
				bindKeys(Control.ACCEPT, [Z, SPACE, ENTER]);
				bindKeys(Control.BACK, [BACKSPACE, ESCAPE]);
				bindKeys(Control.PAUSE, [P, ENTER, ESCAPE]);
				bindKeys(Control.RESET, [R]);
			case None: // nothing
			case Custom: // nothing
		}
		#end
	}

	function removeKeyboard()
	{
		for (action in this.digitalActions)
		{
			var i = action.inputs.length;
			while (i-- > 0)
			{
				var input = action.inputs[i];
				if (input.device == KEYBOARD)
					action.remove(input);
			}
		}
	}

	public function addGamepad(id:Int, ?buttonMap:Map<Control, Array<FlxGamepadInputID>>):Void
	{
		gamepadsAdded.push(id);
		
		#if (haxe >= "4.0.0")
		for (control => buttons in buttonMap)
			inline bindButtons(control, id, buttons);
		#else
		for (control in buttonMap.keys())
			bindButtons(control, id, buttonMap[control]);
		#end
	}

	inline function addGamepadLiteral(id:Int, ?buttonMap:Map<Control, Array<FlxGamepadInputID>>):Void
	{
		gamepadsAdded.push(id);

		#if (haxe >= "4.0.0")
		for (control => buttons in buttonMap)
			inline bindButtons(control, id, buttons);
		#else
		for (control in buttonMap.keys())
			bindButtons(control, id, buttonMap[control]);
		#end
	}

	public function removeGamepad(deviceID:Int = FlxInputDeviceID.ALL):Void
	{
		for (action in this.digitalActions)
		{
			var i = action.inputs.length;
			while (i-- > 0)
			{
				var input = action.inputs[i];
				if (input.device == GAMEPAD && (deviceID == FlxInputDeviceID.ALL || input.deviceID == deviceID))
					action.remove(input);
			}
		}

		gamepadsAdded.remove(deviceID);
	}

	public function addDefaultGamepad(id):Void
	{
		#if !switch
		addGamepadLiteral(id, [
			Control.ACCEPT => [A, START],
			Control.BACK => [B],
			Control.UI_UP => [DPAD_UP, LEFT_STICK_DIGITAL_UP],
			Control.UI_DOWN => [DPAD_DOWN, LEFT_STICK_DIGITAL_DOWN],
			Control.UI_LEFT => [DPAD_LEFT, LEFT_STICK_DIGITAL_LEFT],
			Control.UI_RIGHT => [DPAD_RIGHT, LEFT_STICK_DIGITAL_RIGHT],
			Control.NOTE_UP => [DPAD_UP, LEFT_STICK_DIGITAL_UP, RIGHT_STICK_DIGITAL_UP, Y],
			Control.NOTE_DOWN => [DPAD_DOWN, LEFT_STICK_DIGITAL_DOWN, RIGHT_STICK_DIGITAL_DOWN, A],
			Control.NOTE_LEFT => [DPAD_LEFT, LEFT_STICK_DIGITAL_LEFT, RIGHT_STICK_DIGITAL_LEFT, X],
			Control.NOTE_RIGHT => [DPAD_RIGHT, LEFT_STICK_DIGITAL_RIGHT, RIGHT_STICK_DIGITAL_RIGHT, B],
			Control.PAUSE => [START],
			Control.RESET => [8]
		]);
		#else
		addGamepadLiteral(id, [
			//Swap A and B for switch
			Control.ACCEPT => [B, START],
			Control.BACK => [A],
			Control.UI_UP => [DPAD_UP, LEFT_STICK_DIGITAL_UP, RIGHT_STICK_DIGITAL_UP],
			Control.UI_DOWN => [DPAD_DOWN, LEFT_STICK_DIGITAL_DOWN, RIGHT_STICK_DIGITAL_DOWN],
			Control.UI_LEFT => [DPAD_LEFT, LEFT_STICK_DIGITAL_LEFT, RIGHT_STICK_DIGITAL_LEFT],
			Control.UI_RIGHT => [DPAD_RIGHT, LEFT_STICK_DIGITAL_RIGHT, RIGHT_STICK_DIGITAL_RIGHT],
			Control.NOTE_UP => [DPAD_UP, LEFT_STICK_DIGITAL_UP, RIGHT_STICK_DIGITAL_UP, X],
			Control.NOTE_DOWN => [DPAD_DOWN, LEFT_STICK_DIGITAL_DOWN, RIGHT_STICK_DIGITAL_DOWN, B],
			Control.NOTE_LEFT => [DPAD_LEFT, LEFT_STICK_DIGITAL_LEFT, RIGHT_STICK_DIGITAL_LEFT, Y],
			Control.NOTE_RIGHT => [DPAD_RIGHT, LEFT_STICK_DIGITAL_RIGHT, RIGHT_STICK_DIGITAL_RIGHT, A],
			Control.PAUSE => [START],
			Control.RESET => [8]
		]);
		#end
	}

	/**
	 * Sets all actions that pertain to the binder to trigger when the supplied keys are used.
	 * If binder is a literal you can inline this
	 */
	public function bindButtons(control:Control, id, buttons)
	{
		#if (haxe >= "4.0.0")
		inline forEachBound(control, (action, state) -> addButtons(action, buttons, state, id));
		#else
		forEachBound(control, function(action, state) addButtons(action, buttons, state, id));
		#end
	}

	/**
	 * Sets all actions that pertain to the binder to trigger when the supplied keys are used.
	 * If binder is a literal you can inline this
	 */
	public function unbindButtons(control:Control, gamepadID:Int, buttons)
	{
		#if (haxe >= "4.0.0")
		inline forEachBound(control, (action, _) -> removeButtons(action, gamepadID, buttons));
		#else
		forEachBound(control, function(action, _) removeButtons(action, gamepadID, buttons));
		#end
	}

	inline static function addButtons(action:FlxActionDigital, buttons:Array<FlxGamepadInputID>, state, id)
	{
		for (button in buttons)
			action.addGamepad(button, state, id);
	}

	static function removeButtons(action:FlxActionDigital, gamepadID:Int, buttons:Array<FlxGamepadInputID>)
	{
		var i = action.inputs.length;
		while (i-- > 0)
		{
			var input = action.inputs[i];
			if (isGamepad(input, gamepadID) && buttons.indexOf(cast input.inputID) != -1)
				action.remove(input);
		}
	}

	public function getInputsFor(control:Control, device:Device, ?list:Array<Int>):Array<Int>
	{
		if (list == null)
			list = [];

		switch (device)
		{
			case Keys:
				for (input in getActionFromControl(control).inputs)
				{
					if (input.device == KEYBOARD)
						list.push(input.inputID);
				}
			case Gamepad(id):
				for (input in getActionFromControl(control).inputs)
				{
					if (input.deviceID == id)
						list.push(input.inputID);
				}
		}
		return list;
	}

	public function removeDevice(device:Device)
	{
		switch (device)
		{
			case Keys:
				setKeyboardScheme(None);
			case Gamepad(id):
				removeGamepad(id);
		}
	}

	static function isDevice(input:FlxActionInput, device:Device)
	{
		return switch device
		{
			case Keys: input.device == KEYBOARD;
			case Gamepad(id): isGamepad(input, id);
		}
	}

	inline static function isGamepad(input:FlxActionInput, deviceID:Int)
	{
		return input.device == GAMEPAD && (deviceID == FlxInputDeviceID.ALL || input.deviceID == deviceID);
	}
}