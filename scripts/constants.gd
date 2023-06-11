# Shared place for commonly used values

class_name Constants

enum EnemyState { FlyIn, Protect, Attack }
enum EnemyType { Empty, GreenAlien, RedFlameGuy, SpinningShip, YellowShip, Boss }
enum PlayerState { Alive, Invincible, Respawning }

static func noop(_args):
	pass

static func isEitherOf(id, types: Array) -> bool:
	return types.any(func(type): return type == id)
