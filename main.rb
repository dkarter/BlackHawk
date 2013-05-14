require 'highline/import'
require_relative 'black_hawk'

bh = BlackboardDownloader::BlackHawk.new
user = 'dkarter'
pass = ask('Password:')
bh.login_blackboard user, pass
bh.load_courses(true)
bh.load_content_categories
bh.download_docs