extends CharacterBody2D

@export_range(0,500,10,"Speed") var SPEED:float = 260
@export_range(0,500,10,"Velocity")  var JUMP_VELOCITY:float = -520
var rest_jumping_times:int = 2
@onready var respawn_position = self.position
var last_overlapping_unit:Area2D
var is_dead:bool = false

func _ready() -> void:
	EGG.MainPlayer = self

func _physics_process(delta: float) -> void:
	# 重力
	if not is_on_floor():
		velocity += get_gravity() * delta
	# 按键控制移动
	if not EGG.ISVertrulKeyMovementPressed:
		if Input.is_physical_key_pressed(KEY_A):Input.action_press("move_player_left")
		else:Input.action_release("move_player_left")
		if Input.is_physical_key_pressed(KEY_D):Input.action_press("move_player_right")
		else:Input.action_release("move_player_right")

	# 使用事件移动
	var direction := Input.get_axis("move_player_left", "move_player_right")
	if direction != 0:
		velocity.x = direction * SPEED
	else:
		# 没有输入时
		velocity.x = move_toward(velocity.x, 0, SPEED)

	# 跳跃
	if (Input.is_action_just_pressed("player_jump") and
	  self.rest_jumping_times > 0):
		velocity.y = JUMP_VELOCITY
		self.rest_jumping_times -= 1
	elif Input.is_action_just_released("player_jump")and velocity.y<0:
		velocity.y*=0.6
	move_and_slide()
	
	# 垂直跳跃次数
	if self.is_on_floor():
		self.rest_jumping_times = 2

	# 交互和重生
	if Input.is_action_just_pressed("player_opeat"):EGG.MainPlayer.opeat()
	if Input.is_action_just_pressed("player_respawn"):EGG.MainPlayer.respawn()

# 设置交互区域
func _on_interact_detect_area_entered(area: Area2D) -> void:
	if area.name == "TriggerArea":
		self.last_overlapping_unit = area
@warning_ignore("unused_parameter")
func _on_interact_detect_area_exited(area: Area2D) -> void:
	if self.last_overlapping_unit != null:
		self.last_overlapping_unit = null

# 死亡和操作(交互)
func opeat() -> void:
	if EGG.MainPlayer.last_overlapping_unit != null:
		if EGG.MainPlayer.last_overlapping_unit.has_method(
		  "player_interact"):
			EGG.MainPlayer.last_overlapping_unit.player_interact()
func respawn() -> void:EGG.MainPlayer.position = EGG.MainPlayer.respawn_position
