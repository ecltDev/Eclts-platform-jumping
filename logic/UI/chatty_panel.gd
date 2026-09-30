extends Control

func _ready() -> void:
	if self.name == "ChattyPanel":
		$"OpreatPanel/InputBox".text_submitted.connect(
			ChattingManager.add_text.bind(
				EGG.PlayerUserName,
				%ChattyMessagesView
			))

# 点击动作
func _on_action_take() -> void:
	# 折叠聊天界面
	if self.name == "Fold":
		$"../..".visible = not $"../..".visible

	# 清除文本
	elif self.name == "Clear":$"../InputBox".text = ""
	
	# 发送文本
	elif self.name == "Send": # 添加文本(通过发送按钮)
		ChattingManager.add_text( # 参数为:文本 名字 容器
		$"../InputBox".text,EGG.PlayerUserName,%ChattyMessagesView)
		$"../InputBox".text = ""
	
	# 切换历史文本(获取文本)
	elif (self.name == "LastOne" or self.name == "NextOne"):
		# 新建表达式 & 编码 
		# NOTE:expression表达式在真空中运行 不认识全局单例
		var expe:Expression = Expression.new()
		expe.parse("ChattingManager.MessageToggleType." + 
			self.name.to_upper(),["ChattingManager"])
		# 执行 & 获取
		var text:String = ChattingManager.message_toggle(
			expe.execute([ChattingManager]))
		if text != "":
			$"../InputBox".text = text
