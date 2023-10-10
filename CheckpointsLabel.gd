extends Label

var race_controller

const LABEL_FORMAT = "Checkpoints: {current}/{goal}"
const LABEL_FORMAT_WON = "Race completed in {time}s!"


# Called when the node enters the scene tree for the first time.
func _ready():
	race_controller = owner.get_race_controller()
	race_controller.checkpoint_hit.connect(_on_race_controller_checkpoint_hit)
	race_controller.race_completed.connect(_on_race_completed)

func _on_race_controller_checkpoint_hit(current, goal):
	text = LABEL_FORMAT.format({"current": current, "goal": goal})

func _on_race_completed(time):
	text = LABEL_FORMAT_WON.format({"time": "%0.2f" % time})
