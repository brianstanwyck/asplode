require 'set'

class BulletAsteroidCollision < Struct.new(:window)
  def initialize(window)
    super window
    false
  end

  def begin(bullet, asteroid)
    bullet.collision_type = :asteroid
  end

  def pre_solve(bullet, asteroid)
    window.remove_bullet(bullet.parent)
    window.remove_asteroid(asteroid.parent)
    if asteroid.parent.radius > ASTEROID_RADIUS/(MAX_BREAKAGE ** NUM_SPLITS)
      window.break_asteroid(asteroid.parent)
    end
  end
end
