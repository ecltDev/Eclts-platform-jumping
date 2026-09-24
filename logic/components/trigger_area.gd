extends Components
class_name TRIGGER_AREA

var action_array:Array[Callable] # 动作组
@export_multiline() var hint_text:String = "按下[color=yellow][]O][/color]键进行交互" # 提示文本
@export var auto_size:bool = true # 自动设置大小为父节点
@export var trigger_target_name:String = "Player" # 触发目标名字
var trigger_target_name_string_packet:PackedStringArray
var hint_text_label:Node2D
# 刷新和初始化
func _reflash() -> void:self._ready()
func _ready() -> void:
	# 等待一帧
	await get_tree().process_frame
	# 自动设置大小
	if self.auto_size and "size" in self.get_parent():
		self.get_child(0).size = self.get_parent().size
	# 分割提示文本
	if hint_text != "":
		self.trigger_target_name_string_packet = \
		  trigger_target_name.split(",",true)
	# 刷新漂浮文本
	if self.hint_text_label != null:
		self.hint_text_label.text = self.hint_text
# 玩家交互
func player_interact() -> void:
	self._on_body_exited(null) # 删除漂浮文本
	for action:Callable in self.action_array: # 动作组
		action.call(self.get_parent())
# 玩家进入
func _on_body_entered(body: Node2D) -> void:
	if body.name in \
	  self.trigger_target_name_string_packet: # 创建漂浮文本
		self.hint_text_label = ( # 传入碰撞检测来适配高度
		  await EGG.display_floatting_text(self.get_child(0),self.hint_text))
# 玩家离开
func _on_body_exited(body: Node2D) -> void:
	if self.hint_text_label != null and \
	  (body == null or body.name in # 删除漂浮文本 \
	  self.trigger_target_name_string_packet):
		self.hint_text_label.queue_free()
