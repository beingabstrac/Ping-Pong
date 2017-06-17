require "bundler/setup"
require "hasu"

Hasu.load "ball.rb"
Hasu.load "paddle.rb"

class Pong < Hasu::Window
  WIDTH = 800
  HEIGHT = 600

  def initialize
    super(WIDTH, HEIGHT, false)
    self.caption = "PingPong"

    @background = Gosu::Image.new(self, 'img/bg.png')
    @font = Gosu::Font.new(self, "Hack", 30)
  end

  def reset
    @ball = Ball.new

    @left_score = 0
    @right_score = 0

    # @left_paddle = Paddle.new(:left)
    @left_paddle = Paddle.new(:left, true)
    @right_paddle = Paddle.new(:right)
  end

  def draw
    @background.draw(0,0,0)

    @ball.draw(self)

    draw_text(30, 30, @left_score, @font, 0xfff566270)
    draw_text((WIDTH / 2) - 50, 30, "PingPong", @font, 0xfff34314c)
    draw_text((WIDTH - 50), 30, @right_score, @font, 0xfff566270)

    @left_paddle.draw(self)
    @right_paddle.draw(self)
  end

  def draw_text(x, y, text, font, color)
    font.draw(text, x, y, 3, 1, 1, color)
  end

  def update
    @ball.move!

    if @left_paddle.ai?
      @left_paddle.ai_move!(@ball)
    else
      if button_down?(Gosu::KbW)
        @left_paddle.up!
      end
      if button_down?(Gosu::KbS)
        @left_paddle.down!
      end
    end
    if button_down?(Gosu::KbUp)
      @right_paddle.up!
    end
    if button_down?(Gosu::KbDown)
      @right_paddle.down!
    end

    if @ball.intersect?(@left_paddle)
      @ball.bounce_off_paddle!(@left_paddle)
    end
    if @ball.intersect?(@right_paddle)
      @ball.bounce_off_paddle!(@right_paddle)
    end

    if @ball.off_left?
      @right_score += 1
      @ball = Ball.new
    end
    if @ball.off_right?
      @left_score += 1
      @ball = Ball.new
    end
  end

  def button_down(button)
    case button
    when Gosu::KbEscape
      close
    end
  end
end

Pong.run
