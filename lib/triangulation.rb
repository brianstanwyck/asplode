module Triangulation
  def self.to_body(vertices, mass)
    triangulation = triangulate(vertices)

    vectors = triangulation.map do |triangle|
      triangle.map { |p| CP::Vec2.new(*p) }
    end

    moi = vectors.map do |v|
      CP.moment_for_poly(mass, v, ORIGIN) / (vertices.count)
    end.reduce(:+)

    body = CP::Body.new(mass, moi)

    shapes = vectors.map do |triangle|
      triangle.reverse! if !CP::Shape::Poly.valid?(triangle)
      CP::Shape::Poly.new(body, triangle, ORIGIN)
    end

    [body, shapes]
  end

  # Accepts an array of vertices in clockwise order,
  # and returns an array of triangles which
  # triangulate the original polygon
  def self.triangulate(vertices)
    return [vertices] if vertices.length == 3

    prev, ear, post = nil

    vertices.each_with_index do |v, i|
      # Check if the triangle v_(i-1), v_i, v_(i+1)
      # is contained in the polygon

      p1 = vertices[(i-1) % vertices.count]
      p2 = v
      p3 = vertices[(i+1) % vertices.count]

      midx = [p1,p2,p3].map(&:first).reduce(:+) / 3.0
      midy = [p1,p2,p3].map(&:last).reduce(:+) / 3.0

      if point_in_polygon?(midx, midy, vertices)
        prev, ear, post = p1, p2, p3
        break
      end
    end

    if ear
      [[prev, ear, post]] + triangulate(vertices - [ear])
    else
      vertices
    end
  end

  private

  def self.point_in_polygon?(midx, midy, vertices)
    hits = 0

    vertices.count.times do |j|
      x1, y1 = vertices[j]
      x2, y2 = vertices[(j+1) % vertices.count]

      if (y1 - midy) * (y2 - midy) < 0
        ix = x1 + (x2 - x1) * (midy - y1) / (y2 - y1)
        hits += 1 if ix < midx
      end
    end

    hits % 2 == 1
  end
end
