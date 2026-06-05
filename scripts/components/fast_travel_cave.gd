extends Node3D

var location_id: String;
var item_location_id: String;

func _ready():
	var locations = [null, null, null, null];
	for cave in Randomizer.caves_map:
		var cave_name = Randomizer.caves_map[cave];
		if "fast_travel_cave" in cave_name:
			var index = int(cave_name.split("/")[1]);
			var screen_data = cave.split("_");
			# Convert screen coordinates to world coordinates 
			# 25.6 and 17.6 are the space between screens in the x and z directions respectively
			# 8 and 4 are half the total screens in the x and z directions respectively
			var x_coordinate = (float(screen_data[2]) * 25.6)-(25.6 * 8);
			var z_coordinate = -1 * ((float(screen_data[1]) * 17.6)-(17.6 * 4));
			var location = Vector3(x_coordinate, 0, z_coordinate);
			locations[index] = location;
	var my_index = int(location_id.split("/")[2]);
	var current_index = (my_index + 1)%4;
	var i = 1;
	while my_index != current_index:
		get_node("Door"+str(i)).teleport_to = locations[current_index];
		i += 1;
		# 4 is the total number of fast travel caves
		current_index = (current_index + 1)%4;
