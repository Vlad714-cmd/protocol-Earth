extends Area3D

var is_player_near = false

func _ready():
	# Підключаємо сигнали, щоб знати, коли гравець поруч
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body):
	if body.is_in_group("Player"):
		is_player_near = true
		print("Натисніть E, щоб поповнити кисень")

func _on_body_exited(body):
	if body.is_in_group("Player"):
		is_player_near = false

func _input(event):
	# Перевіряємо натискання кнопки "E"
	if event.is_action_pressed("interact") and is_player_near:
		refill_oxygen()

func refill_oxygen():
	# Звертаємось до нашого Singleton (Autoload) BaseManager
	BaseManager.oxygen_level += 10 
	print("Кисень відновлено! Поточний рівень: ", BaseManager.oxygen_level)
