module Authoritah
  module Mixins::Serializer
    macro serialize_with(*attrs)
      def serialize
        {
        {% for attr in attrs %}
          {{attr}} => self.{{attr.id}},
        {% end %}
        }.reject {|_,v| v.nil? }
      end
    end

    macro ignore_update(*attrs)
      def for_update
        serialize.reject {|k,_| {{attrs}}.includes? k }
      end
    end
  end
end
