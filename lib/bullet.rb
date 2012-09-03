class Bullet
  attr_accessor :shape, :body
  DEFAULT_VELOCITY = 500
  MASS = 20

  def initialize(position, angle)
    @start = CP::Vec2.new(0, 0)
    @finish = CP::Vec2.new(0, 5)
    moi = CP.moment_for_segment(MASS, @start, @finish)

    @body = CP::Body.new(MASS, moi)
    @body.angle = angle
    @body.pos = position
    @body.vel = CP::Vec2.new *RotationMatrix.rotate(
      [0, -DEFAULT_VELOCITY], angle
    )

    @shape = CP::Shape::Segment.new(@body, @start, @finish, 1)
    @shape.collision_type = :bullet
    @shape.parent = self
  end

  def off_screen?
    pos.first < 0 || pos.last < 0 ||
    pos.first > 800 || pos.last > 600
  end

  def verts
    [[@start.x, @start.y], [@finish.x, @finish.y]]
  end

  def rot
    [@body.rot.x, @body.rot.y]
  end

  def pos
    [@body.pos.x, @body.pos.y]
  end

  def draw(window)
    PolyRenderer.new(verts, rot, pos).draw(
      window, 0xff00ffff
    )
  end
end
