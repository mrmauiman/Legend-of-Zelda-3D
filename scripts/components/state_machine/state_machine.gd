class_name StateMachine extends Node3D

var state;

var _states = [];

func _ready():
	for st in get_children():
		_states.push_back(st.name);
	state = get_child(0);
	state.call_deferred("enter", null, []);

func change_state(new_state: String, ...params):
	if not has_node(new_state): 
		print("State: ", new_state, " does not exist on ", get_parent());
		return;
	var next_state = get_node(new_state);
	state.call_deferred("exit", next_state);
	next_state.call_deferred("enter", state, params);
	state = next_state;

func current_state_is(state_string: String) -> bool:
	return state.name == state_string;

func get_current_state() -> String:
	return state.name;

func has_state(state_name: String) -> bool:
	return state_name in _states;

func _process(delta):
	state.update(delta);

func _physics_process(delta):
	state.physics_update(delta);
