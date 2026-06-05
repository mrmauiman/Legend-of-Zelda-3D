extends Button

func save():
	Inventory.save_data(Inventory.current_slot);
	EnemyTracker.save_data(Inventory.current_slot);
