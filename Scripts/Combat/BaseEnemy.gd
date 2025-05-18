extends Resource

@export var name: String = "Enemy Name" 
@export var introduction: String ="Enemy Introduction"
@export var death: String = "Enemy Dies!"
@export var hit: String = "Enemy Hits you."
@export var brutal: String = "Enemy lands a Brutal Hit..."
@export var miss: String = "The Enemy Missed"
@export var hurt: String = "Enemy is Hurt."
@export var crippled: String = "Enemy go hit by a Brutal Hit!"
@export var dodge: String = "Enemy Dodges."
@export var texture: Texture = null
@export var health: int = 1
@export var attack: int = 0
@export var margin: int = 0
@export var accuracy: int = 20
@export var evasion: int = 0
@export var reward: int = 0
@export var runchance: int = 20
@export var special_move: String = "None"
