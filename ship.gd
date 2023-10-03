extends RigidBody3D

@export var max_speed: float = 10
@export var roll_speed: float = 1
@export var yaw_speed: float = 1
@export var pitch_speed: float = 1
@export var acceleration: float = 1

var force: Vector3 = Vector3.ZERO
@onready var collision_shape_3d = $CollisionShape3D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if Input.is_action_pressed("pitch_up"):
		collision_shape_3d.rotate_object_local(Vector3.FORWARD, -pitch_speed * delta)
	if Input.is_action_pressed("pitch_down"):
		collision_shape_3d.rotate_object_local(Vector3.FORWARD, pitch_speed * delta)
	if Input.is_action_pressed("roll_clockwise"):
		collision_shape_3d.rotate_object_local(Vector3.UP, roll_speed * delta)
	if Input.is_action_pressed("roll_counter_clockwise"):
		collision_shape_3d.rotate_object_local(Vector3.UP, -roll_speed * delta)
	if Input.is_action_pressed("yaw_left"):
		collision_shape_3d.rotate_object_local(Vector3.RIGHT, -yaw_speed * delta)
	if Input.is_action_pressed("yaw_right"):
		collision_shape_3d.rotate_object_local(Vector3.RIGHT, yaw_speed * delta)
	
	var p1 = collision_shape_3d.to_global(Vector3.ZERO)
	var p2 = collision_shape_3d.to_global(Vector3.UP)
	
	force = acceleration * (p2 - p1)
	
	apply_central_force(force)
