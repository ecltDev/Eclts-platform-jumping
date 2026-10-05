extends Control

#NOTE:手机端点击事件传入时序：
#InputEventScreenTouch(pressed:true) -> InputEventScreenMouseButton(pressed:true)
# -> InputEventScreenTouch(pressed:false) -> InputEventScreenMouseButton(pressed:false)

# 平台兼容
# 手机端防止重复点击
var is_screen_touched:bool = false
# 状态标记
var is_drag_bar_pressed:bool = false
var is_maximized:bool = false
var is_folded:bool = false
var is_folded_fullscreen:bool = false
var root:Control # 父组件
var close_action:int # 关闭动作类型
# 配置常量
var FOLD_SIZE_Y:float = 30
var          MIN_SIZE_Y:float = 30
@onready var MIN_SIZE_X:float
@onready var MAX_SIZE_Y:float = self.get_parent().size.y
@onready var MAX_SIZE_X:float = self.get_parent().size.x
@onready var size_y_no_folding:float = self.size.y
@onready var window_size_restore:Vector2 = self.size
@onready var window_position_restore:Vector2 = self.position
# 动态配置
var window_icon:Texture2D
var window_title:String
# 文本标签
@onready var adjust_size_button_label :Label = $AdjustSize/Label
@onready var maximize_button_label:Label = $TitleBackground/OperatePanel/Maximize/Label
@onready var fold_button_label:Label = $TitleBackground/OperatePanel/Fold/Label

enum ColorChangeType{
	ENTER,ESCAPE
}

# 当已初始化
func _ready() -> void:
	var operate_panel:GridContainer = $TitleBackground/OperatePanel
	# 初始化操作面板(修改x位置和大小)
	await get_tree().process_frame # 等待一帧
	operate_panel.offset_left = \
	  -30 * operate_panel.get_child_count()
	operate_panel.size.x = \
	  operate_panel.offset_left * -1
	self.MIN_SIZE_X = 30 * operate_panel.get_child_count() + 30
	# 设置标题文本锚点右偏移
	$TitleBackground/TitleText.offset_right = - operate_panel.size.x
	# 连接操作面板按钮的event信号
	for nodes:Control in operate_panel.get_children():
		nodes.gui_input.connect(self.screen_touch_state_update)
	await get_tree().process_frame # 等待一帧
	self.refresh_attributes()
 
# 刷新自定义属性
func refresh_attributes() -> void:
	self.root = self.get_parent()
	# 最小窗口尺寸
	self.MAX_SIZE_Y = self.root.size.y
	self.MAX_SIZE_X = self.root.size.x
	# 标题和图标
	$TitleBackground/IconTexture.texture = self.window_icon
	$TitleBackground/TitleText.text = self.window_title

# 更新手机触摸状态
func screen_touch_state_update(event):
	if event is InputEventScreenTouch:
		self.is_screen_touched = event.is_pressed()

# 当拖拽调整大小按钮
func _on_drag(event: InputEvent,source :Control) -> void:
	# 接收事件 阻止输入事件继续传播
	self.accept_event()
	if source.name == "TitleBackground" and \
	  # 有项目设置自动转换 不开的话很麻烦
	  event is InputEventMouseButton:
		# 移动窗口到顶层
		var parent:Variant = self.root.get_parent()
		parent.move_child(self.root,
		  parent.get_child_count() - 1)
	# 全屏判断
	if not self.is_maximized:
		# Motion 和 Button 事件不同时存在
		# 使用 Button/Screen 实例记录状态 再使用 Mootion/Drag 计算拖动
		if event is InputEventMouseButton:
			self.is_drag_bar_pressed = event.is_pressed()
		# 计算拖拽
		elif event is InputEventMouseMotion and \
		  self.is_drag_bar_pressed:
			self.plsyer_change_window_transform(event,source)
	elif source.name == "AdjustSize" and \
	  event is InputEventMouseButton:
		self.fullscreen_size_as_window_size()

