extends Panel

@onready var shop_item = preload("res://ui/shop_item.tscn")

func _ready() -> void:
	setup_shop()

func setup_shop() -> void:
	for i in get_child(0).get_children():
		i.queue_free()
	for i in 5:
		var item = shop_item.instantiate()
		get_child(0).add_child(item)
