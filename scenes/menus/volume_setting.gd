extends HBoxContainer

class_name VolumeSetting

@export var busName : String = "Master"
@export var busIndex : int = 0

var volumePercentByBusIndex = {}
var volumeLevel : int

func _ready():
	updateBusName()
	updateVolume()
	if volumePercentByBusIndex.has(busIndex):
		$volume_slider.value = volumePercentByBusIndex[busIndex]
	else:
		$volume_slider.value = 50.0
		
func updateBusName():
	$bus_name.text = busName

func updateVolume():
	volumeLevel = $volume_slider.value
	$volume_level.text = str(floor(volumeLevel))

func convertPercentToDecibels(percent):
	
	var scale = 20.0
	var divisor = 50.0
	return scale * log(percent/divisor)
	
	


func _on_volume_slider_value_changed(value):
	updateVolume()
	volumePercentByBusIndex[busIndex] = value
	if value == 0:
		AudioServer.set_bus_mute(busIndex, true)
		return 0
	
	if AudioServer.is_bus_mute(busIndex):
		AudioServer.set_bus_mute(busIndex, false)
	var decibels = convertPercentToDecibels(value)
	AudioServer.set_bus_volume_db(busIndex, decibels)
