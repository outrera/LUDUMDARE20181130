extends Node

enum GAME_STATE{
	START_SCREEN,
	GAME_SCREEN
}

enum PLAYER_TYPE{RED, BLUE, BIG}
const PLAYER_TYPE_ANIM = {
	PLAYER_TYPE.RED : {"Walking" : "Walking", "Idle" : "Idle"},
	PLAYER_TYPE.BLUE : {"Walking" : "Walking", "Idle" : "Idle"},
	PLAYER_TYPE.BIG : {"Walking" : "WalkingFat", "Idle" : "IdleFat"}
}

const PLAYER_ATTRIBUTES = {
	PLAYER_TYPE.RED		: {"MaxHP" : 80.0,	"MaxStamina" : 150.0,	"Armor" : 3, "Speed" : 7},
	PLAYER_TYPE.BLUE	: {"MaxHP" : 100.0,	"MaxStamina" : 100.0,	"Armor" : 4, "Speed" : 5},
	PLAYER_TYPE.BIG		: {"MaxHP" : 200.0,	"MaxStamina" : 80.0,	"Armor" : 10, "Speed" : 2}
}

#Bullets
enum BULLET_TYPE{STANDARD, THIN, HEAVY, ROUND}
const BULLET_TYPE_ANIM = {STANDARD : "Standard", THIN : "Thin", HEAVY : "Heavy", ROUND : "Round"}
const BULLET_ATTRIBUTES = {
	BULLET_TYPE.STANDARD	: {"Damage" : 5,	"Speed" : 2,	"Penetration" : 1},
	BULLET_TYPE.THIN		: {"Damage" : 5,	"Speed" : 5,	"Penetration" : 5},
	BULLET_TYPE.HEAVY		: {"Damage" : 15,	"Speed" : 1,	"Penetration" : 2},
	BULLET_TYPE.ROUND		: {"Damage" : 10,	"Speed" : 3,	"Penetration" : 1},
}

#Weapons
enum WEAPON_TYPE{PISTOL}
const WEAPON_TYPE_ANIM = {PISTOL : "Pistol"}
const WEAPON_ATTRIBUTES = {
	WEAPON_TYPE.PISTOL	: {"ReloadTime" : 5,	"FireRate" : 0.1, "MagazineSize" : 2, "BulletType" : BULLET_TYPE.STANDARD}
}

const G_CHARACTER = "Character"
const G_PLAYER = "Player"
const G_ENEMY = "Enemy"
const G_WEAPON = "Weapon"
const G_WEAPON_PLAYER = "WeaponPlayer"
const G_WEAPON_ENEMY = "WeaponEnemy"
const G_BULLET = "Bullet"
const G_BULLET_PLAYER = "BulletPlayer"
const G_BULLET_ENEMY = "BulletEnemy"
const G_AMOEBA = "Amoeba"

const bullet_speed_amplification = 200