extends CharacterBody2D

# Variable Exports
@export var Speed: float = 200
@export var Accel: float = 15
var DirectionToggle = false # Right = false, Left = true
var DirectionLock = false # Lock the player direction during certain animations
var l_hand_origin : Vector2 # Origin point of LHand
var r_hand_origin : Vector2 # Origin point of RHand

# Variable References
@onready var anim_body = $Anim_Body
@onready var r_hand = $RWeaponPivot/RHand
@onready var l_hand = $LHand
@onready var animation_player = $AnimationPlayer
@onready var r_weapon_pivot = $RWeaponPivot

func _ready():
	# Save original hand transform for reference later
	l_hand_origin = l_hand.position
	r_hand_origin = r_hand.position

func _physics_process(delta):
	
	# Get the direction as a Vector2
	var direction: Vector2 = Input.get_vector("PlayerMoveLeft", "PlayerMoveRight", "PlayerMoveUp", "PlayerMoveDown")
	
	# Play Movement Animations
	if direction.x == 0 and direction.y == 0:
		anim_body.play("Idle")
	else:
		anim_body.play("Run")
	
	velocity.x = move_toward(velocity.x, Speed * direction.x, Accel)
	velocity.y = move_toward(velocity.y, Speed * direction.y, Accel)
	
	move_and_slide()
	Handle_Weapon_Rotation()
	
	if Input.is_action_just_pressed("DebugTest"):
		print("r_weapon_pivot snapped =" + str(abs(snapped(r_weapon_pivot.rotation_degrees,1))))
	
	#Player attack animation
	if Input.is_action_just_pressed("PlayerAttack"):
		var DirectionString #Concat with Animation name
		if DirectionToggle: DirectionString = "L"
		else: DirectionString = "R"
		animation_player.play("Club_Anim" + str(DirectionString))
		DirectionLock = true
	elif Input.is_action_just_pressed("PlayerBlock"):
		l_hand.position = Vector2(0,l_hand.position.y)
	elif Input.is_action_just_released("PlayerBlock"):
		l_hand.position = l_hand_origin
		if DirectionToggle: l_hand.position *= Vector2(-1,1)

func Flip_sprite_Direction(Direction):
	# Mirror hand transforms across x axis
	# Direction -> Right = false, Left = true
	#print("l_hand position = " + str(l_hand.position) + " r_hand position = " + str(r_hand.position))
	l_hand.position *= Vector2(-1,1) #Move x postion to other side of body transform
	if Direction: #Left side
		r_hand.rotation_degrees = 180 # Rotate
	else: #Right side
		r_hand.rotation_degrees = 0 # Set to default

	l_hand.flip_h = Direction
	r_hand.flip_h = Direction
	anim_body.flip_h = Direction

func _on_animation_player_animation_finished(anim_name):
	#print(str(anim_name) + " finished")
	DirectionLock = false

func Handle_Weapon_Rotation():
	var weapon_pivot_rotation = snapped(r_weapon_pivot.rotation_degrees,1)
	var weapon_pivot_abs = abs(weapon_pivot_rotation)
	# Reset rotation by adding/subtracting 360 degrees
	if weapon_pivot_rotation <= -360:
		r_weapon_pivot.rotation_degrees += 360
		#print("Added 360 degrees")
	elif weapon_pivot_rotation >= 360:
		r_weapon_pivot.rotation_degrees -= 360
		#print("Subtracted 360 degrees")
	
	#  Flip the sprite based on pivot rotation
	if !DirectionToggle and (weapon_pivot_abs > 90 and weapon_pivot_abs < 270): #Flip R->L
		DirectionToggle = true
		Flip_sprite_Direction(DirectionToggle)
		#print("DirectionToggle Left")
	elif DirectionToggle and (weapon_pivot_abs > 270 or weapon_pivot_abs < 90): #Flip L->R
		DirectionToggle = false
		Flip_sprite_Direction(DirectionToggle)
		#print("DirectionToggled Right")
	
	r_weapon_pivot.look_at(get_global_mouse_position())
