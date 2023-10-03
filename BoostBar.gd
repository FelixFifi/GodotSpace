extends ProgressBar

@onready var ship := %Ship

var cooldown_timer: Timer = null

# Called when the node enters the scene tree for the first time.
func _ready():
	ship.boost_activated.connect(boost_activated)
	
func boost_activated(event_duration_timer, event_cooldown_timer):
	cooldown_timer = event_cooldown_timer

func _process(delta):
	if cooldown_timer != null:
		value = cooldown_timer.wait_time - cooldown_timer.time_left
		max_value = cooldown_timer.wait_time
		
