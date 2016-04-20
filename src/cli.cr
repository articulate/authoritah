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

  cmd.commands.add do |cmd|
    cmd.flags.add domain_flag
    cmd.use = "diff [rules file]"
    cmd.short = "Shows differences between existing ruleset and local config"
    cmd.run do |options, arguments|
      input = arguments.size > 0 ? arguments[0] : STDIN

      begin
        client = Auth0Client.new(setup)
        local = LocalManifest.new(input)
        server = ServerManifest.new(client)

        diff = local.diff(server)
        if diff.empty?
          ok "No changes found!"
        else
          puts DiffFormatter.new(diff).format
        end

        nil
      rescue e
        error e.message.to_s
      end
    end
  end

  cmd.commands.add do |cmd|
    cmd.flags.add domain_flag
    cmd.use = "dump [rules file]"
    cmd.short = "Saves server ruleset to local file"
    cmd.flags.add do |flag|
      flag.name = "scripts"
      flag.short = "-s"
      flag.long = "--scripts"
      flag.default = "./rules"
      flag.description = "Folder path to save the rule scripts"
    end
    cmd.run do |options, arguments|
      output = arguments.size > 0 ? File.new(arguments[0], "w") : STDOUT

      client = Auth0Client.new(setup)
      rules = client.fetch_all

      rules.map &.save_script(options.string["scripts"]) unless output == STDOUT
      output << YAML.dump(rules.map(&.serialize))

      output.close if output.is_a? File

      nil
    end
  end

  cmd.commands.add do |cmd|
    cmd.flags.add domain_flag
    cmd.use = "apply [rules file]"
    cmd.short = "Applies config to an Auth0 instance"
    cmd.run do |options, arguments|
      input = arguments.size > 0 ? arguments[0] : STDIN

      begin
        client = Auth0Client.new(setup)
        local = LocalManifest.new(input)
        server = ServerManifest.new(client)

        diff = local.diff(server)
        if diff.empty?
          ok "No changes found!"
        else
          rules = DiffApplier.new(diff, client).apply
        end

        nil
      rescue e
        error e.message.to_s
      end
    end
  end
end

Commander.run(cli, ARGV)
