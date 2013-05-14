require 'rubygems'
require 'capybara'
require 'capybara/dsl'

require_relative 'course'

Capybara.run_server = false
Capybara.current_driver = :selenium
Capybara.app_host = 'https://blackboard.iit.edu'

module BlackboardDownloader
  class BlackHawk
    include Capybara::DSL

    @courses = nil
    @save_path = nil

    def initialize(save_path = "~/blackboard_files")
      @courses = Array.new
      @save_path = save_path
    end

    #TODO: remove defaults
    def login_blackboard(user_id = 'dkarter', password = '')
      # TODO: modify to return a result so that we can handle if something goes wrong
      visit '/'
      fill_in 'user_id', :with => user_id
      fill_in 'password', :with => password
      click_button 'Login'

      if page.all(:xpath, '//frame[@name="content"]')
        puts "Login Successful!"
      else
        puts "Login Failed! Please request an update on github."
      end
    end

    def load_courses(print_list)
      # visit the course list
      visit '/webapps/portal/execute/tabs/tabAction?tab_tab_group_id=_2_1'
      sleep 1.0
      elems = page.all('.courseListing li a')
      
      count = 0
      elems.each do |e|
        count += 1 

        c = Course.new(e.text, e['href'])
        @courses << c
        
        puts "#{count}) #{c.code}" if print_list
      end
    
    end

    def load_content_categories
      url = '/webapps/blackboard/execute/modulepage/view?course_id='
      @courses.each do |c|
        visit url + c.course_id
        
        elems = page.all('.courseMenu li a')      
        elems.each do |e|
          cc = ContentCategory.new(e.text, e['href'])

          if cc.content_id
            c.content_categories << cc
          end
          
        end
      end
    end

    def download_docs
      puts "Downloading all docs for all courses..."
      @courses.each do |c|
        puts "#{c.name}..."
        load_course_docs(c)

      end
      puts "Done! All docs have been saved to #{@save_path}"
    end

    def load_course_docs(course)
      course.content_categories.each do |cc|
        if cc.predicted_type == :docs
          load_files(course.course_id, cc, cc.content_id)
          # download_course_docs(cc.files)
        end 
      end
    end

    def load_files(course_id, parent, parent_cont_id)
      visit "/webapps/blackboard/content/listContent.jsp?course_id=#{course_id}&content_id=#{parent_cont_id}"

      folders = Array.new

      elems = page.all('#content_listContainer li')
      elems.each do |e|
        link = e.find('a')
        
        file_type = identify_file_type(e.find('img')['src'])

        cf = ContentFile.new(link.text, file_type, link['href'])
        parent.files << cf
        folders << cf if file_type == :folder
        #puts "-- #{cf.name} - #{cf.content_id} (#{cf.file_type}): #{cf.original_url}"
      end

      # must implement recursiveness after we are done, in this fashion to 
      # allow pages to load and process fully
      folders.each { |f| load_files(course_id, f, f.content_id)  }
    end

    def download_course_docs(files)
      
    end

    private
    #identify file/folder by icon
    def identify_file_type(icon_src)
      file_type = :unknown
      if icon_src.include?('folder')
        file_type = :folder
      elsif icon_src.include?('file_on')
        file_type = :file
      end
      file_type
    end

  end
end