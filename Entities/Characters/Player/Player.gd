extends "res://Entities/Characters/Character.gd"
var weaponFactory = preload("res://Entities/Weapons/Weapon.tscn")
var bloodFactory = preload("res://Entities/Blood.tscn")

var previousAnimation : String = ""

var throwAmoeba : bool = false
var amoebaOnAir : bool = false
var amoeba : Object = null

func _ready():
	enableCollisions()
	amoeba = $body/Amoeba
	amoeba.init(self)
	init_player(character)
	changeBody(character)
	add_to_group(Constants.G_PLAYER)
	
	#This is how we create a wepon. Feel free to put this in a function if you don't like it like this, cause you probably will use it in different places
	var leftWeapon = weaponFactory.instance()
	$body/LeftWeapon.add_child(leftWeapon)
	leftWeapon.init(Constants.WEAPON_TYPE.PISTOL, self)

func init_player(_playerType) -> void:
	character = _playerType
	var attrs = Constants.PLAYER_ATTRIBUTES[_playerType]
	maxHP = attrs["MaxHP"]
	HP = maxHP
	maxStamina = attrs["MaxStamina"]
	stamina = maxStamina
	armor = attrs["Armor"]
	speed = attrs["Speed"]
	updateHP(maxHP)
	updateStamina(maxStamina)
	updateArmor(armor)
	updateSpeed(speed)

func _physics_process(delta):
	if(amoebaOnAir):
		return
	read_input()
	process_skills()
	move(delta, $body)
	look_mouse()
	process_collisions()
	animate()
	
func look_mouse():
	$body.look_at(getMousePosition())
	
func read_input():
	target_vel.x = 0
	target_vel.y = 0
	if Input.is_action_pressed("ui_left"):
		target_vel.x += -1
	if Input.is_action_pressed("ui_right"):
		target_vel.x += 1
	if Input.is_action_pressed("ui_up"):
		target_vel.y -= 1
	if Input.is_action_pressed("ui_down"):
		target_vel.y = 1
	if Input.is_action_pressed("ui_left_click"):
		leftAttack()
	if Input.is_key_pressed(KEY_G):
		changeBody(Constants.BIG)
	if Input.is_key_pressed(KEY_H):
		changeBody(Constants.BLUE)
	if Input.is_action_pressed("ui_throw_amoeba") && !amoebaOnAir:
		throwAmoeba = true

	target_vel = target_vel.normalized()

func process_skills():
	if(throwAmoeba):
		throwAmoeba = false
		amoebaOnAir = true
		$body.remove_child(amoeba)
		get_tree().get_root().add_child(amoeba)
		amoeba.eat(Vector2(cos($body.rotation), sin($body.rotation)), $body.global_position)
		amoeba.activateCamera()
		
		$body.visible = false
		
		var blood = bloodFactory.instance()
		get_tree().get_root().add_child(blood)
		blood.global_position = $body.global_position

func leftAttack():
	var children = $body/LeftWeapon.get_children()
	if children.size() > 0:
		children[0].attack()
		
func changeBody(bodyType) -> void:
	init_player(bodyType)
	match(bodyType):
		Constants.PLAYER_TYPE.RED:
			$Character.play("Fireman")
			character = Constants.PLAYER_TYPE.RED
		Constants.PLAYER_TYPE.BLUE:
			$Character.play("Soldier")
			character = Constants.PLAYER_TYPE.BLUE
		Constants.PLAYER_TYPE.BIG:
			$Character.play("BigGuy")
			character = Constants.PLAYER_TYPE.BIG
	previousAnimation = ""
	animate()

func animate():
	if(linear_vel.length_squared() > STOP_FACTOR && previousAnimation != "Walking"):
		match character:
			Constants.PLAYER_TYPE.BIG:
				$MovementAnimator.play("WalkingFat")
				previousAnimation = "Walking"
			_:
				$MovementAnimator.play("Walking")
				previousAnimation = "Walking"
	elif(linear_vel.length_squared() <= STOP_FACTOR && previousAnimation != "Idle"):
		match character:
			Constants.PLAYER_TYPE.BIG:
				$MovementAnimator.play("IdleFat")
				previousAnimation = "Idle"
			_:
				$MovementAnimator.play("Idle")
				previousAnimation = "Idle"
		

func process_collisions():
	var collider = null
	for i in range($body.get_slide_count()):
		collider = $body.get_slide_collision(i).get_collider().get_parent()
		if(collider.is_in_group(Constants.G_ENEMY)):
			print("Player collision!!")

func receiveDmg(val : float = 1.0) -> void:
	HP -= val

func getGlobalPosition():
	return $body.global_position

func getOrientation():
	return $body.rotation

func updateHP(val : float) -> void:
	HP = val
	$HUD/Control/VBoxContainer/HBoxContainer/HPBar.value = HP / maxHP * 100
func updateStamina(val : float) -> void:
	stamina = val
	$HUD/Control/VBoxContainer/HBoxContainer/StaminaBar.value = stamina / maxStamina  * 100
func updateArmor(val : int) -> void:
	armor = val
	$HUD/Control/VBoxContainer/HBoxContainer/ArmorValue.text = str(armor)
func updateSpeed(val : float) -> void:
	speed = val
	$HUD/Control/VBoxContainer/HBoxContainer/SpeedValue.text = str(speed)

func dissableCollisions():
	$body.collision_mask = 0
	$body.collision_layer = 0

func enableCollisions():
	$body.collision_layer = 1 # Player
	$body.collision_mask = 2 | 8 | 16 #Enemy, Bullet Enemy and Wall

func setEnemyStats(currentHP : float, characterType, rightWeapon : Object, leftWeapon : Object, position : Vector2, orientation : float) -> void:
	init_player(characterType)
	HP = currentHP
	if($body/RightWeapon.get_child_count() > 0):
		$body/RightWeapon.get_child(0).queue_free()
	if($body/LeftWeapon.get_child_count() > 0):
		$body/LeftWeapon.get_child(0).queue_free()
	if(rightWeapon != null):
		rightWeapon.setParent(self)
		$body/RightWeapon.add_child(rightWeapon)
	if(leftWeapon != null):
		leftWeapon.setParent(self)
		$body/LeftWeapon.add_child(leftWeapon)
	$body.global_position = position
	$body.rotation = orientation

func goVisibleAndGrabAmoeba():
	get_tree().get_root().remove_child(amoeba)
	$body.add_child(amoeba)
	amoeba.setPosition(Vector2(-10,1))
	amoeba.setRotation(deg2rad(123))
	amoebaOnAir = false
	$body.visible = true