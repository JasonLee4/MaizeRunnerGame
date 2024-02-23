extends CanvasLayer

var heart: PackedScene = preload("res://scenes/ui/heart.tscn")
@onready var hotbar = $HotBar
@onready var health_counter: HBoxContainer = $HealthCounter/HBoxContainer
@onready var timer_label: Label = $GameTimer/TimerText
@onready var cur_lvl_label: Label = $CurrentLvl/LvlText
@onready var backpack = $backpack_menu

func _ready():
	# health
	Globals.connect("health_change", update_health)
	update_health()
	# inventory
	Globals.inv.connect("update", update_inventory)
	
	# level stats
	Globals.connect("lvl_start", start_timer)
	Globals.connect("lvl_end", stop_timer)
	
	#tooltip display
	Globals.connect("tooltip_update", update_tooltip)
	

func _process(delta):
	if Globals.lvl_time:
		timer_label.text = Globals.lvl_time
	
	if Globals.cur_lvl:
		cur_lvl_label.text = "Level " + str(Globals.cur_lvl)
		
	
	#if Input.is_action_just_pressed("open_inventory"):
		#$backpack_menu.visible = !$backpack_menu.visible


func update_health():
	# clear all hearts
	for child in health_counter.get_children():
		child.queue_free()
	# repopulate hearts
	for i in Globals.health:
		health_counter.add_child(heart.instantiate())
		
func update_inventory():
	hotbar.update_slots()
	backpack.update_slots()

func start_timer():
	Globals.lvl_start_time = Time.get_ticks_msec()
	
func stop_timer():
	Globals.lvl_end_time = Time.get_ticks_msec()

func update_tooltip(text, display):
	$Tooltip.apply_text(text, display)
