extends Resource

class_name GameData

@export var playerHealth: int
@export var playerMaxHealth: int

@export var savePos : Vector2
@export var playerSpeed : int
@export var currentLevel : int
@export var dungeonSeed : String
@export var playerInventory : Inventory


func update_playerHealth(value):
	playerHealth = value
	
func update_playerMaxHealth(value):
	playerMaxHealth = value
	

func update_savePos(pos):
	savePos = pos
	
func update_playerSpeed(value):
	playerSpeed = value
	
func update_currentLevel(lvl):
	currentLevel = lvl
	
func update_DungeonSeed(levelseed):
	dungeonSeed = levelseed
	
func update_playerInventory(inv):
	playerInventory = inv


