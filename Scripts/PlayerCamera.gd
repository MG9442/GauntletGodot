extends Camera2D

# Variable Exports
@export var Speed: float = 200
@export var ZoomXDefault: float = 2.75
@export var ZoomYDefault: float = 2.75
@export var ZoomSpeed: float = 20
var MovementEnabled = false # Movement enabled/disabled

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	#Movement disabled
	if !MovementEnabled:
		return
	
	# Get the direction as a Vector2
	var direction: Vector2 = Input.get_vector("PlayerMoveLeft", "PlayerMoveRight", "PlayerMoveUp", "PlayerMoveDown")
	var MovementDelta = delta * ZoomSpeed
	position.x += (delta * Speed * direction.x)
	position.y += (delta * Speed * direction.y)
	
	if Input.is_action_just_pressed("DebugCameraZoomIn"):
		#print("Camera Zoom in")
		zoom += Vector2(MovementDelta,MovementDelta)
	elif Input.is_action_just_pressed("DebugCameraZoomOut"):
		#print("Camera Zoom out")
		zoom -= Vector2(MovementDelta,MovementDelta)

func ObjectMovement(value):
	#print("Camera Movement = " + str(value))
	MovementEnabled = value
	if !MovementEnabled: #Reset Camera Position
		zoom = Vector2(ZoomXDefault,ZoomYDefault)
		position = Vector2.ZERO
