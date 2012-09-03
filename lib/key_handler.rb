module KeyHandler
  def button_down(id)
    case id
    when Gosu::KbEscape
      close
    when Gosu::KbLeft
      @tilting_left = true
      @tilting_right = false
    when Gosu::KbRight
      @tilting_right = true
      @tilting_left = false
    when Gosu::KbUp
      @spaceship.thrust
      @thrusting = true
    when Gosu::KbSpace
      fire_bullet
    end
  end

  def button_up(id)
    case id
    when Gosu::KbLeft
      @tilting_left = false
    when Gosu::KbRight
      @tilting_right = false
    when Gosu::KbUp
      @spaceship.stop_thrust
      @thrusting = false
    end
  end
end
