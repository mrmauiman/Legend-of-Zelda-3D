class_name LetterSelector extends Sprite2D

var current_letter: int = 1:
	set(val):
		if val <= 0:
			current_letter = 8;
		elif val >= 9:
			current_letter = 1;
		else:
			current_letter = val;
		position = get_parent().get_node("Letter"+str(current_letter)).position;
