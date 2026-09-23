extends Label
# 调试屏幕

func _process(delta: float) -> void:
	EGG.DebugInfo.FrameRenderingTime = delta
	EGG.DebugInfo.CurrentFPS = Engine.get_frames_per_second()
	EGG.DebugInfo.RespawnPosition = EGG.MainPlayer.respawn_position
	EGG.DebugInfo.PlayerVelocity = EGG.MainPlayer.velocity
	if EGG.MainPlayer != null:
		EGG.DebugInfo.PlayerPosition = EGG.MainPlayer.position
	else:EGG.DebugInfo.PlayerPosition = Vector2()
	if (self.name =="DetailLeft") == true:
		# 左侧文本
		self.text = '''FPS:{CurrentFPS}/{MaxFPS}({FrameRenderingTime})
		Pos(X,Y):{PlayerPosition}
		Respawn(X,Y):{RespawnPosition}
		Velocity(X,Y):{PlayerVelocity}'''.format(EGG.DebugInfo)
	if (self.name == "DetailRight") == true:
		# 右侧文本
		self.text = '''{GameName} {VersionType} {GameVersionName}({RenderingDriverName})
		OS:{OSName} Imitate:{IsEmulator}
		Godot:{EngineVersionName}
		CPU:{ProcessorName}(arrch:{ArchitectureName})
		GPU:{VideoAdapterName}'''.format(EGG.DebugInfo)
