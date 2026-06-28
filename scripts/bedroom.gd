extends Node2D

@onready var prompt: Label = $InteractionPrompt
var player_in_range: bool = false

func _ready() -> void:
	# 确保初始状态提示是隐藏的
	prompt.visible = false

func _process(_delta: float) -> void:
	# 如果玩家在范围内，并且按下了 F 键（假设你已经在 项目设置->输入映射 里配置了 "interact" 动作为 F 键）
	# 如果没有配置输入映射，也可以直接用 Input.is_action_just_pressed("ui_accept") 测试回车/空格
	if player_in_range and Input.is_action_just_pressed("interact"):
		trigger_sleep()


# 触发睡觉逻辑
func trigger_sleep() -> void:
	print("正在触发睡觉...")
	
	# 隔空喊话给全局的时间系统
	get_tree().call_group("TimeSystem", "player_sleep")
	
	# 可选：睡觉后可以隐藏提示，或者播放一个屏幕渐黑的动画遮罩
	if prompt:
		prompt.visible = false


func _on_area_2d_3_body_entered(body: Node2D) -> void:
	# 这里的 "Player" 可以根据你玩家节点的真实名字或者群组来判断
	if body.name == "player" or body.is_in_group("player"):
		player_in_range = true
		if prompt:
			prompt.visible = true # 显示 [Press F]
	pass # Replace with function body.


func _on_area_2d_3_body_exited(body: Node2D) -> void:
	if body.name == "player" or body.is_in_group("player"):
		player_in_range = false
		if prompt:
			prompt.visible = false # 隐藏 [Press F]
	pass # Replace with function body.


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "player":
		Global.current_room = "Bedroom"
		get_tree().change_scene_to_file(Global.Room_1)
	pass # Replace with function body.
