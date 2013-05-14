require 'rubygems'
require 'capybara'
require 'capybara/dsl'
require 'highline/import'

module BlackboardDownloader
  class CapybaraTester
    include Capybara::DSL
    def element_selector
      url = ask('url:')
      
      url = '/webapps/portal/execute/tabs/tabAction?tab_tab_group_id=_2_1' if url.empty?

      # visit the url
      visit url

      looping = true

      while looping
        find_str = ask('Find/All:')
        begin
          if find_str.empty?
            looping = false
            abort
          end
          if find_str.downcase == 'find'
            q = ask('find what:')
            elem = page.find(q)
            puts elem.text    
          else
            q = ask('find all what:')
            elems = page.all(q)
            elems.each { |e| puts e.text }
          end
          
        rescue Exception => e
          if e.message != "exit"
            puts e.message
            puts e.backtrace.join("\n")
          end
        end
      end
      
      puts "\nall done!"

    end
    
    
  end
end