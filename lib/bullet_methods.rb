module BulletMethods
  def fire_bullet
    x = @spaceship.body.pos.x
    y = @spaceship.body.pos.y
    angle = @spaceship.body.angle

    dx, dy = RotationMatrix.rotate([0, -20], angle)

    new_pos = CP::Vec2.new(
      x + dx, y + dy
    )

    b = Bullet.new(
      new_pos,
      @spaceship.body.angle,
    )

    @space.add_shape(b.shape)
    @space.add_body(b.body)
    @bullets << b
  end

  def remove_bullet(bullet)
    @bullets.delete(bullet)
  end

  def clear_bullets
    @bullets.each do |bullet|
      remove_bullet(bullet) if bullet.off_screen?
    end
  end
end
