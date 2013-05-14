require_relative 'black_hawk'

bh = BlackboardDownloader::BlackHawk.new
bh.login_blackboard
bh.load_courses(true)
bh.load_content_categories
bh.download_docs