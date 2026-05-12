extends ColorRect

# --- Ресурси (налаштовуються в Інспекторі) ---
@export_group("Starting Stats")
@export var max_energy: float = 100.0
@export var max_oxygen: float = 100.0
@export var game_duration_sec: float = 600.0 # 10 хвилин

# --- Поточні значення ---
var energy: float
var oxygen: float
var time_left: float

# --- Стани систем (Логіка "Жертв") ---
var is_lights_on: bool = true
var is_turbo_oxygen: bool = false
var storm_active: bool = false
var is_game_over: bool = false

# --- Посилання на вузли ---
@onready var game_timer: Timer = $GameTimer
@onready var hud = get_node_or_null("Hud/hud") 

func _ready():
	energy = max_energy
	oxygen = max_oxygen
	time_left = game_duration_sec
	
	if game_timer:
		game_timer.wait_time = 1.0
		game_timer.timeout.connect(_on_tick)
		game_timer.start()
	else:
		push_error("GameTimer не знайдено! Додайте вузол Timer до BaseManager.")

func _process(_delta):
	if is_game_over: return
	
	# Постійне оновлення HUD (якщо він існує)
	if hud and hud.has_method("update_values"):
		hud.update_values(energy, oxygen, time_left)
	
	_check_progression()
	_check_game_status()

func _on_tick():
	if is_game_over: return
	
	if time_left > 0:
		time_left -= 1
	
	_process_resources()

func _process_resources():
	# Базове споживання
	var energy_drain = 0.2
	var oxygen_drain = 0.1
	
	# Логіка впливу систем (Жертви)
	if is_lights_on:
		energy_drain += 0.3 # Світло споживає додаткову енергію
	
	if is_turbo_oxygen:
		energy_drain += 1.2 # Турбо-кисень дуже дорогий
		oxygen = min(oxygen + 2.0, max_oxygen)
	else:
		oxygen = max(oxygen - oxygen_drain, 0)
		
	if storm_active:
		energy_drain += 0.5 # Буря навантажує щити бази
	
	energy = max(energy - energy_drain, 0)

func _check_progression():
	# Подія: Велика Буря на 5-й хвилині (300 сек залишилося)
	if time_left <= 300.0 and not storm_active:
		_start_great_storm()

func _start_great_storm():
	storm_active = true
	print("ПОПЕРЕДЖЕННЯ: Почалася піщана буря!")
	# Тут можна додати виклик візуального ефекту пилу через HUD

func _check_game_status():
	if (energy <= 0 or oxygen <= 0) and not is_game_over:
		is_game_over = true
		print("ПОРАЗКА: Системи життєзабезпечення відмовили!")
	
	if time_left <= 0 and not is_game_over:
		is_game_over = true
		print("ПЕРЕМОГА: Рятувальний шаттл прибув!")

# --- Керування системами (можна викликати через клавіші або кнопки в грі) ---
func toggle_lights():
	is_lights_on = !is_lights_on
	print("Світло: ", "Увімкнено" if is_lights_on else "Вимкнено")

func toggle_turbo_oxygen():
	is_turbo_oxygen = !is_turbo_oxygen
	print("Турбо-кисень: ", is_turbo_oxygen)
