extends CanvasLayer

# Посилання на бари (перевірте, щоб назви в дереві сцени збігалися!)
@onready var energy_bar = $MainContainer/UI_Layout/BarsContainer/EnergyBar
@onready var oxygen_bar = $MainContainer/UI_Layout/BarsContainer/OxygenBar
@onready var storm_rect = $StormOverlay

func _ready() -> void:
	# Рядок з mouse_filter видалено, оскільки CanvasLayer його не підтримує.
	# Щоб HUD не блокував кліки, налаштуйте Mouse Filter у вузла MainContainer 
	# або ColorRect в інспекторі на значення "Ignore".
	
	# Шукаємо BaseManager у сцені 
	var manager = get_tree().root.find_child("BaseManager", true, false)
	
	if manager:
		# Підключаємо сигнал оновлення ресурсів
		if manager.has_signal("resources_updated"):
			manager.resources_updated.connect(update_values)
		else:
			print("Помилка: У BaseManager не знайдено сигнал resources_updated")
	else:
		print("Помилка: BaseManager не знайдено в дереві сцен!") 

# Функція, яку викликає сигнал від BaseManager 
func update_values(en: float, ox: float):
	if energy_bar:
		energy_bar.value = en 
	if oxygen_bar:
		oxygen_bar.value = ox
