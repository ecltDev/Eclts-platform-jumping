extends Control

var is_mouse_pressed:bool = false
var is_maximized:bool = false
@onready var window_size_restore:Vector2 = self.size
@onready var window_position_restore:Vector2 = self.position

enum ColorChangeType{
	ENTER,ESCAPE
}

# 当拖拽
func _on_drag(event: InputEvent,source :Control) -> void:
	# 手机端输入处理
	if event is InputEventScreenDrag:
		self.plsyer_change_window_transform(event,source)
	# 电脑端输入处理
	else: # Motion 和 Button 事件不同时存在
		# 使用Button实例记录状态 再使用 Mootion 计算拖动
		if event is InputEventMouseButton:
			self.is_mouse_pressed = event.is_pressed()
		# 计算拖拽
		elif event is InputEventMouseMotion and \
		  self.is_mouse_pressed:
			self.plsyer_change_window_transform(event,source)

# 玩家改变窗口变换(大小和位置)
# NOTE:使用事件实例确定变换类型 使用事件UI名字判断变换类型
func plsyer_change_window_transform(event:InputEvent,source:Control):
	# 标题拖拽
	if source.name == "TitleBackground":
		self.position += event.screen_relative
		self.window_position_restore = self.position
	# 调整尺寸
	elif source.name == "AdjustSize":
		var used_size:Vector2 = self.size + event.screen_relative
		self.size = Vector2(max(30,used_size.x),max(30,used_size.y))
		self.window_size_restore = self.size

# 当关闭窗口
func _on_close(event: InputEvent) -> void:
	if event is InputEventScreenTouch or \
	  event is InputEventMouseButton and \
	  not event.is_pressed():
			self.get_parent().queue_free()

# 当(进入/退出)按钮
func _on_mouse_entered(source: ColorRect) -> void:
	self.change_button_color(self.ColorChangeType.ENTER,source)
func _on_mouse_exited(source: ColorRect) -> void:
	self.change_button_color(self.ColorChangeType.ESCAPE,source)

# 改变按钮颜色
func change_button_color(change_type:int,target:ColorRect):
	var used_color:Color
	if target.name != "Close":
		if change_type == self.ColorChangeType.ENTER:
			used_color = Color(0.369, 0.667, 0.667, 1.0)
		else:used_color = Color(0.667, 0.667, 0.667)
	elif target.name == "Close":
		if change_type == self.ColorChangeType.ENTER:
			used_color = Color(0.859, 0.201, 0.201, 1.0)
		else:used_color = Color(0.357, 0.62, 0.357)
	target.color = used_color
 
# 当最大化

func _on_maximize(event: InputEvent) -> void:
	if event is InputEventScreenTouch or \
	  event is InputEventMouseButton and \
	  not event.is_pressed():
		if not self.is_maximized:
			self.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
		else:
			self.set_anchors_preset(Control.PRESET_TOP_LEFT)
			self.position = self.window_position_restore
			self.size = self.window_size_restore
			self.is_maximized = true
