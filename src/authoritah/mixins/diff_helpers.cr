module Authoritah
  module Mixins::DiffHelpers
    macro def_equals_type(type, *fields)
      def ==(other : {{type}})
        {% for field in fields %}
          return false unless {{field.id}} == other.{{field.id}}
        {% end %}
        true
      end
    end
  end
end
