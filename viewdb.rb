
require 'pp'
require 'rubygems'
gem 'twitter4r', '0.3.0'
require 'twitter'
require 'twitter/console'
require 'pstore'


db = PStore.new('./twitterdb')

db.transaction do
	pp db.roots
	if 0 < db.roots.size && 0 < db['tl'].size
		puts "db size: " + db['tl'].size.to_s
		puts "page " + db['page'].to_s
		ary = db['tl']
		#ary.uniq
		pp ary
	else
		puts "nothing"
	end
end


