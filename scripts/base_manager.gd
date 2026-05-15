extends Node

# Ресурси бази
var energy_level: float = 100.0
var oxygen_level: float = 100.0
var game_time: int = 600 # 10 хвилин

@onready var game_timer = $GameTimer 

func _ready():
	# Перевіряємо, чи існує таймер через змінну game_timer
	if game_timer:
		game_timer.wait_time = 1.0
		game_timer.one_shot = false # Циклічний режим
		
		# Підключаємо сигнал
		if not game_timer.timeout.is_connected(_on_game_timer_timeout):
			game_timer.timeout.connect(_on_game_timer_timeout)
		
		game_timer.start()
	else:
		# Якщо видає цю помилку, значить шлях $GameTimer неправильний
		push_error("Помилка: Таймер не знайдено! Перевір шлях у @onready.")

func _on_game_timer_timeout():
	# Зменшуємо ресурси
	game_time -= 1
	energy_level = clamp(energy_level - 0.5, 0.0, 100.0)
	oxygen_level = clamp(oxygen_level - 0.3, 0.0, 100.0)
	
	update_ui()

func update_ui():
	# Звертаємось до HUD
	var hud = $HUD
	if hud and hud.has_method("update_values"):
		hud.update_values(energy_level, oxygen_level, game_time)
