extends Node

# Ресурси бази
var energy_level: float = 100.0
var oxygen_level: float = 100.0
var game_time: int = 600 # 10 хвилин

# Використовуємо @onready без зайвих символів
@onready var game_timer = $GameTimer

func _ready():
	if game_timer:
		game_timer.wait_time = 1.0
		game_timer.autostart = true
		# Переконайся, що сигнал не підключений двічі
		if not game_timer.timeout.is_connected(_on_game_timer_timeout):
			game_timer.timeout.connect(_on_game_timer_timeout)
		game_timer.start()
	else:
		print("Помилка: Додай вузол Timer з ім'ям GameTimer всередину BaseManager!")

func _on_game_timer_timeout():
	# Зменшуємо ресурси
	game_time -= 1
	energy_level -= 0.5
	oxygen_level -= 0.3
	
	# Обмежуємо, щоб не йшло в мінус
	energy_level = max(energy_level, 0)
	oxygen_level = max(oxygen_level, 0)
	
	update_ui()

func update_ui():
	# Шукаємо HUD у головній сцені
	var hud = get_tree().root.find_child("HUD", true, false)
	if hud and hud.has_method("update_values"):
		hud.update_values(energy_level, oxygen_level, game_time)
