extends Sprite2D

enum BUTTONS {ACTION, SWORD, ITEM_1, ITEM_2, ITEM_3};

@export var button: BUTTONS = BUTTONS.ACTION;

func _process(_delta):
	match button:
		BUTTONS.ACTION:
			match Settings.controller_type:
				Settings.CONTROLLER_TYPES.XBOX:
					frame = 1;
				Settings.CONTROLLER_TYPES.PLAYSTATION:
					frame = 8;
				Settings.CONTROLLER_TYPES.SWITCH:
					frame = 0;
				Settings.CONTROLLER_TYPES.MOUSE_AND_KEYBOARD:
					frame = 11;
		BUTTONS.SWORD:
			match Settings.controller_type:
				Settings.CONTROLLER_TYPES.XBOX:
					frame = 0;
				Settings.CONTROLLER_TYPES.PLAYSTATION:
					frame = 2;
				Settings.CONTROLLER_TYPES.SWITCH:
					frame = 1;
				Settings.CONTROLLER_TYPES.MOUSE_AND_KEYBOARD:
					frame = 10;
		BUTTONS.ITEM_1:
			match Settings.controller_type:
				Settings.CONTROLLER_TYPES.XBOX:
					frame = 2;
				Settings.CONTROLLER_TYPES.PLAYSTATION:
					frame = 7;
				Settings.CONTROLLER_TYPES.SWITCH:
					frame = 3;
				Settings.CONTROLLER_TYPES.MOUSE_AND_KEYBOARD:
					frame = 12;
		BUTTONS.ITEM_2:
			match Settings.controller_type:
				Settings.CONTROLLER_TYPES.XBOX:
					frame = 3;
				Settings.CONTROLLER_TYPES.PLAYSTATION:
					frame = 9;
				Settings.CONTROLLER_TYPES.SWITCH:
					frame = 2;
				Settings.CONTROLLER_TYPES.MOUSE_AND_KEYBOARD:
					frame = 4;
		BUTTONS.ITEM_3:
			match Settings.controller_type:
				Settings.CONTROLLER_TYPES.XBOX:
					frame = 5;
				Settings.CONTROLLER_TYPES.PLAYSTATION:
					frame = 6;
				Settings.CONTROLLER_TYPES.SWITCH:
					frame = 4;
				Settings.CONTROLLER_TYPES.MOUSE_AND_KEYBOARD:
					frame = 13;
