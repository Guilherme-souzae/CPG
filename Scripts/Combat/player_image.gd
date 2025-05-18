extends TextureRect

@export var pfp: Texture2D

func _ready() -> void:
	Global.connect("change_pfp", Callable(self, "_on_change_pfp"))

func _on_change_pfp():
	self.texture = pfp
