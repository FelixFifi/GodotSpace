class_name Projectile
extends RigidBody3D

@export var speed := 100.0

func _on_body_entered(body):
	queue_free()

# TODO: Expire with time
