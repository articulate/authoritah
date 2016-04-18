require "commander"
require "./authoritah"

include Authoritah
include Authoritah::Mixins::Speak

domain_flag = Commander::Flag.new do |flag|
  flag.name = "domain"
  flag.short = "-d"
  flag.long = "--domain"
  flag.default = ""
  flag.description = "The Auth0 domain."
end

setup = Setup.new("./.authoritah")

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

  cmd.commands.add do |cmd|
    cmd.use = "jwt [refresh]"
    cmd.short = "Generate a JWT or force a refresh of the token"

    cmd.flags.add do |flag|
      flag.name = "key"
      flag.short = "-k"
      flag.long = "--key"
      flag.default = ""
      flag.description = "The Auth0 domain key."
    end

    cmd.flags.add do |flag|
      flag.name = "secret"
      flag.short = "-s"
      flag.long = "--secret"
      flag.default = ""
      flag.description = "The Auth0 domain secret."
    end

    cmd.run do |options, arguments|
      key = setup.get("auth0.key", default: options.string["key"], save: true) as String
      secret = setup.get("auth0.secret", default: options.string["secret"], save: true) as String

      error "Missing key or secret options." if key.empty? || secret.empty?

      builder = JWTBuilder.new(key, secret, setup)

      if arguments.size > 0 && arguments.first == "refresh"
        jwt = builder.refresh
        ok "Regenerated JWT: #{jwt}"
      else
        jwt = builder.generate
        ok "Generated JWT: #{jwt}"
      end
    end
  end
end

Commander.run(cli, ARGV)
