extends Node2D

class_name FirePlace

@export var torch_item: Inv_Item
@export var tooltip_message: String

var crafting_available
#signal craft_torch

#may change how this works for future recipes
var req_resource : Inv_Item = preload("res://scenes/items/inventory/inv_items/wood.tres")

@onready var key_guidelight = $GuideLightBlue
@onready var exit_guidelight = $GuideLightGreen

func _ready():
	pass
	
func set_key_guide(pos: Vector2):
	key_guidelight.visible = true
	key_guidelight.look_at(pos)
	
func set_exit_guide(pos: Vector2):
	exit_guidelight.visible = true
	exit_guidelight.look_at(pos)

func _physics_process(delta):
	$AnimatedSprite2D.play()
	if Input.is_action_just_pressed("interact") and crafting_available:
		# get crafting ready
		#craft_torch.emit()
		if Globals.inv.contains(req_resource):
			if Globals.inv.get_amount(req_resource) >= 2:	
				Globals.inv.remove_item(req_resource, 2)
				print("crafting... ", torch_item.name)	
				Globals.inv.insert(torch_item)
		
		await get_tree().create_timer(1).timeout


func _on_area_2d_body_entered(body):
	if body.has_method("player"):
		crafting_available = true
		if Globals.inv.contains(req_resource) and Globals.inv.get_amount(req_resource) >= 2:
			Globals.tooltip_update.emit(tooltip_message, true)
		
		
		


func _on_area_2d_body_exited(body):
	if body.has_method("player"):
		crafting_available = false
		Globals.tooltip_update.emit(tooltip_message, false)
