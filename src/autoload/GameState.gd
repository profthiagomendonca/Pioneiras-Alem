extends Node

signal stage_completed(stage_id: String)
signal score_updated(new_score: int)

var current_stage: int = 1
var max_unlocked_stage: int = 1
var player_score: int = 0

# Métricas para avaliação científica (COTB) para as 6 pioneiras
var telemetry_data = {
	"session_start_time": 0,
	"stages": {
		"ada": {"attempts": 0, "completed": false, "time_spent": 0.0},
		"eniac": {"attempts": 0, "completed": false, "time_spent": 0.0},
		"grace": {"attempts": 0, "completed": false, "time_spent": 0.0},
		"katherine": {"attempts": 0, "completed": false, "time_spent": 0.0},
		"keller": {"attempts": 0, "completed": false, "time_spent": 0.0},
		"margaret": {"attempts": 0, "completed": false, "time_spent": 0.0}
	},
	"survey_responses": {}
}

var stage_scene_paths = {
	1: "res://src/scenes/stages/stage_ada/stage_ada.tscn",
	2: "res://src/scenes/stages/stage_eniac/stage_eniac.tscn",
	3: "res://src/scenes/stages/stage_grace/stage_grace.tscn",
	4: "res://src/scenes/stages/stage_katherine/stage_katherine.tscn",
	5: "res://src/scenes/stages/stage_keller/stage_keller.tscn",
	6: "res://src/scenes/stages/stage_margaret/stage_margaret.tscn"
}

func _ready() -> void:
	telemetry_data["session_start_time"] = Time.get_unix_time_from_system()

func unlock_next_stage(completed_stage: int) -> void:
	if completed_stage >= max_unlocked_stage and max_unlocked_stage < 6:
		max_unlocked_stage = completed_stage + 1

func go_to_stage(stage_num: int) -> void:
	if stage_num in stage_scene_paths:
		current_stage = stage_num
		AudioManager.stop_bgm()
		get_tree().change_scene_to_file(stage_scene_paths[stage_num])

func go_to_main_menu() -> void:
	AudioManager.play_bgm()
	get_tree().change_scene_to_file("res://src/scenes/main_menu/main_menu.tscn")

func go_to_victory() -> void:
	AudioManager.stop_bgm()
	get_tree().change_scene_to_file("res://src/scenes/victory/victory.tscn")

func record_attempt(stage_key: String) -> void:
	if stage_key in telemetry_data["stages"]:
		telemetry_data["stages"][stage_key]["attempts"] += 1

func complete_stage(stage_key: String, time_spent: float, points: int = 100) -> void:
	if stage_key in telemetry_data["stages"]:
		telemetry_data["stages"][stage_key]["completed"] = true
		telemetry_data["stages"][stage_key]["time_spent"] = time_spent
	player_score += points
	emit_signal("score_updated", player_score)
	emit_signal("stage_completed", stage_key)
