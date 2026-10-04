# Todo List
> +:新增 -:减少 @:修改 !:错误 &:已废弃
---
#### 2026/9/25
 - [ ] +添加 **临时性质的** 死亡聊天框文本
 - [x] +添加跳跃力度
 - [x] +新增 **TextManager** 类 和 **ChattingManager** 类
 - [x] @单分 文本两方法为一类 聊天信号为一类
 - [x] +ChattingManager类新增发送消息方法
#### 2026/9/27
 ##### 拼写错误(由AI检查)
 - [x] @仓库名称：`Eclts_plantform_jumpping` → `Eclts_platform_jumping`
 - [x] @目录：`sences/` → `scenes/`
 - [x] @场景文件：`tiny_sence.tscn` → `tiny_scene.tscn`
 - [x] @场景文件：`main_sence.tscn` → `main_scene.tscn`
 - [x] @资源文件：`bitton_style.tres` → `button_style.tres`
 - [x] @全局变量：`ISVertrulKeyMovementPressed` → `IsVirtualKeyMovementPressed`
 - [x] @函数/节点/输入动作：`opeat` / `player_opeat` → `operate` / `player_operate`
 - [x] @类名：`COLLIDESION_DEATH_PLAYER` → `COLLISION_DEATH_PLAYER`
 - [x] @节点/函数/场景：`FloattingText` / `display_floatting_text` / `floatting_text.tscn` → `FloatingText` / `display_floating_text` / `floating_text.tscn`
 - [x] @计时器变量：`text_destory_timer` → `text_destroy_timer`
 - [x] @函数：`_reflash()` → `_refresh()` * flash 指 n.闪光 *
 - [x] @变量：`mepressed` → `is_pressed`
 - [x] @调试字符串：`arrch:` → `arch:`
 - [x] @调试字符串：`Imitate:{IsEmulator}` → `Emulator:{IsEmulator}` * Imitate 指 v.模仿 *
 - [x] @HUD节点：`LeftterControl` → `LeftControl`
 - [x] @HUD节点：`RightterControl` → `RightControl`
 - [x] @场景根节点命名：`MainSence` / `Sence` / `TestingSenceRoot` → `MainScene` / `Scene` / `TestingSceneRoot`
 - [x] @项目配置名称：`2DCaractorTest` → `ACATSPlatFromJumping`
 ##### 规范错误
 - [x] @函数 `Display_up_rising_text()` → `display_up_rising_text()`
 - [ ] &~~场景节点 `SAVE` → `SaveComponent`~~
 - [x] @节点 `RichTextLabel` 重命名为 `TextItem`
 - [x] @删除 project.godot 残留配置 `[global] aaa.custom=false`
 - [x] @清理重复场景文件 `trigger_area.tscn`（废弃版本）
 - [x] @重命名场景内默认节点 `StaticBody2D` / `CollisionPolygon2D` 为业务名称如 `WallBody` / `WallShape`
#### 2026/9/30
 - [x] +为玩家添加精灵和动画
 - [x] +场景 窗口UI
#### 2026/10/2
 - [x] !**手机端**窗口调整和移动**灵敏度**过大
 - [ ] +添加单例`GameLogger`
 - [ ] +添加类似MC的坐标轴指示器 并在调试界面显示
 - [ ] +添加组件`EcltWindow` 包含一个实例`WindowManager`
 - [ ] +添加单例`WindowManager`
#### 2026/10/3
 - [x] !关闭模拟后手机端无法点击按钮和打开输入框
	- 因为**某些信号会在手机上失效** 现已改为开启模拟方案
 - [x] !手机端窗口按钮要**点两次**才有效
 
