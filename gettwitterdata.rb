
# Readme: write your id and passowrd ontwitter.yml

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
	#conf.user_agent = ''
	#conf.application_name = ''
	#conf.application_version = 'v0.0.0'
	#conf.application_url = 'http://www.obfuscatism.net'
end

db = PStore.new('./twitterdb')

getpast = false
page = 0
db.transaction do
	if 0 < db.roots.size && 0 < db['tl'].size
		# get last id
		puts "db size: " + db['tl'].size.to_s
	else
		# init
		db['tl'] = []
		db['page'] = 0
		db['recent'] = Time.gm(2006, 5)
		db['old'] = Time.gm(2030)
		getpast = true
	end

	page = db['page']
	recent = db['recent']
	old = db['old']
end


# Login
tw = Twitter::Client.from_config('twitter.yml', 'account')

#limit = tw.account_info(:rate_limit_status)

db.transaction do
	if getpast
		tl = tw.timeline_for(:me, :page => page, :count => 200)
	else
		tl = tw.timeline_for(:me, :since => recent, :page => page, :count => 200)
	end
	puts "tl size " + tl.size.to_s

	ary = db['tl']
	tl.each do |m|
		if ary.index(m) != nil
			page = 0
			break
		else
			page += 1
		end
		#pp m
		d = [m.created_at, m.id, m.text]

		# check most recent/old date
		if recent < d[0]
			recent = d[0]
		end
		if d[0] < old
			old = d[0]
		end

		# push data to array
		ary.push(d)
	end

	db['page'] = page
	db['recent'] = recent
	db['old'] = old
end

#pp tl


#timeline = tw.timeline_for(:me)
#pp timeline

