class Asteroid < Struct.new(:radius, :vertices, :mass)
  attr_accessor :body, :shapes

  def self.generate(radius, num_vertices, mass)
    vertices = []

    angle = 0
    num_vertices.times do
      r = rand * radius/2 + radius/2

      x = Math.cos(angle) * r
      y = Math.sin(angle) * r

      angle += (2 * Math::PI)/num_vertices
      vertices << [x, y]
    end

    # Make clockwise
    vertices.reverse!

    self.new(radius, vertices, mass)
  end

  def initialize(radius, vertices, mass)
    super radius, vertices, mass
    @body, @shapes = Triangulation.to_body(vertices, mass)
    @shapes.each do |shape|
      shape.collision_type = :asteroid
      shape.e = 0.8
      shape.parent = self
    end
  end

  def fix_position
    @body.pos.x %= 800
    @body.pos.y %= 600
  end

  def break(num_pieces)
    (1..num_pieces).map do
      ast = Asteroid.generate(radius / num_pieces, self.vertices.count,
                              mass / num_pieces)
      ast
    end
  end

  def rot
    [@body.rot.x, @body.rot.y]
  end

  def pos
    [@body.pos.x, @body.pos.y]
  end

  def draw(window)
    PolyRenderer.new(vertices, rot, pos).draw(window, 0xffffffff)
  end
end
