module SimpleBuilder
  class Build < Sequel::Model
    plugin :timestamps
    plugin :json_serializer
    plugin :validation_helpers

    def validate
      validates_presence [:script]
    end
  end
end
