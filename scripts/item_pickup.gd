class_name ItemPickup
extends Area2D

@export var item: PackedScene
@onready var sprite = $Sprite2D

func _ready() -> void:
	pass

func picked_up() -> void:
	var i = item.instantiate()
	Global.player.get_node("passive_items").add_child(i)
	queue_free()


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		picked_up()
