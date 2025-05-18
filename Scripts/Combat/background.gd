extends TextureRect

@export var boss: Texture2D

func _ready() -> void:
	Global.connect("final_boss", Callable(self, "_on_final_boss"))

func _on_final_boss():
	self.texture = boss
