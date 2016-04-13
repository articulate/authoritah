require "colorize"

module Authoritah
  module Mixins::Speak
    def error(message)
      puts message.paint(:red)
      exit(1)
    end

    def warn(message)
      puts message.paint(:yellow)
    end

    def ok(message)
      puts message.paint(:green)
    end
  end
end
