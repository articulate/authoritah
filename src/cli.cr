require "commander"
require "./authoritah"

domain_flag = Commander::Flag.new do |flag|
  flag.name = "domain"
  flag.short = "-d"
  flag.long = "--domain"
  flag.default = ""
  flag.description = "The Auth0 domain."
end

setup = Authoritah::Setup.new

cli = Commander::Command.new do |cmd|
  cmd.use = "authoritah"
  cmd.long = "Authoritah is a tool for managing Auth0 configuration via declarative configuration."

  # Config settings
  cmd.commands.add do |cmd|
    cmd.use = "config [cmd] [options]"
    cmd.short = "Set biplane configuration options"
    cmd.long = <<-DESC
    Commands available:
      `show`
      `set key=value [key=value...]`
      `get key [key...]`
      `remove key [key...]`
    DESC

    cmd.run do |options, arguments|
      cmd = arguments.empty? ? "show" : arguments.shift

      case cmd
      when "show"
        values = setup.show
        values.empty? ? puts "(nothing set)" : puts values
      when "set"
        setup.set(arguments)
      when "get"
        values = setup.gets(arguments)

        if values.empty?
          puts "(nothing found)"
        else
          puts arguments.zip(values).map(&.join("=")).join("\n")
        end
      when "remove"
        setup.remove(arguments)
      else
        puts "'#{cmd}' is not a valid config action. Available actions are show, get, set and remove".colorize(:yellow)
      end
    end
  end

end

Commander.run(cli, ARGV)
