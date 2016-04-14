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
  end
end
