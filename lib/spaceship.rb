class Spaceship
  attr_reader :body, :shape
  attr_accessor :color

  PTS = [
    [5, 5],
    [0, -10],
    [-5, 5]
  ]

  VECTORS = PTS.map do |x, y|
    CP::Vec2.new x,y
  end

  MAX_VELOCITY = 400
  THRUST_POWER = 250

  def initialize
    mass = 20
    moi = CP.moment_for_poly(mass, VECTORS, ORIGIN)
    @body = CP::Body.new(mass, moi)
    @shape = CP::Shape::Poly.new(@body, VECTORS, ORIGIN)
    @shape.collision_type = :spaceship
    @shape.parent = self
    @color = 0xffffffff
  end

  def rot
    [@body.rot.x, @body.rot.y]
  end

  def pos
    [@body.pos.x, @body.pos.y]
  end

  def place_in_center
    @body.pos = CP::Vec2.new(400, 300)
  end

  def tilt(dir)
    sign = dir == :left ? -1 : 1
    angle = @body.angle + sign * Math::PI/40

    @body.angle = angle
  end

  def thrust_force
    cos, sin = rot
    rot_matrix = Matrix[[cos, -sin], [sin, cos]]

    thrust_array = (rot_matrix * Matrix[[0], [-THRUST_POWER]]).to_a.flatten
    CP::Vec2.new(
      *thrust_array
    )
  end

  def fix_position
    @body.pos.x %= 800
    @body.pos.y %= 600
  end

  # Ensures the ship speed can only ever be MAX_VELOCITY
  def limit_velocity
    speed = Math.sqrt(@body.vel.x ** 2 + @body.vel.y ** 2)
    if speed > MAX_VELOCITY
      vel_cos = @body.vel.x / speed
      vel_sin = @body.vel.y / speed
      rot_matrix = Matrix[[vel_cos, -vel_sin], [vel_sin, vel_cos]]
      new_vel_cos, new_vel_sin = (rot_matrix * Matrix[[MAX_VELOCITY], [0]]).to_a.flatten

      @body.vel = CP::Vec2.new(new_vel_cos, new_vel_sin)
    end
  end

  def thrust
    @body.apply_impulse(thrust_force, ORIGIN)
  end

  def center
    [@body.pos.x, @body.pos.y]
  end

  def draw(window)
    PolyRenderer.new(PTS, rot, pos).draw(window, color)
  end
end
