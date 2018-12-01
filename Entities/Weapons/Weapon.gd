extends Node2D
var bulletFactory = preload("res://Entities/Weapons/Bullet.tscn")


var reloadTime : float = 1.0
var magazineSize : int = 1.0
var fireRate : float = 1.0
var bullets : int = 0
var weaponType = Constants.WEAPON_TYPE.PISTOL
var bulletType = Constants.BULLET_TYPE.STANDARD
var parent = null

var fireRateReady = true
var reloading = false

func _ready():
	add_to_group(Constants.G_WEAPON)

func _process(_delta):
	if(Input.is_action_pressed("ui_accept")):
		attack()

func init(_weaponType, _position : Vector2, _parent : Object) -> void:
	parent = _parent
	global_position = _position
	rotation = parent.getOrientation()
	
	#We update the group depending on if the parent is an enemy or a player
	if(parent.is_in_group(Constants.G_ENEMY)):
		add_to_group(Constants.G_WEAPON_ENEMY)
	elif(parent.is_in_group(Constants.G_PLAYER)):
		add_to_group(Constants.G_WEAPON_PLAYER)
	else:
		OS.alert(get_name() + " init: Parent is not an enemy or a player", "Implementation error")
	
	#We need to create the weapon depending on the type with specific attributes
	weaponType = _weaponType

	$AnimationPlayer.play(Constants.WEAPON_TYPE_ANIM[_weaponType])
	var attrs = Constants.WEAPON_ATTRIBUTES[_weaponType]
	
	reloadTime = attrs["ReloadTime"]
	magazineSize = attrs["MagazineSize"]
	bulletType = attrs["BulletType"]
	fireRate = attrs["FireRate"]
	
	$Reload.wait_time = reloadTime
	$FireRate.wait_time = fireRate
	
func attack() -> void:
	if bullets <= 0:
		reload()
		return
		
	if fireRateReady:
		var bullet = bulletFactory.instance()
		get_tree().get_root().add_child(bullet)
		bullet.init(bulletType, $FireCannon.global_position, self)
		bullets -= 1
		fireRateReady = false
		$FireRate.start()

func reload() -> void:
	bullets = magazineSize
	$Reload.start()
	reloading = true
	#TODO Play animation sound

func getOrientation() -> float:
	return parent.getOrientation()

func _on_Reload_timeout():
	reloading = false


func _on_FireRate_timeout():
	fireRateReady = true
