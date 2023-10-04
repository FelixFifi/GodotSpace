extends ProgressBar

@onready var ship : Ship = %Ship
@onready var spawn_point = %SpawnPoint

var duration_timer: Timer = null
var default_color : Color = "00657f"
var boost_color : Color = "f00"
var boost_active := false

# Called when the node enters the scene tree for the first time.
func _ready():
	_bind_events()

func _bind_events():
	ship.throttle_changed.connect(_on_throttle_changed)
	ship.boost_activated.connect(_boost_activated)
	spawn_point.ship_respawned.connect(_on_spawnpoint_ship_respawned)


func _on_throttle_changed(new_throttle, max_throttle):
	max_value = max_throttle
	value = new_throttle
	
func _boost_activated(event_duration_timer, cooldown_timer):
	duration_timer = event_duration_timer
	boost_active = true

func _on_spawnpoint_ship_respawned(new_ship):
	ship.throttle_changed.disconnect(_on_throttle_changed)
	ship.boost_activated.disconnect(_boost_activated)
	
	duration_timer = null
	_set_normal_theme()
	
	ship = new_ship
	_bind_events()

func _process(delta):
	if duration_timer != null:
		if !duration_timer.is_stopped():		
			_set_boost_theme()
		elif boost_active:
			_set_normal_theme()

func _set_boost_theme():
	remove_theme_stylebox_override("fill")
	var stylebox_boost = StyleBoxFlat.new()
	stylebox_boost.bg_color = boost_color
	add_theme_stylebox_override("fill", stylebox_boost)

func _set_normal_theme():
	boost_active = false
			
	remove_theme_stylebox_override("fill")
	var stylebox_default = StyleBoxFlat.new()
	stylebox_default.bg_color = default_color
	add_theme_stylebox_override("fill", stylebox_default)