# 玩家改变窗口变换(大小和位置)
# NOTE:使用事件实例确定变换类型 使用事件UI名字判断变换类型
func plsyer_change_window_transform(event:InputEvent,source:Control):
	# 确保没有全屏 compatible ternary mutually
	if not self.is_maximized:
		# 标题拖拽
		if source.name == "TitleBackground":
			# 改变坐标
			var used_position:Vector2 = self.position + event.relative
			self.position = Vector2(
				min( # x边界检测
					max(used_position.x,0 
					  if not is_folded else -30), # 左边界
					# (减去窗体最大宽度)右边界
					self.root.size.x - self.MIN_SIZE_X - (0
					  if not self.is_folded else 30)
				),
				min( # y边界检测
					max(used_position.y,0), # 上边界
					# (加上窗体最大高度)下边界
					self.root.size.y - self.MIN_SIZE_Y
				)
			)
			self.window_position_restore = self.position
		# 调整尺寸
		elif source.name == "AdjustSize":
			var used_size:Vector2 = self.size + event.relative
			self.size = Vector2( # 最小大小x
				min(
					max(
						self.MIN_SIZE_X,
						used_size.x
					), 
					self.MAX_SIZE_X
				),
				# 不超过最小大小 和 根组件y
				min(
					max(
						self.MIN_SIZE_Y,
						used_size.y if
						  # 设置折叠状态大小
						  not self.is_folded else float(30)
					),
					self.MAX_SIZE_Y
				)
			)
			self.window_size_restore = self.size
			if not self.is_folded:
				self.size_y_no_folding = self.size.y

# 当关闭窗口
func _on_close(event: InputEvent) -> void:
	if (((event is InputEventMouseButton and
	  not self.is_screen_touched) or # 电脑端点击 & 反正手机端重复点击
	  event is InputEventScreenTouch) and # 手机端点击
	  not event.is_pressed()): # 已按下
		self.accept_event()
		
		if self.close_action == self.root.close_action_type.HIDE:
			self.root.visible = false
		else:self.root.queue_free()

# 当(进入/退出)按钮
func _on_touch_entered_or_exited(event: InputEvent, source: ColorRect) -> void:
	if event is InputEventScreenTouch:
		if event.is_pressed():self._on_mouse_entered(source)
		else:self._on_mouse_exited(source)
func _on_mouse_entered(source: ColorRect) -> void:
	self.accept_event()
	self.change_button_color(self.ColorChangeType.ENTER,source)
func _on_mouse_exited(source: ColorRect) -> void:
	self.accept_event()
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
 
# 当最(大/小)化
func _on_maximize(event: InputEvent,source: Control) -> void:
	if ((event is InputEventMouseButton and
	  not self.is_screen_touched) or
	  event is InputEventScreenTouch) and \
	  not event.is_pressed():
		self.accept_event()
		# 进入全屏状态
		if not self.is_maximized:# 设置锚点和边偏移预设
			# 记录全屏前变换 & 设置全屏
			self.window_size_restore = self.size
			self.window_position_restore = self.position
			self.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
			# 更新折叠按钮标签状态和窗体高度
			if is_folded:
				self.adjust_size_button_label.get_parent() \
				  .position.x -= 30
			if is_folded_fullscreen:
				self.size.y = self.FOLD_SIZE_Y
				self.fold_button_label.scale.y = -1
			else:self.fold_button_label.scale.y = 1
			self.is_maximized = true
			source.get_child(0).text = "❏"
			self.adjust_size_button_label.text = "▣"
			self.adjust_size_button_label.get_parent().color = \
			  Color(0.418, 0.418, 0.418, 1.0)
			# 设置指针形状
			self.adjust_size_button_label.get_parent() \
			  .mouse_default_cursor_shape = CursorShape.CURSOR_ARROW
			$TitleBackground.mouse_default_cursor_shape = \
			  CursorShape.CURSOR_ARROW
		else:
		# 退出全屏状态
			self.set_anchors_preset(Control.PRESET_TOP_LEFT)
			self.position = self.window_position_restore
			self.size = self.window_size_restore
			if is_folded:
				self.size.y = self.FOLD_SIZE_Y
				self.fold_button_label.scale.y = -1
				self.adjust_size_button_label.get_parent() \
				  .position.x += 30
				# 设置指针形状
				self.adjust_size_button_label.get_parent() \
				  .mouse_default_cursor_shape = CursorShape.CURSOR_HSIZE
			else:
				self.fold_button_label.scale.y = 1
				# 设置指针形状
				self.adjust_size_button_label.get_parent() \
				  .mouse_default_cursor_shape = CursorShape.CURSOR_FDIAGSIZE
			$TitleBackground.mouse_default_cursor_shape = \
			  CursorShape.CURSOR_MOVE
			self.is_maximized = false
			source.get_child(0).text = "□"
			self.adjust_size_button_label.text = "▨"
			self.adjust_size_button_label.get_parent().color = \
			  Color(0.933, 0.439, 0.0, 0.608)

