extends TextureRect

@export var boss: Texture2D
@export var stage2: Texture2D

func _ready() -> void:
	Global.connect("final_boss", Callable(self, "_on_final_boss"))
	Global.connect("stage_2", Callable(self, "_on_stage_2"))

func _on_final_boss():
	self.texture = boss
	
func _on_stage_2():
	if(self.texture != stage2):
		self.texture = stage2
