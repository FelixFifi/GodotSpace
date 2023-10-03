extends Label

@onready var race_controller = %RaceController

const LABEL_FORMAT = "Checkpoints: {current}/{goal}"
const LABEL_FORMAT_WON = LABEL_FORMAT + "  YOU WON!"


# Called when the node enters the scene tree for the first time.
func _ready():
	race_controller.checkpoint_hit.connect(_on_race_controller_checkpoint_hit)

func _on_race_controller_checkpoint_hit(current, goal):
	var label_format = LABEL_FORMAT if current < goal else LABEL_FORMAT_WON
	
	text = label_format.format({"current": current, "goal": goal})
