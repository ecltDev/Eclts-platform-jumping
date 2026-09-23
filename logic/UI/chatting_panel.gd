extends Control

var text_item:Resource = preload("res://sences/UI/text_item.tscn")
var message_history:PackedStringArray = []
const MAX_HISTORY_ITEMS:int = 8
var current_text_index:int

func _ready() -> void:
	if self.name != "Send":
		self.message_history = $"../Send".message_history

func _on_action_take() -> void:
	if self.name == "Fold":
		$"../..".visible = not $"../..".visible
	elif self.name == "Send" and $"../InputBox".text != "":
		# 添加文本
		var sended_text:String = $"../InputBox".text
		var new_text:RichTextLabel = self.text_item.instantiate()
		%ChattingMessagesView.add_child(new_text)
		new_text.text = sended_text
		self.message_history.append(sended_text)
		if self.message_history.size() > MAX_HISTORY_ITEMS:
			self.message_history.remove_at(0)
		self.current_text_index = self.message_history.size()
		# 重置文本
		$"../InputBox".text = ""
		$"%ChattingMessagesView".get_node("..").scroll_vertical += 100000
		EGG.OnMessageSend.emit(sended_text)
	elif self.name == "Clear":$"../InputBox".text = ""
	elif (self.name == "LastOne" or self.name == "NextOne") and \
	  self.message_history.size() != 0:
		# 更新文本
		self.current_text_index = $"../Send".current_text_index
		var new_index:int = self.current_text_index - (
			1 if self.name == "LastOne" else -1)
		if new_index >= 0 and new_index < self.message_history.size():
			$"../Send".current_text_index = new_index
			$"../InputBox".text = self.message_history[new_index]
