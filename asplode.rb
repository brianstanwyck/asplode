require 'chipmunk'
require 'gosu'
require 'matrix'
require 'pry'

Dir['./lib/*.rb'].each do |lib|
  require lib
end

ORIGIN = CP::Vec2.new(0, 0)
NUM_ASTEROIDS = 5
MAX_BREAKAGE = 2
NUM_SPLITS = 2
ASTEROID_VERTICES = 12
ASTEROID_MASS = 8
ASTEROID_RADIUS = 50

class AsplodeWindow < Gosu::Window
  include AsteroidMethods
  include BulletMethods
  include KeyHandler

  def initialize
    super 800, 600, false
    self.caption = 'Asplode'

    @bullet_collision = BulletAsteroidCollision.new(self)
    setup_space
    setup_asteroids
    setup_ship
    @bullets = []
  end

  def setup_space
    @space = CP::Space.new
    @space.add_collision_handler :asteroid, :asteroid, NullCollision.new
    @space.add_collision_handler :spaceship, :asteroid, ShipAsteroidCollision.new
    @space.add_collision_handler :bullet, :spaceship, NullCollision.new
    @space.add_collision_handler :bullet, :asteroid, @bullet_collision
  end

  def setup_ship
    @spaceship = Spaceship.new
    @spaceship.place_in_center

    @space.add_body @spaceship.body
    @space.add_shape @spaceship.shape
  end

  def update
    30.times do
      @space.step (1.0 / 60) / 30
    end

    @asteroids.each do |ast|
      ast.fix_position
    end

    @spaceship.fix_position
    @spaceship.limit_velocity

    if @tilting_left
      @spaceship.tilt(:left)
    elsif @tilting_right
      @spaceship.tilt(:right)
    end

    if @thrusting
      @spaceship.thrust
    end
  end

  def draw
    @asteroids.each do |asteroid|
      asteroid.draw(self)
    end

    @bullets.each do |bullet|
      bullet.draw(self)
    end

    @spaceship.draw(self)
  end
end

AsplodeWindow.new.show
