extends Node3D

const PAY_ME_PHRASE: String = "PAY ME AND I'LL TALK.";
const NOT_ENOUGH_PHRASE: String = "THIS AIN'T ENOUGH TO TALK!";
const TOO_MUCH_PHRASE: String = "BOY, YOU'RE RICH!";

const PAYMENT_SCENE: PackedScene = preload("res://scenes/npcs/payment.tscn");

enum CHOICES {LOW, MEDIUM, HIGH};

@export_multiline var info: String;
@export var low_amount: int = 10;
@export var medium_amount: int = 30;
@export var high_amount: int = 50;
@export var right_choice: CHOICES = CHOICES.MEDIUM;

var low_payment;
var good_payment;
var high_payment;


func clear_payments():
	if low_payment:
		low_payment.queue_free();
	if good_payment:
		good_payment.queue_free();
	if high_payment:
		high_payment.queue_free();

func paid(p_text):
	%Text.change_text(p_text);
	%Text.reveal = true;
	low_payment.queue_free();
	good_payment.queue_free();
	high_payment.queue_free();

func spawn_payments():
	low_payment = PAYMENT_SCENE.instantiate();
	low_payment.cost = low_amount;
	low_payment.position = Vector3(-3.2, 0, 2.4);
	add_child(low_payment);
	if right_choice != CHOICES.LOW:
		low_payment.paid.connect(paid.bind(NOT_ENOUGH_PHRASE));
	else:
		low_payment.paid.connect(paid.bind(info));
	
	good_payment = PAYMENT_SCENE.instantiate();
	good_payment.cost = medium_amount;
	good_payment.position = Vector3(0, 0, 2.4);
	add_child(good_payment);
	if right_choice == CHOICES.LOW:
		good_payment.paid.connect(paid.bind(TOO_MUCH_PHRASE));
	elif right_choice == CHOICES.MEDIUM:
		good_payment.paid.connect(paid.bind(info));
	else:
		good_payment.paid.connect(paid.bind(NOT_ENOUGH_PHRASE));
	
	high_payment = PAYMENT_SCENE.instantiate();
	high_payment.cost = high_amount;
	high_payment.position = Vector3(3.2, 0, 2.4);
	add_child(high_payment);
	if right_choice != CHOICES.HIGH:
		high_payment.paid.connect(paid.bind(TOO_MUCH_PHRASE));
	else:
		high_payment.paid.connect(paid.bind(info));

func _on_text_trigger_body_entered(body):
	if body.is_in_group("Link"):
		%Text.change_text(PAY_ME_PHRASE);
		%Text.reveal = true;
		%Text.reveal_complete.connect(spawn_payments, CONNECT_ONE_SHOT);

func _on_text_trigger_body_exited(body):
	if body.is_in_group("Link"):
		clear_payments();
