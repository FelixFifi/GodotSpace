extends Node3D

signal ship_respawned(new_ship)
@onready var ship: Ship = %Ship

func _ready():
	ship.respawned.connect(_on_ship_respawned)

# Forwards the signal to other nodes while centralizing the event rebinding
func _on_ship_respawned(new_ship):
	ship.respawned.disconnect(_on_ship_respawned)
	new_ship.respawned.connect(_on_ship_respawned)
	
	ship_respawned.emit(new_ship)
	
	ship = new_ship
