module Authoritah
  module Mixins::DiffHelpers
    macro def_equals_type(type, *fields)
      def ==(other : {{type}})
        {% for field in fields %}
          return false unless {{field.id}} == other.{{field.id}}
        {% end %}
        true
      end

      def diff(other : {{type}})
        {
          {% for attr in fields %}
            {{attr}} => Diff.new(self.{{attr.id}}, other.{{attr.id}}),
          {% end %}
        }.reject{|_,diff| !diff.changed? }
      end
    end
  end
end
