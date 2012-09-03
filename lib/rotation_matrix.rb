module RotationMatrix
  def self.rotate(pos, angle)
    (self.matrix(angle) * Matrix[
      *pos.map { |coord| [coord] }
    ]).to_a.flatten
  end

  def self.matrix(angle)
    cos = Math.cos angle
    sin = Math.sin angle

    Matrix[
      [cos, -sin],
      [sin, cos]
    ]
  end
end
