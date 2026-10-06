class_name EcltsWindow
extends Control
## EcltWindow [b]有折叠 调整大小 关闭 全屏[/b] 等功能 [br]
## EcltWindow 默认会有一个父组件 这个父组件的锚点为
## [code]Control.PRESET_FULL_RECT[/code][br]
##    [i]下文提到的父组件都是指该组件的父组件[/i][br]
## 如果父组件是[code]Window[/code]且
## [code]delete_if_parent_is_window[/code]为[code]true[/code]时关闭时会删除UI[br]
##    [i]否则会隐藏UI[/i][br]
## 有两种创建方式:	1.使用节点实例 窗口会自动设置为节点大小 节点下的节点也会自动添加到窗口内
##             	2.使用节点单例 的静态方法

# 编辑器配置
## 窗口图标
@export var window_icon:Texture2D = load("res://sprites/player_animation/Spike_Idle1.png") as Texture2D:
	set(value): # NOTE:Setter/Getter 内不能用 self. 获取 设置/获取 的值
		window_icon = value
		if self.window != null:
			window.window_icon = value
			self.refresh_attributes()
	get:return window_icon
## 窗口标题
@export var window_title:String = "无标题":
	set(value):
		window_title = value
		if self.window != null:
			self.window.window_title = value
			self.refresh_attributes()
	get:return window_title
## 窗口关闭动作
@export_enum("Hide","Delete") var close_action = 1:
	set(value):
		close_action = value
		if self.window != null:
			window.close_action = value
	get:return close_action
## 关闭动作类型枚举值
enum close_action_type{
	HIDE,DELETE
}
# 状态标记
var _nodes:Array[Node]
## 位于子节点的窗口
var window:Control
## 窗口是隐藏的
var is_hidden:bool = false:
	set(value):self.visible = value
	get:return self.visible
# 窗口的位置和大小
var window_size:Vector2:
	set(value):self.window.size = value
	get():return self.window.size
# 窗口的位置
var window_position:Vector2:
	set(value):self.window.position = value
	get():return self.window.position

## 初始化方法 分为组件和窗口两种情况
func _ready() -> void:
	# 组件 ready
	if self is Control:
		# 获取要添加的子节点
		self._nodes = self.get_children()
		# 记录当前节点变换 将会应用到窗口节点
		@warning_ignore("shadowed_variable")
		var window_size:Vector2 = self.size
		@warning_ignore("shadowed_variable")
		var window_position:Vector2 = self.position
		# 实例化窗口场景
		var main_window_resource:Resource = load("res://scenes/UI/eclts_window.tscn")
		var main_window:Control = main_window_resource.instantiate()
		self.add_child(main_window)
		self.window = main_window
		# 设置标题和图标
		main_window.window_icon = self.window_icon
		main_window.window_title = self.window_title
		# 添加节点 & 设置变换
		main_window.set_anchors_and_offsets_preset(Control.PRESET_TOP_LEFT)
		main_window.size = window_size + Vector2(0,30)
		main_window.position = window_position
		var content:Control = $WindowBackground/WindowContent
		for node in self._nodes:
			if node is Control:
				# 待设置的位置
				var node_position:Vector2 = node.position
				print(node_position)
				node.reparent(content)
				node.position = node_position
		# 设置根的锚点 & 刷新窗口属性
		self.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
		self.window.close_action = self.close_action
		self.window.refresh_attributes()
## 删除窗口UI
func delete() -> void:self.queue_free()
## 刷新属性和窗口
func refresh_attributes() -> void:
	# 标题和图标
	self.window.window_icon = self.window_icon
	self.window.window_title = self.window_title
	# 关闭动作
	self.window.close_action = self.close_action
	# 刷新窗口面板
	self.window.refresh_attributes()
