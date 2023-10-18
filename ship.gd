class_name Ship
extends RigidBody3D

const MAX_DEAD_SHIPS = 5

@export var max_speed: float = 10
@export var roll_speed: float = 1
@export var yaw_speed: float = 0.2
@export var pitch_speed: float = 1
@export var max_acceleration := 30
@export var acceleration: float = 5
@export var throttle_speed := 15
@export var boost_acceleration := 100

signal throttle_changed(value, max_value)
signal boost_activated(duration_timer, cooldown_timer)
signal respawned(new_ship)

var force: Vector3 = Vector3.ZERO
var normal_accleration := 0.0
var boost_active := false
var dead = false
var dead_ships: Array[Ship] = []

@onready var collision_shape_3d = $CollisionShape3D
@onready var boost_cooldown = %BoostCooldown
@onready var boost_duration = %BoostDuration
@onready var cannon = %Cannon


func _process(delta):
	if dead:
		return

	if Input.is_action_just_pressed("respawn"):
		die()
		return

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
	if Input.is_action_pressed("throttle_up"):
		acceleration = clamp(acceleration + delta * throttle_speed, 0, max_acceleration)
	if Input.is_action_pressed("throttle_down"):
		acceleration = clamp(acceleration - delta * throttle_speed, 0, max_acceleration)

	if Input.is_action_pressed("boost") and boost_duration.is_stopped() and boost_cooldown.is_stopped():
			normal_accleration = acceleration
			boost_active = true
			boost_duration.start()
			boost_activated.emit(boost_duration, boost_cooldown)


	var p1 = collision_shape_3d.to_global(Vector3.ZERO)
	var p2 = collision_shape_3d.to_global(Vector3.UP)
	var forward = p2 - p1


	if Input.is_action_just_pressed("shoot_primary"):
		var projectile_scene := preload("res://projectile.tscn")
		var projectile : Projectile = projectile_scene.instantiate()
		projectile.add_collision_exception_with(self)
		projectile.position = to_local(cannon.to_global(Vector3.ZERO))
		projectile.linear_velocity = linear_velocity + projectile.speed * forward
		add_child(projectile)


	if boost_active:
		if !boost_duration.is_stopped():
			acceleration = boost_acceleration
		else:
			boost_active = false
			acceleration = normal_accleration
			boost_cooldown.start()

	throttle_changed.emit(acceleration, max_acceleration)

	force = acceleration * forward
	apply_central_force(force)

func _on_body_entered(body):
	lock_rotation = false
	die()

func die():
	if dead:
		return
	dead = true
	var fire_scene := preload("res://fire.tscn")
	var fire = fire_scene.instantiate()
	fire.scale = 2 * Vector3.ONE
	add_child(fire)


	var ship_scene := load("res://ship.tscn")
	var new_ship : Ship = ship_scene.instantiate()
	var spawn_point = get_parent()
	spawn_point.add_child(new_ship)
	new_ship.make_current()
	respawned.emit(new_ship)

	dead_ships.append(self)
	new_ship.expire_old_ships(dead_ships)

func make_current():
	var camera: Camera3D = $CollisionShape3D/ShipCamera
	camera.make_current()

func expire_old_ships(previous_ships: Array[Ship]):
	dead_ships = previous_ships

	if (dead_ships.size() > MAX_DEAD_SHIPS):
		var ship_to_expire : Ship = dead_ships.pop_front()
		ship_to_expire.queue_free()
