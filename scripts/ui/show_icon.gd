extends Button

const BLANK_FRAME = 47;
const HEART_FRAME = 46;

func _ready():
	focus_entered.connect(_focus_entered);
	focus_exited.connect(_focus_exited);

func _focus_entered():
	$Selector2.frame = HEART_FRAME;

func _focus_exited():
	$Selector2.frame = BLANK_FRAME;
