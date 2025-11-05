module Components
  class MetaTags < Base
    attr_reader :data

    def initialize
      @data = []
    end

    def add(**args)
      data << args
    end

    def view_template
      data.each do |args|
        meta(**args)
      end
    end
  end
end
