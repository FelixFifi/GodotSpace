extends Node3D

var checkpoints: Dictionary = {}
var checkpoints_reached := 0

@onready var spawn_point = %SpawnPoint

signal checkpoint_hit(current, goal)

# Called when the node enters the scene tree for the first time.
func _ready():
	_load_checkpoints()
	spawn_point.ship_respawned.connect(_on_spawnpoint_ship_respawned)

func _load_checkpoints():
	for child in get_children():
		if child is Area3D:
			child.body_entered.connect(_on_checkpoint_entered.bind(child))
			checkpoints[child] = false

func _reset():
	checkpoints_reached = 0

	for key in checkpoints:
		checkpoints[key] = false

	checkpoint_hit.emit(0, checkpoints.size())

func _on_spawnpoint_ship_respawned(_new_ship):
	_reset()

func _on_checkpoint_entered(body: Node3D, checkpoint: Area3D):
	if !checkpoints[checkpoint]:
		checkpoints[checkpoint] = true
		checkpoints_reached += 1
		checkpoint_hit.emit(checkpoints_reached, checkpoints.size())

