extends ProgressBar

@onready var ship := %Ship

var duration_timer: Timer = null
var default_color : Color = "fff"
var boost_color : Color = "f00"
var boost_active := false

# Called when the node enters the scene tree for the first time.
func _ready():
	ship.throttle_changed.connect(_on_throttle_changed)
	ship.boost_activated.connect(boost_activated)


func _on_throttle_changed(new_throttle, max_throttle):
	max_value = max_throttle
	value = new_throttle
	
func boost_activated(event_duration_timer, cooldown_timer):
	duration_timer = event_duration_timer
	boost_active = true

func _process(delta):
	if duration_timer != null:
		if !duration_timer.is_stopped():		
			remove_theme_stylebox_override("fill")
			var stylebox_boost = StyleBoxFlat.new()
			stylebox_boost.bg_color = boost_color
			add_theme_stylebox_override("fill", stylebox_boost)
		elif boost_active:
			boost_active = false
			
			remove_theme_stylebox_override("fill")
			var stylebox_default = StyleBoxFlat.new()
			stylebox_default.bg_color = default_color
			add_theme_stylebox_override("fill", stylebox_default)
			
