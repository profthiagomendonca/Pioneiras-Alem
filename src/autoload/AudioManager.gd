extends Node

var player_sfx: AudioStreamPlayer
var bgm_player: AudioStreamPlayer
var sounds: Dictionary = {}

func _ready() -> void:
	player_sfx = AudioStreamPlayer.new()
	player_sfx.bus = "Master"
	add_child(player_sfx)

	bgm_player = AudioStreamPlayer.new()
	bgm_player.bus = "Master"
	add_child(bgm_player)

	_generate_procedural_sounds()
	_load_bgm_stream()

func _load_bgm_stream() -> void:
	var music_paths = [
		"res://Musica tela inicial.mp3",
		"res://src/assets/audio/Musica tela inicial.mp3"
	]
	for path in music_paths:
		if ResourceLoader.exists(path):
			var stream = load(path)
			if stream != null:
				bgm_player.stream = stream
				if stream is AudioStreamMP3:
					stream.loop = true
				bgm_player.volume_db = -6.0
				break

func play_bgm() -> void:
	if bgm_player.stream == null:
		_load_bgm_stream()
	if bgm_player.stream != null and not bgm_player.playing:
		bgm_player.play()

func stop_bgm() -> void:
	if bgm_player != null and bgm_player.playing:
		bgm_player.stop()

func _generate_procedural_sounds() -> void:
	sounds["click"] = _generate_tone(600.0, 0.05, 0.2, "sine")
	sounds["success"] = _generate_melody([523.25, 659.25, 783.99, 1046.50], 0.08, 0.3)
	sounds["error"] = _generate_tone(160.0, 0.25, 0.3, "sawtooth")
	sounds["card"] = _generate_tone(440.0, 0.06, 0.15, "triangle")
	sounds["bug_catch"] = _generate_melody([880.0, 1174.66, 1318.51], 0.09, 0.25)
	sounds["alarm"] = _generate_tone(880.0, 0.15, 0.2, "square")

func play_click() -> void:
	_play_sound("click")

func play_success() -> void:
	_play_sound("success")

func play_error() -> void:
	_play_sound("error")

func play_card() -> void:
	_play_sound("card")

func play_bug_catch() -> void:
	_play_sound("bug_catch")

func play_alarm() -> void:
	_play_sound("alarm")

func _play_sound(sound_key: String) -> void:
	if sound_key in sounds and sounds[sound_key] != null:
		player_sfx.stream = sounds[sound_key]
		player_sfx.play()

func _generate_tone(freq: float, duration: float, volume: float, waveform: String) -> AudioStreamWAV:
	var sample_rate: int = 22050
	var num_samples: int = int(sample_rate * duration)
	var data: PackedByteArray = PackedByteArray()
	data.resize(num_samples * 2)

	for i in range(num_samples):
		var t: float = float(i) / sample_rate
		var sample: float = 0.0
		
		var env: float = 1.0 - (float(i) / num_samples)
		if i < sample_rate * 0.01:
			env = float(i) / (sample_rate * 0.01)

		if waveform == "sine":
			sample = sin(TAU * freq * t)
		elif waveform == "square":
			sample = 1.0 if sin(TAU * freq * t) > 0.0 else -1.0
		elif waveform == "sawtooth":
			sample = 2.0 * (fposmod(freq * t, 1.0) - 0.5)
		elif waveform == "triangle":
			sample = 2.0 * abs(2.0 * (fposmod(freq * t, 1.0) - 0.5)) - 1.0

		var int_sample: int = clampi(int(sample * env * volume * 32767.0), -32768, 32767)
		data.encode_s16(i * 2, int_sample)

	var wav: AudioStreamWAV = AudioStreamWAV.new()
	wav.format = AudioStreamWAV.FORMAT_16_BITS
	wav.mix_rate = sample_rate
	wav.stereo = false
	wav.data = data
	return wav

func _generate_melody(frequencies: Array, note_duration: float, volume: float) -> AudioStreamWAV:
	var sample_rate: int = 22050
	var total_samples: int = int(sample_rate * note_duration * frequencies.size())
	var data: PackedByteArray = PackedByteArray()
	data.resize(total_samples * 2)

	var current_sample: int = 0
	for freq in frequencies:
		var note_samples: int = int(sample_rate * note_duration)
		for i in range(note_samples):
			var t: float = float(i) / sample_rate
			var env: float = 1.0 - (float(i) / note_samples)
			if i < sample_rate * 0.005:
				env = float(i) / (sample_rate * 0.005)
			var sample: float = sin(TAU * freq * t)
			var int_sample: int = clampi(int(sample * env * volume * 32767.0), -32768, 32767)
			data.encode_s16((current_sample + i) * 2, int_sample)
		current_sample += note_samples

	var wav: AudioStreamWAV = AudioStreamWAV.new()
	wav.format = AudioStreamWAV.FORMAT_16_BITS
	wav.mix_rate = sample_rate
	wav.stereo = false
	wav.data = data
	return wav
