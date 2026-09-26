extends Control

var text_item:Resource = preload("res://sences/UI/text_item.tscn")
var message_history:PackedStringArray = []
const MAX_HISTORY_ITEMS:int = 8
var current_text_index:int

func _ready() -> void:
	if self.name != "Send":
		self.message_history = $"../Send".message_history
	elif self.name == "ChattyPanel":
		ChattingManager.ChattyRootNode = self
		

func _on_action_take() -> void:
	# 折叠聊天界面
	if self.name == "Fold":
		$"../..".visible = not $"../..".visible
	# 发送文本
	elif self.name == "Send" and $"../InputBox".text != "":
		# 添加的文本
		var sended_text:String = $"../InputBox".text
		# 新建一个聊天文本项目
		var new_text:RichTextLabel = self.text_item.instantiate()
		# 容器添加子级 & 设置文本
		%ChattyMessagesView.add_child(new_text)
		new_text.text = sended_text
		# 管理历史聊天消息数组
		self.message_history.append(sended_text)
		if self.message_history.size() > MAX_HISTORY_ITEMS:
			self.message_history.remove_at(0)
		self.current_text_index = self.message_history.size()
		# 重置文本
		$"../InputBox".text = ""
		ChattingManager.OnMessageSend.emit(sended_text)
		# 等待一帧并设置滚动Y
		await get_tree().process_frame
		$"%ChattyMessagesView".get_node("..").scroll_vertical += new_text.size.y + 5
		if %ChattyMessagesView.get_child_count() == 1:
			$"%ChattyMessagesView".get_node("..").scroll_vertical += 5
	# 清除文本
	elif self.name == "Clear":$"../InputBox".text = ""
	
	# 切换历史文本
	elif (self.name == "LastOne" or self.name == "NextOne") and \
	  self.message_history.size() != 0:
		# 更新文本
		self.current_text_index = $"../Send".current_text_index
		var new_index:int = self.current_text_index - (
			1 if self.name == "LastOne" else -1)
		if new_index >= 0 and new_index < self.message_history.size():
			$"../Send".current_text_index = new_index
			$"../InputBox".text = self.message_history[new_index]
