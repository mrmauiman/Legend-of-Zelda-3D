@abstract
class_name State extends Node3D

@onready var state_machine: StateMachine = get_parent();
@onready var character: CharacterBody3D = state_machine.get_parent();

@abstract
func enter(previous_state: State, params: Array);

@abstract
func exit(new_state: State);

@abstract
func update(delta);

@abstract
func physics_update(delta);
