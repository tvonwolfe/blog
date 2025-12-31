module Components
  class MetaTags < Base
    attr_reader :data

    def initialize(data = [])
      @data = data
    end

    def add(**args)
      data << args unless args.blank?
    end

    def view_template
      data.each do |args|
        meta(**args)
      end
    end
  end
end
