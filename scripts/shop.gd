extends Panel

@onready var shop_item = preload("res://ui/shop_item.tscn")
@onready var player = Global.player

@export var item_pool: Array[ShopItem]
var cur_items = [] #Array[ShopItem] = []

func _ready() -> void:
	setup_shop()

func setup_shop() -> void:
	for i in get_child(0).get_children():
		i.queue_free()
	cur_items = []
	for i in 5:
		cur_items.append(item_pool.pick_random())
		var item = shop_item.instantiate()
		get_child(0).add_child(item)
		item.get_child(0).text = str(cur_items[i].cost)
		item.get_child(1).tooltip_text = cur_items[i].description
		item.get_child(2).texture = cur_items[i].image
		item.get_child(3).pressed.connect(buy_item)


func buy_item() -> void:
	for i in get_child(0).get_children():
		if i.get_child(3).button_pressed:
			var id = i.get_index()
			if cur_items[id].cost > player.chips: return
			player.chips -= cur_items[id].cost
			
			if cur_items[id].item is WheelSlot:
				player.ui.wheel.start_replacing(cur_items[id].item)
				
			elif cur_items[id].item.is_class("ItemEquipped"):
				var item = cur_items[id].item.instantiate()
				player.get_node("passive_items").add_child(item)
				
			cur_items[id] = null
			i.queue_free()
