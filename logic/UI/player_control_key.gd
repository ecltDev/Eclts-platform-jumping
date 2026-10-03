extends Panel
## 玩家控制相关

# 它代表自己是否已按下
var is_pressed:bool = false

# 初始动作
func _ready() -> void:
	# 电脑自动隐藏按键
	if self.name == "DisplayKeys":
		if OS.get_name() != "Android" or OS.get_name() == "iOS":$"../PlayerControl".visible = false
# 玩家控制按键按下
func _on_player_action(event: InputEvent) -> void:
	# 可长按部分 同时检测按键和触屏
	if (event is InputEventMouseButton and
	  event.button_index == MouseButton.MOUSE_BUTTON_LEFT) or \
	  event is InputEventScreenTouch:
		# 左右移动
		if (self.name == "MoveLeft" or
		  self.name == "MoveRight" ):
			EGG.ISVirtualKeyMovementPressed = event.is_pressed()
			self.is_pressed = event.is_pressed()

		else:if self.name == "Jump":
			if event.is_pressed():Input.action_press("player_jump")
			else:Input.action_release("player_jump")

		# 交互和重生
		else:if self.name == "Operate" and event.is_pressed():
			EGG.MainPlayer.operate()
		else:if self.name == "Respawn" and event.is_pressed():
			EGG.MainPlayer.respawn()

	# 左键单点部分 不检测左键按下触屏 检测鼠标按钮事件
	if (event is InputEventMouseButton and
	  event.button_index == MouseButton.MOUSE_BUTTON_LEFT) and \
	  not event.is_pressed():


		# 显示按键
		if self.name == "DisplayKeys":
			$"../PlayerControl".visible = not $"../PlayerControl".visible

		# 显示聊天
		else:if self.name == "OpenChattyPanel":
			$"../ChattyPanel".visible = not $"../ChattyPanel".visible

	# 手机端可长按预览功能
	#(感觉这个BUG挺好用就加进来了/折叠窗口也有这个)
	if event is InputEventMouseButton and \
	  not event.is_pressed():

		# 调试屏幕
		if self.name == "DisplayDebuggingOverlay":
			$"../DebuggingOverlay".visible = not $"../DebuggingOverlay".visible

	# 设置按钮颜色变化(不在块内)
	if (event is InputEventMouseButton and
	  event.button_index == MouseButton.MOUSE_BUTTON_LEFT) or \
	  event is InputEventScreenTouch:
		var key_color:Color
		if event.is_pressed():
			key_color = Color(1.0, 1.0, 1.0, 1.0)
		else:
			key_color = Color(1.0, 1.0, 1.0, 0.275)
		$Label.add_theme_color_override("font_color",key_color)
		var new_theme:StyleBox = self.get_theme_stylebox("panel")
		new_theme.border_color = key_color
		self.add_theme_stylebox_override("panel",new_theme)

# 根据自己的属性发出玩家移动事件
@warning_ignore("unused_parameter")
func _physics_process(delta: float) -> void:
	if self.name == "MoveLeft" or self.name == "MoveRight":
		var action:String = ("move_player_left" 
		  if self.name == "MoveLeft" else "move_player_right")
		if self.is_pressed == true:
			Input.action_press(action)
		else:
			Input.action_release(action)
