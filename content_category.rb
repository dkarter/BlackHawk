require_relative 'content_file'

module BlackboardDownloader
  class ContentCategory
    attr_accessor :name, :original_url, :url, :files

    def initialize(name = nil, original_url = nil)
      self.name, self.original_url = name, original_url
      self.files = Array.new
    end

    def content_id
      id = self.original_url.scan(/content_id=(.*?)&/)
      id[0][0] if id[0]
    end
  
    def predicted_type
      case self.name 
      when "IIT Online Videos"
        :videos
      when "Course Documents", "Content"
        :docs
      when "Syllabus"
        :syllabus
      when "Assignments"
        :assignments
      else
        :unknown
      end
    end

  end
end