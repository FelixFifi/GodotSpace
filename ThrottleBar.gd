extends ProgressBar

@onready var ship := %Ship

# Called when the node enters the scene tree for the first time.
func _ready():
	ship.throttle_changed.connect(_on_throttle_changed)


func _on_throttle_changed(new_throttle, max_throttle):
	max_value = max_throttle
	value = new_throttle
	
