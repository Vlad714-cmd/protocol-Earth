extends Area3D

var player_near = false

func _ready():
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body):
	if body.is_in_group("Player"):
		player_near = true
		print("Натисніть E, щоб залатати пробоїни")

func _on_body_exited(body):
	if body.is_in_group("Player"):
		player_near = false

func _input(event):
	if event.is_action_pressed("interact") and player_near:
		repair_hull()

func repair_hull():
	if BaseManager.hull_integrity < 100:
		BaseManager.hull_integrity += 15.0
		# Обмежуємо максимум 100%
		BaseManager.hull_integrity = min(BaseManager.hull_integrity, 100.0)
		print("Корпус відремонтовано! Цілісність: ", int(BaseManager.hull_integrity), "%")
	else:
		print("Корпус у ідеальному стані.")
