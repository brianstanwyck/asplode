module AsteroidMethods
  def setup_asteroids
    @asteroids = []

    NUM_ASTEROIDS.times do
      add_rand_asteroid(ASTEROID_RADIUS)
    end
  end

  def add_rand_asteroid(radius, pos = nil)
    asteroid = Asteroid.generate(radius,
                                 ASTEROID_VERTICES, ASTEROID_MASS)
    add_asteroid(asteroid, pos)
  end

  def add_asteroid(asteroid, pos = nil)
    if pos
      asteroid.body.pos = CP::Vec2.new(*pos)
    else
      asteroid.body.pos = CP::Vec2.new(rand(800), rand(600))
    end

    @space.add_body asteroid.body
    asteroid.shapes.each do |shape|
      @space.add_shape shape
    end

    asteroid.body.vel = CP::Vec2.new(rand(-100..100), rand(-100..100))

    @asteroids << asteroid
  end

  def break_asteroid(ast)
    remove_asteroid(ast)

    ast.break(NUM_SPLITS).each do |new_ast|
      add_asteroid(new_ast, ast.pos)
    end

    remove_asteroid(ast)
  end

  def remove_asteroid(ast)
    ast.shapes.each do |shape|
      @space.remove_shape(shape)
    end

    @space.remove_body(ast.body)
    @asteroids.delete(ast)
  end
end
