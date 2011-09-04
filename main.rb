##########################################################################################################
$:.unshift(File.dirname(__FILE__))
require 'rubygems'
require 'sinatra'
require 'builder'
require 'sinatra/content_for'
require 'sequel'
require 'maruku'
require 'syntax/convertors/html'
require 'post'

##########################################################################################################
set :environment, :development
configure do
	require 'ostruct'
	Blog = OpenStruct.new(
		:title => 'imaginaryProducts',
		:author => 'imaginaryProducts',
		:url_base => 'http://imaginaryProducts.com/blog',
		:admin_password => 'bigGameLLC',
		:admin_cookie_key => 'ip_admin',
		:admin_cookie_value => 'lweiueqi828383722289jjkahw31122',
		:disqus_shortname => 'imaginaryproductsofficialblog'
	)
end

#---------------------------------------------------------------------------------------------------------
error do
	e = request.env['sinatra.error']
	puts e.to_s
	puts e.backtrace.join("\n")
	"Application error"
end

#---------------------------------------------------------------------------------------------------------
helpers do
	def admin?
		request.cookies[Blog.admin_cookie_key] == Blog.admin_cookie_value
	end
	def auth
		stop [401, 'Not authorized'] unless admin?
	end
end

#---------------------------------------------------------------------------------------------------------
# company
#---------------------------------------------------------------------------------------------------------
get '/' do
	erb :index, :layout => :layout
end

#---------------------------------------------------------------------------------------------------------
# products
#---------------------------------------------------------------------------------------------------------
get '/products' do
	erb :products, :layout => :layout
end

#---------------------------------------------------------------------------------------------------------
get '/products/mars-mission' do
	erb :mars_mission, :layout => false
end

#---------------------------------------------------------------------------------------------------------
get '/products/web-gnosus' do
	erb :web_gnosus, :layout => false
end

#---------------------------------------------------------------------------------------------------------
# projects agent-xmpp
#---------------------------------------------------------------------------------------------------------
get '/projects' do
	erb :projects, :layout => :layout
end

#---------------------------------------------------------------------------------------------------------
get '/projects/agent-xmpp' do
	erb :agent_xmpp, :layout => :agent_xmpp_layout
end

#---------------------------------------------------------------------------------------------------------
get '/projects/agent-xmpp/docs' do
	erb :agent_xmpp_docs, :layout => :agent_xmpp_layout
end

#---------------------------------------------------------------------------------------------------------
get '/projects/agent-xmpp/videos/web-gnosus' do
	erb :agent_xmpp_videos_web_gnosus, :layout => :agent_xmpp_layout
end

#---------------------------------------------------------------------------------------------------------
get '/projects/agent-xmpp/videos/gajim' do
	erb :agent_xmpp_videos_gajim, :layout => :agent_xmpp_layout
end

#---------------------------------------------------------------------------------------------------------
# projects zgomot
#---------------------------------------------------------------------------------------------------------
get '/projects/zgomot' do
	erb :zgomot, :layout => :zgomot_layout
end

#---------------------------------------------------------------------------------------------------------
get '/projects/zgomot/docs' do
	erb :zgomot_docs, :layout => :zgomot_layout
end

#---------------------------------------------------------------------------------------------------------
# blog
#---------------------------------------------------------------------------------------------------------
get '/blog' do
	posts = Post.reverse_order(:created_at).limit(10)
	erb :blog, :locals => { :posts => posts }, :layout => :blog_layout
end

#---------------------------------------------------------------------------------------------------------
get '/blog/past/:year/:month/:day/:slug/' do
	post = Post.filter(:slug => params[:slug]).first
	stop [404, "Page not found"] unless post
	@title = post.title
	erb :post, :locals => {:post => post}, :layout => :blog_layout
end

#---------------------------------------------------------------------------------------------------------
get '/blog/past/:year/:month/:day/:slug' do
	redirect "#{Path::BLOG_PAST}/#{params[:year]}/#{params[:month]}/#{params[:day]}/#{params[:slug]}/", 301
end

#---------------------------------------------------------------------------------------------------------
get '/blog/past' do
	posts = Post.reverse_order(:created_at)
	@title = "Archive"
	erb :archive, :locals => { :posts => posts }, :layout => :blog_layout
end

#---------------------------------------------------------------------------------------------------------
get '/blog/feed' do
	@posts = Post.reverse_order(:created_at).limit(20)
	content_type 'application/atom+xml', :charset => 'utf-8'
	builder :feed
end

#---------------------------------------------------------------------------------------------------------
get '/blog/rss' do
	redirect '/blog/feed', 301
end

#---------------------------------------------------------------------------------------------------------
# admin
#---------------------------------------------------------------------------------------------------------
get '/blog/auth' do
	erb :auth, :layout => :blog_layout
end

#---------------------------------------------------------------------------------------------------------
post '/blog/auth' do
	response.set_cookie(Blog.admin_cookie_key, :value => Blog.admin_cookie_value) if params[:password] == Blog.admin_password
	redirect '/blog'
end

#---------------------------------------------------------------------------------------------------------
get '/blog/posts/new' do
	auth
	erb :new, :locals => {:post => Post.new, :url => '/blog/posts'}, :layout => :blog_layout
end

#---------------------------------------------------------------------------------------------------------
post '/blog/posts' do
	auth
	post = Post.new(:title => params[:title], :body => params[:body], :created_at => Time.now, :slug => Post.make_slug(params[:title]))
	post.save
	redirect post.url
end

#---------------------------------------------------------------------------------------------------------
get '/blog/past/:year/:month/:day/:slug/edit' do
	auth
	post = Post.filter(:slug => params[:slug]).first
	stop [404, "Page not found"] unless post
	erb :edit, :locals => {:post => post, :url => post.url}, :layout => :blog_layout
end

#---------------------------------------------------------------------------------------------------------
post '/blog/past/:year/:month/:day/:slug/' do
	auth
	post = Post.filter(:slug => params[:slug]).first
	stop [404, "Page not found"] unless post
	post.title = params[:title]
	post.body = params[:body]
	post.save
	redirect post.url
end
