extends Label


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	self.text = "Hello"

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Turt_Kinem_signal_debug_st_changed(state):
	if(state==0):
		self.text = "ONGROUND"
	elif(state==1):
		self.text = "FLUTTER"
	elif(state==2):
		self.text = "FALLING"
	elif(state==3):
		self.text = "AIRBORN"
