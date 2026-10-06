extends Control
# 调试屏幕逻辑

func _process(delta: float) -> void:
	if self.name != "Origin": # 调试文本
		DebugFunction.DebugInfo.FrameRenderingTime = delta
		DebugFunction.DebugInfo.CurrentFPS = Engine.get_frames_per_second()
		if EGG.MainPlayer != null:
			DebugFunction.DebugInfo.RespawnPosition = EGG.MainPlayer.respawn_position
			DebugFunction.DebugInfo.PlayerVelocity = EGG.MainPlayer.velocity
			DebugFunction.DebugInfo.PlayerPosition = EGG.MainPlayer.position
		else:DebugFunction.DebugInfo.PlayerPosition = Vector2()
		if (self.name =="DetailLeft") == true:
			# 左侧文本
			self.text = DebugFunction.get_formatted_dynamic_info()
		if (self.name == "DetailRight") == true:
			# 右侧文本
			self.text = DebugFunction.get_formatted_static_info()
	else: # 变换指示准星
		self.rotation = EGG.MainPlayer.rotation
