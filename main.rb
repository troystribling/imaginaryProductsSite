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
class Path
  COMPANY                   = '/'
  PRODUCTS                  = '/products' 
  PRODUCTS_MARS_MISSION     = PRODUCTS + '/mars-mission'
  PRODUCTS_WEB_GNOSUS       = PRODUCTS + '/web-gnosus'
  PROJECTS                  = '/projects' 
  PROJECTS_AGENT_XMPP_DOCS  = PROJECTS + '/agent-xmpp/docs'
  PROJECTS_AGENT_XMPP       = PROJECTS + '/agent-xmpp'
  PROJECTS_ZGOMOT           = PROJECTS + '/zgomot'
  PROJECTS_ZGOMOT_DOCS      = PROJECTS + '/zgomot/docs'
  BLOG                      = '/blog' 
  BLOG_EDIT                 = BLOG + '/past/:year/:month/:day/:slug/edit'
  BLOG_POSTS                = BLOG + '/posts'
  BLOG_POSTS_NEW            = BLOG + '/posts/new'
  BLOG_PAST                 = BLOG + '/past'
  BLOG_PAST_ITEM            = BLOG + '/past/:year/:month/:day/:slug'
  BLOG_FEED                 = BLOG + '/feed'
  BLOG_RSS                  = BLOG + '/rss'
  BLOG_AUTH                 = BLOG + '/auth'
end

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
get Path::COMPANY do
	erb :index, :layout => :layout
end

#---------------------------------------------------------------------------------------------------------
# products
#---------------------------------------------------------------------------------------------------------
get Path::PRODUCTS do
	erb :products, :layout => :layout
end

#---------------------------------------------------------------------------------------------------------
get Path::PRODUCTS_MARS_MISSION do
	erb :mars_mission, :layout => false
end

#---------------------------------------------------------------------------------------------------------
get Path::PRODUCTS_WEB_GNOSUS do
	erb :web_gnosus, :layout => false
end

#---------------------------------------------------------------------------------------------------------
# projects
#---------------------------------------------------------------------------------------------------------
get Path::PROJECTS do
	erb :projects, :layout => :layout
end

#---------------------------------------------------------------------------------------------------------
# projects
#---------------------------------------------------------------------------------------------------------
get Path::PROJECTS do
	erb :projects, :layout => :layout
end

#---------------------------------------------------------------------------------------------------------
get Path::PROJECTS_AGENT_XMPP do
	erb :agent_xmpp, :layout => false
end

#---------------------------------------------------------------------------------------------------------
get Path::PROJECTS_AGENT_XMPP_DOCS do
  File.read('public/agent-xmpp/README_rdoc.html')
end

#---------------------------------------------------------------------------------------------------------
get Path::PROJECTS_ZGOMOT do
	erb :zgomot, :layout => false
end

#---------------------------------------------------------------------------------------------------------
get Path::PROJECTS_ZGOMOT_DOCS do
  File.read('public/zgomot/README_rdoc.html')
end

#---------------------------------------------------------------------------------------------------------
# blog
#---------------------------------------------------------------------------------------------------------
get Path::BLOG do
	posts = Post.reverse_order(:created_at).limit(10)
	erb :blog, :locals => { :posts => posts }, :layout => false
end

#---------------------------------------------------------------------------------------------------------
get Path::BLOG_PAST_ITEM + '/' do
	post = Post.filter(:slug => params[:slug]).first
	stop [404, "Page not found"] unless post
	@title = post.title
	erb :post, :locals => {:post => post}, :layout => :layout
end

#---------------------------------------------------------------------------------------------------------
get Path::BLOG_PAST_ITEM do
	redirect "#{Path::BLOG_PAST}/#{params[:year]}/#{params[:month]}/#{params[:day]}/#{params[:slug]}/", 301
end

#---------------------------------------------------------------------------------------------------------
get Path::BLOG_PAST do
	posts = Post.reverse_order(:created_at)
	@title = "Archive"
	erb :archive, :locals => { :posts => posts }, :layout => :layout
end

#---------------------------------------------------------------------------------------------------------
get Path::BLOG_FEED do
	@posts = Post.reverse_order(:created_at).limit(20)
	content_type 'application/atom+xml', :charset => 'utf-8'
	builder :feed
end

#---------------------------------------------------------------------------------------------------------
get Path::BLOG_RSS do
	redirect Path::BLOG_FEED, 301
end

#---------------------------------------------------------------------------------------------------------
# admin
#---------------------------------------------------------------------------------------------------------
get Path::BLOG_AUTH do
	erb :auth, :layout => :layout
end

#---------------------------------------------------------------------------------------------------------
post Path::BLOG_AUTH do
	response.set_cookie(Blog.admin_cookie_key, :value => Blog.admin_cookie_value) if params[:password] == Blog.admin_password
	redirect '/blog'
end

#---------------------------------------------------------------------------------------------------------
get Path::BLOG_POSTS_NEW do
	auth
	erb :new, :locals => {:post => Post.new, :url => '/blog/posts'}, :layout => :layout
end

#---------------------------------------------------------------------------------------------------------
post Path::BLOG_POSTS do
	auth
	post = Post.new(:title => params[:title], :body => params[:body], :created_at => Time.now, :slug => Post.make_slug(params[:title]))
	post.save
	redirect post.url
end

#---------------------------------------------------------------------------------------------------------
get Path::BLOG_EDIT do
	auth
	post = Post.filter(:slug => params[:slug]).first
	stop [404, "Page not found"] unless post
	erb :edit, :locals => {:post => post, :url => post.url}, :layout => :layout
end

#---------------------------------------------------------------------------------------------------------
post Path::BLOG_PAST_ITEM + '/' do
	auth
	post = Post.filter(:slug => params[:slug]).first
	stop [404, "Page not found"] unless post
	post.title = params[:title]
	post.body = params[:body]
	post.save
	redirect post.url
end
