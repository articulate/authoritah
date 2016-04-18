module Authoritah
  class Diff
    def_equals @local, @server

    getter! :local, :server, :config

    def initialize(@local, @server, @config = nil)
      @config ||= @local if @local.is_a? RuleConfig
    end

    def empty?
      @local == @server
    end

    def changed?
      !@local.nil? && !@server.nil? && @local != @server
    end

    def added?
      !@local.nil? && @server.nil?
    end

    def removed?
      @local.nil? && !@server.nil?
    end

    def model
      return server if removed?
      return local if added? || changed?
    end

    def state
      return :removed if removed?
      return :added if added?
      return :changed if changed?
      :equal # should never happen
    end
  end
end
