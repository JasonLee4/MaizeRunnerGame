extends Button

@onready var item_visual = $CenterContainer/Panel/Item_Display
@onready var amount_text: Label = $CenterContainer/Panel/Label

func update(slot: Inventory_Slot):
	if !slot.item:
		item_visual.visible = false
		amount_text.visible = false
		
	else: 
		print("Update with item")
		item_visual.visible = true
		item_visual.texture = slot.item.texture
		
		amount_text.text = str(slot.amount)	
		amount_text.visible = (slot.amount > 1)
