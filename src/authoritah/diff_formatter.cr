module Authoritah
  class DiffFormatter
    UI = {
      added:   {symbol: "+", color: :green},
      removed: {symbol: "-", color: :red},
      changed: {symbol: "*", color: :yellow},
    }

    def initialize(@diffs : Array)
      @diff_string = ""
    end

    def format
      @diffs.each { |diff| format diff }
      @diff_string
    end

    def format(diff : Hash, indent_level = 0)
      diff.each do |k, v|
        @diff_string += "#{k}:\n"
        format(v, indent_level + 1)
      end
    end

    def format(diff : Diff, indent_level = 0)
      format_removed(diff, indent_level) if diff.removed?
      format_added(diff, indent_level) if diff.added?
      format_changed(diff, indent_level) if diff.changed?
    end

    def format_changed(diff : Diff, indent_level)
      format_at_indent(diff.local, UI[:changed], indent_level)
    end

    def format_added(diff : Diff, indent_level)
      format_at_indent(diff.local, UI[:added], indent_level)
    end

    def format_removed(diff : Diff, indent_level)
      format_at_indent(diff.server, UI[:removed], indent_level)
    end

    def format_at_indent(details : Diff, ui, indent_level)
      format_at_indent(details.name, ui, indent_level)
    end

    def format_at_indent(details : String, ui, indent_level)
      indents = Array.new(indent_level, "  ").join("")
      formatted = (ui[:symbol] as String) + indents + details + "\n"

      @diff_string += formatted.paint(ui[:color] as Symbol)
    end

    def format_at_indent(details, ui, indent_level)
      format_at_indent(details.to_s, ui, indent_level)
    end
  end
end
