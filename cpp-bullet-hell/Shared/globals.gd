extends Node

var bullet_manager : BulletManager = null

var player : Player = null

var max_left  : float = 0
var max_right : float = 0
var max_up    : float = 0
var max_down  : float = 0

var initial_projectile_speed = 850
var projectile_speed_increase = 50

var current_projectiles : int

var spawning : bool = false