# 全屏窗口尺寸作为窗口大小
func fullscreen_size_as_window_size() -> void:
	if self.is_maximized:
		self.set_anchors_preset(Control.PRESET_TOP_LEFT)
		# 全屏折叠状态设为窗口折叠状态
		self.is_folded = self.is_folded_fullscreen
		# 为折叠按钮设置文本
		self.fold_button_label.scale.y = \
		  1 if not self.is_folded else -1
		# 为折叠状态设置值
		if self.is_folded_fullscreen:
			# 已折叠
			self.adjust_size_button_label.get_parent() \
			  .position.x += 30
			self.is_folded_fullscreen = false
			self.size.y = self.FOLD_SIZE_Y;self.size.x -= 30
			# 设置指针形状
			self.adjust_size_button_label.get_parent() \
			  .mouse_default_cursor_shape = CursorShape.CURSOR_HSIZE
		else: # 未折叠
			self.size_y_no_folding = self.size.y
			# 设置指针形状
			self.adjust_size_button_label.get_parent() \
			  .mouse_default_cursor_shape = CursorShape.CURSOR_FDIAGSIZE
		$TitleBackground.mouse_default_cursor_shape = \
		  CursorShape.CURSOR_MOVE
		self.window_size_restore = self.size
		self.window_position_restore = self.position
		self.is_maximized = false
		self.maximize_button_label.text = "□"
		self.adjust_size_button_label.text = "▨"
		self.adjust_size_button_label.get_parent().color = \
		  Color(0.933, 0.439, 0.0, 0.608)

# 当折叠窗口
func _on_fold_window(event: InputEvent, source: Control) -> void:
	if(
		( # 手机端防止重复触摸 & 电脑端点击
			event is InputEventMouseButton and
			not self.is_screen_touched
		) or # 手机端触摸
		event is InputEventScreenTouch or
		( # 手机端长按预览
			event is InputEventMouseButton and
			event.button_index == MouseButton.MOUSE_BUTTON_RIGHT
		) # 已按下
	  ) and not event.is_pressed():

		self.accept_event()
		# 处理窗口化折叠
		if not self.is_maximized:
			self.is_folded = not self.is_folded
			# 设置或还原y大小 & 修改指针样式
			if self.is_folded:
				self.size.y = self.FOLD_SIZE_Y
				if (self.size.x <= self.root.size.x and
				  self.size.x > self.root.size.x - 30):
					self.position.x -= 30
				self.adjust_size_button_label.get_parent() \
				  .mouse_default_cursor_shape = CursorShape.CURSOR_HSIZE
			else:
				self.position.x = max(0,position.x)
				self.size.y = self.size_y_no_folding
				self.adjust_size_button_label.get_parent() \
				  .mouse_default_cursor_shape = CursorShape.CURSOR_FDIAGSIZE
			# 修改文本
			source.get_child(0).scale.y = 1 if not self.is_folded else -1
			# 修改调整按钮位置
			self.adjust_size_button_label.get_parent().position.x -= \
			  30 if not self.is_folded else -30
			
		else:# 处理全屏折叠
			self.is_folded_fullscreen = not self.is_folded_fullscreen
			if self.is_folded_fullscreen:
				self.size.y = self.FOLD_SIZE_Y
			else:self.size.y = self.root.size.y
			self.fold_button_label.scale.y = -1 \
			  if self.is_folded_fullscreen else 1

# 当钉住窗口
func _on_pin_window(event: InputEvent, source: Control) -> void:
	self.accept_event()
	if ((event is InputEventMouseButton and
	  not self.is_screen_touched) or
	  event is InputEventScreenTouch) and \
	  not event.is_pressed():
		self.root.top_level = not self.root.top_level
		source.get_child(0).text = "⎗" if \
		  self.root.top_level else "⎘"
