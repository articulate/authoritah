require "colorize"

module Cartman
  module Mixins::Paint
    $COLORIZE = true

    def paint(color : Symbol)
      $COLORIZE ? self.colorize(color).to_s : self
    end

    def paint(color : Nil)
      self
    end
  end
end

class String
  include Cartman::Mixins::Paint
end
