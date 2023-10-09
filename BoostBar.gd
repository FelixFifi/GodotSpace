extends ProgressBar

@onready var spawn_point: SpawnPoint = %SpawnPoint

var ship : Ship
var cooldown_timer: Timer = null

# Called when the node enters the scene tree for the first time.
func _ready():
	ship = spawn_point.get_ship()
	spawn_point.ship_respawned.connect(_on_spawnpoint_ship_respawned)
	ship.boost_activated.connect(_boost_activated)

func _on_spawnpoint_ship_respawned(new_ship):
	ship.boost_activated.disconnect(_boost_activated)
	new_ship.boost_activated.connect(_boost_activated)

	cooldown_timer = null
	value = max_value

	ship = new_ship


func _boost_activated(event_duration_timer, event_cooldown_timer):
	cooldown_timer = event_cooldown_timer

func _process(delta):
	if cooldown_timer != null:
		value = cooldown_timer.wait_time - cooldown_timer.time_left
		max_value = cooldown_timer.wait_time

