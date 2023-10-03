extends Node3D

var checkpoints: Dictionary = {}
var checkpoints_hit := 0

signal checkpoint_hit(current, goal)

# Called when the node enters the scene tree for the first time.
func _ready():
	for child in get_children():
		if child is Area3D:
			child.body_entered.connect(_on_checkpoint_entered.bind(child))
			checkpoints[child] = false 

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _on_checkpoint_entered(body: Node3D, checkpoint: Area3D):
	if !checkpoints[checkpoint]:
		checkpoints[checkpoint] = true
		checkpoints_hit += 1
		checkpoint_hit.emit(checkpoints_hit, checkpoints.size())
	
