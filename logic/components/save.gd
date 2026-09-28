extends Components
## 玩家存档
## 交互后在当前位置保存一次

func _ready() -> void: # 添加动作到触发区域动作组
	get_parent().get_node("TriggerArea").action_array.append(
		func(unit:Variant):
			# unit 是存档的根节点
			EGG.MainPlayer.respawn_position = unit.position
			TextManager.display_up_rising_text(unit,"[color=yellow]已设置重生点![/color]")
			unit.get_child(0).modulate = Color(0.0, 1.0, 0.0, 1.0)
	)
