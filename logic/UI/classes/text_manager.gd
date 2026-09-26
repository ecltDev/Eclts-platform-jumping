extends Node
## 文本管理器

# 显示上升文本
func Display_up_rising_text(target_node:Node2D,text:String) -> void:
	# 主要变量
	var text_root:Node2D = EGG.RisingText.instantiate()
	var main_text:RichTextLabel = text_root.get_child(0)
	# 初始化变换
	target_node.add_child(text_root)
	text_root.position = Vector2(0,0)
	main_text.text = text
	await get_tree().process_frame # 相当于 事件:游戏帧更新
	text_root.position.y -= main_text.size.y
	# 动画配置 & 执行
	var text_animation_player:AnimationPlayer = main_text.get_child(0)
	var text_animation:Animation = text_animation_player.get_animation("disappear")
	text_animation.track_set_key_value(0,0,
	  Vector2(text_root.position.x - main_text.size.x / 2,
	  text_root.position.y))
	text_animation.track_set_key_value(0,1,
	  Vector2(text_root.position.x - main_text.size.x / 2,
	  text_root.position.y - 50))
	text_animation_player.current_animation = "disappear"
	# 删除节点计时器
	var text_destory_timer:Timer = main_text.get_child(1)
	text_destory_timer.start(0.4)
	await text_destory_timer.timeout
	text_root.queue_free()

# 显示浮动文本(会返回浮动文本根节点)
func display_floatting_text(target_node:Node2D,text:String = "Eclt",increment_y:float = 20) -> Node2D:
	# 主要变量
	var text_root:Node2D = EGG.FloattingText.instantiate()
	var main_text:RichTextLabel = text_root.get_child(0)
	# 添加FloattingText到TargetNode
	target_node.add_child(text_root)
	# 设置属性并等待一帧
	text_root.position = Vector2(0,0)
	main_text.text= text
	await get_tree().process_frame
	# 根据Target节点设置位置
	text_root.position.y -= increment_y + main_text.size.y
	return text_root
