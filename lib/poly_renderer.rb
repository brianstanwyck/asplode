class PolyRenderer < Struct.new(:vertices, :rot, :center)
  def rot_matrix
    cos, sin = *rot

    Matrix[
      [cos, -sin],
      [sin,  cos]
    ]
  end

  def rot_points
    pos_x, pos_y = *center

    vertices.map do |x, y|
      if x && y
        (rot_matrix * Matrix[[x], [y]]).to_a
      end
    end.compact.map do |(dx), (dy)|
    [pos_x + dx, pos_y + dy]
    end
  end

  def draw(window, color)
    pos_x, pos_y = *center
    r = rot_points
    (0..r.count-1).each do |i|
      x1, y1 = r[i]
      x2, y2 = r[(i+1) % r.count]
      window.draw_line(x1, y1, color,
                       x2, y2, color)
    end
  end
end
