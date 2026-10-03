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
	pass

##region 默认动作(INIT)
	## 为动态添加节点设置默认动作
	#get_tree().node_added.connect(EGG._add_default_action)
	#await get_tree().process_frame
	## 为静态添加节点设置动作
	#EGG._add_default_action_static(get_tree().root.get_children(true))
##endregion

##region 默认动作(Functions)
#func _add_default_action_static(children:Array[Node]):
	#for nodes in children:
		#EGG._add_default_action(nodes)
		#EGG._add_default_action_static(nodes.get_children(true))
#
## 添加默认动作(也可以包含初始动作)
#func _add_default_action(node:Node):
	## 按钮(触发_pressed信号)
	#if node is Button:
		#node.gui_input.connect(
			#EGG.default_action_button_gui_input.bind(node))
#
#func default_action_button_gui_input(event:InputEvent,button:Button):
	#if event is InputEventScreenTouch:
		#button.set_pressed_no_signal(event.is_pressed())
		#if not event.is_pressed():
			#button.pressed.emit()
##endregion
