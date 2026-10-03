# EGG is an abbrivation of Eclt Game Global.
extends Node
# Fields
var MainPlayer:CharacterBody2D = null
var PlayerUserName:String = "Player"
var ISVirtualKeyMovementPressed:bool = false
var OSType:String = "E" if OS.get_name() == \
  "Android" or OS.get_name() == "IOS" else "C"
# Functions
# 初始化动作
func _ready() -> void:
	get_tree().node_added.connect(EGG.add_default_action)
#region 默认动作
# 添加默认动作
func add_default_action(node:Node):
	# 按钮(触发_pressed信号)
	if node is Button: # 类型断言
		var button:Button = node as Button
		
func default_action_button():
	pass
#endregion
