require_relative 'content_category'

module BlackboardDownloader
  class Course
    attr_accessor :full_name, :url, :instructors, :content_categories
    
    def initialize(full_name = nil, url = nil)
      self.content_categories = Array.new
      self.instructors = Array.new
      
      self.full_name, self.url = full_name, url
    end

    def course_id
      self.url.scan(/Course%26id%3D(.*?)%/)[0][0]
    end

    def code
      self.full_name.scan(/(.*?)-(.*?)-/)[0].join("-")
    end

    def name
      self.full_name.scan(/.*: (.*?) -/)[0][0]
    end

  end
end