extends Node
## 聊天文本管理器

# Singnals
@warning_ignore("unused_signal")
signal OnMessageSend(message:String)
#Fields
# 单个聊天文本
var TextItem:Resource = preload("res://scenes/UI/text_item.tscn")
# 消息历史
var MessageHistory:PackedStringArray = []
# 最大历史消息项目
const MaxHistoryItems:int = 8
# 切换历史消息功能中 当前消息的索引
var CurrentTextIndex:int
#Enums
# 消息切换类型
enum MessageToggleType{ 
	# NOTE:这是个枚举值对象 每1项都是整数 第1项为0 依次向下递增 可以用来比较
	LASTONE,NEXTONE
} # 上一个   下一个
#Functions
# 向聊天容器添加文本
func add_text(sended_text:String,who:String,message_container:BoxContainer) -> Control:
	if who == null:who = "[color=blue][系统消息][/color]"
	# 新建一个聊天文本项目
	var new_text:RichTextLabel = ChattingManager.TextItem.instantiate()
	# 容器添加子级 & 设置文本
	message_container.add_child(new_text)
	new_text.text = "[%s]%s" %[who,sended_text]
	# 管理历史聊天消息数组
	if who == EGG.PlayerUserName: # 添加
		ChattingManager.MessageHistory.append(sended_text)
		# 移除多余(根据最大消息数量判断)
		if ChattingManager.MessageHistory.size() > self.MaxHistoryItems:
			ChattingManager.MessageHistory.remove_at(0)
		# 更新当前选择消息索引
		ChattingManager.CurrentTextIndex = \
		  ChattingManager.MessageHistory.size()
		# 发送信号到全局单例
		ChattingManager.OnMessageSend.emit(sended_text)
	# 等待一帧并设置滚动Y
	await get_tree().process_frame
	message_container.get_parent().scroll_vertical += new_text.size.y + 5
	if message_container.get_child_count() == 1:
		message_container.get_parent().scroll_vertical += 5
	return new_text
func message_toggle(toggle_type:int) -> String:
	if ChattingManager.MessageHistory.size() != 0:
		# 获取文本(防止出数组界)
		var new_index:int = ChattingManager.CurrentTextIndex - (
			1 if toggle_type == ChattingManager.MessageToggleType.LASTONE else -1)
		if new_index >= 0 and new_index < ChattingManager.MessageHistory.size():
			ChattingManager.CurrentTextIndex = new_index
			return ChattingManager.MessageHistory[ChattingManager.CurrentTextIndex]
		else:return ""
	else:return ""
