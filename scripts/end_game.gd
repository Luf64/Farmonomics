extends Node2D

# 获取 VideoStreamPlayer 节点
@onready var video_player = $VideoStreamPlayer

func _ready():
    # 场景一加载，就开始播放影片
    if video_player.stream != null:
        video_player.play()
    else:
        print("警告：没有为 VideoStreamPlayer 设置影片文件！")
    
    # 监听影片播放完毕的信号 (finished)
    # 当影片播完时，自动执行下方的 _on_video_finished 函数
    #video_player.finished.connect(_on_video_finished)
    # 影片播完后，跳转回 room_0
    

func _on_video_stream_player_finished() -> void:
    get_tree().change_scene_to_file("res://rooms/room_0.tscn")
    pass # Replace with function body.
