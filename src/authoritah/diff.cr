module Authoritah
  class Diff
    def_equals @local, @server

    def initialize(@local, @server)
    end

    def changed?
      @local != @server
    end
  end
end
