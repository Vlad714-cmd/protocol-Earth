extends Node

# Показники бази
var energy_level: float = 100.0
var oxygen_level: float = 100.0
var game_time: int = 600 # 10 хвилин

# Використовуємо @onready, щоб Godot почекав завантаження вузла
@onready var game_timer: Timer = $GameTimer

func _ready():
	# Перевіряємо, чи існує таймер, перш ніж давати йому команди
	if game_timer:
		game_timer.wait_time = 1.0
		game_timer.autostart = true
		# Підключаємо сигнал через код, щоб не робити це вручну в редакторі
		if not game_timer.timeout.is_connected(_on_game_timer_timeout):
			game_timer.timeout.connect(_on_game_timer_timeout)
		game_timer.start()
	else:
		push_error("ПОМИЛКА: Вузол 'GameTimer' не знайдено! Перевір ієрархію в сцені.")

func _on_game_timer_timeout():
	# Кожну секунду зменшуємо ресурси
	game_time -= 1
	energy_level -= 0.1
	oxygen_level -= 0.05
	
	# Викликаємо оновлення інтерфейсу
	update_hud()

func update_hud():
	# Шукаємо HUD у сцені
	var hud = get_tree().root.find_child("HUD", true, false)
	if hud and hud.has_method("update_values"):
		hud.update_values(energy_level, oxygen_level, game_time)
