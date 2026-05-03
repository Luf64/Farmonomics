extends Label
var x = '''
Credit 1 - Used Room 1
Song: sumu - apart [NCS Release]
Music provided by NoCopyrightSounds
Free Download/Stream: http://ncs.io/apart
Watch: http://ncs.lnk.to/apartAT/youtube

Credit 2 - Used Room 0
Song: Meditation Relaxing Music - DELOSound
Music provided by Pixabay
Link: https://pixabay.com/music/meditationspiritual-meditation-relaxing-music-466470/

Credit 3
Song: waera - harinezumi
Music provided by NoCopyrightSounds
Free Download/Stream: http://ncs.io/harinezumi
Watch: http://ncs.lnk.to/harinezumiAT/youtube

Credit 4
Song: Egzod, Maestro Chives, Neoni - Royalty [NCS Release]
Music provided by NoCopyrightSounds
Free Download/Stream: http://ncs.io/Royalty
Watch: http://ncs.lnk.to/RoyaltyAT/youtube

Credit 5
Song: MXZI, Deno - FAVELA
Music provided by NoCopyrightSounds
Free Download/Stream: http://ncs.io/FAVELA
Watch: http://ncs.lnk.to/FAVELAAT/youtube
'''

func _ready() -> void:
    text = x


func _on_button_pressed() -> void:
    get_tree().change_scene_to_file("res://rooms/room_0.tscn")
