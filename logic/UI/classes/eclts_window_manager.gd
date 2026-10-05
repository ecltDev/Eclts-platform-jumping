class_name EcltsWindowManager
extends Control
## EcltWindow [b]有折叠 调整大小 关闭 全屏[/b] 等功能 [br]
## EcltWindow 默认会有一个父组件 这个父组件的锚点为
##[code]Control.PRESET_FULL_RECT[/code][br]
##    [i]下文提到的父组件都是指该组件的父组件[/i][br]M
## 如果父组件是[code]Window[/code]且
##[code]delete_if_parent_is_window[/code]为[code]true[/code]时关闭时会删除UI[br]
##     [i]否则会隐藏UI[/i]

var _nodes:Array[Node]

func _ready() -> void:
	# 组件 ready
	if self is Control:
		# 获取要添加的子节点
		self._nodes = self.get_children()
		# 记录当前节点变换 将会应用到窗口节点
		var window_size:Vector2 = self.size
		var window_position:Vector2 = self.position
		# 设置锚点 & 偏移
		self.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
		# 实例化窗口场景
		var main_window_resource:Resource = load("res://scenes/UI/eclts_window.tscn")
		var main_window:Control = main_window_resource.instantiate()
		self.add_child(main_window)
		# 添加节点 & 设置变换
		main_window.set_anchors_and_offsets_preset(Control.PRESET_TOP_LEFT)
		main_window.size = window_size
		main_window.position = window_position
		var content:Control = $WindowBackground/WindowContent
		for node in self._nodes:
			if node is Control:
				var node_position:Vector2 = node.position
				content.add_child(node)
				node.position = node_position
				
