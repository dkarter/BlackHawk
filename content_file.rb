module BlackboardDownloader
  class ContentFile
    attr_accessor :name, :file_type, :original_url, :files

    def initialize(name = nil, file_type = nil, original_url = nil)
      self.name, self.file_type, self.original_url = name, file_type, original_url
      self.files = Array.new
    end

    def content_id
      id = self.original_url.scan(/&content_id=(.*)/)
      id[0][0] if id[0]
    end
  end
end