
require 'pp'
require 'pstore'
require 'time'

require 'rubygems'
gem 'twitter4r', '0.3.0'
require 'twitter'
require 'twitter/console'

Twitter::Client.configure do |conf|
	# Default server
	conf.host = 'twitter.com'

	# Connection to twitter
	conf.protocol = :ssl
	conf.port = 443

	# Proxy: default values are set to nil
	#conf.proxy_host 'myproxy'
	#conf.proxy_port = 8080
	#conf.proxy_user = 'user'
	#conf.proxy_pass = 'pass'

	# Application names
	conf.user_agent = ''
	conf.application_name = ''
	conf.application_version = 'v0.0.0'
	conf.application_url = 'http://www.obfuscatism.net'
end

db = PStore.new('./twitterdb')

page = 0
db.transaction do
	if 0 < db.roots.size && 0 < db['tl'].size
		# get last id
		puts "db size: " + db['tl'].size.to_s
		ary = db['tl']
		page = db['page']
	else
		# init
		db['tl'] = []
		db['page'] = 0
	end
end
#return

# Login
tw = Twitter::Client.from_config('twitter.yml', 'account')

#limit = tw.account_info(:rate_limit_status)
#pp limit

# Get past log
3.times do 
	db.transaction do
		tl = tw.timeline_for(:me, :page => page, :count => 200)
		puts "tl size " + tl.size.to_s

		ary = db['tl']
		tl.each do |m|
			if ary.index(m) != nil
				puts "finished!!"
				db['page'] = 0
				exit 0
			end
			#pp m
			d = [m.created_at, m.id, m.text]
			#pp d
			ary.push(d)
		end
		puts "finished db"
		pp ary

		db['page'] = page + 1
		page += 1
	end
end

#pp tl


#timeline = tw.timeline_for(:me)
#pp timeline

