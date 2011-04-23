##########################################################################################################
$:.unshift(File.dirname(__FILE__))
require 'rubygems'
require 'sinatra'
require 'sinatra/content_for'
require 'sequel'
require 'maruku'
require 'syntax/convertors/html'
require 'post'

##########################################################################################################
class Path
  BLOG = '/blog'  
end

##########################################################################################################
configure do
	require 'ostruct'
	Blog = OpenStruct.new(
		:title => 'imaginaryProducts',
		:author => 'imaginaryProducts',
		:url_base => 'http://imaginaryProducts.com/',
		:admin_password => 'bigGameLLC',
		:admin_cookie_key => 'ip_admin',
		:admin_cookie_value => 'lweiueqi828383722289jjkahw31122',
		:disqus_shortname => 'imaginaryProductsOfficialBlog'
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
# blog
#---------------------------------------------------------------------------------------------------------
get '/blog' do
	posts = Post.reverse_order(:created_at).limit(10)
	erb :blog, :locals => { :posts => posts }, :layout => false
end

#---------------------------------------------------------------------------------------------------------
get '/blog/past/:year/:month/:day/:slug/' do
	post = Post.filter(:slug => params[:slug]).first
	stop [404, "Page not found"] unless post
	@title = post.title
	erb :post, :locals => {:post => post}, :layout => :layout
end

#---------------------------------------------------------------------------------------------------------
get '/blog/past/:year/:month/:day/:slug' do
	redirect "/blog/past/#{params[:year]}/#{params[:month]}/#{params[:day]}/#{params[:slug]}/", 301
end

#---------------------------------------------------------------------------------------------------------
get '/blog/past' do
	posts = Post.reverse_order(:created_at)
	@title = "Archive"
	erb :archive, :locals => { :posts => posts }, :layout => :layout
end

#---------------------------------------------------------------------------------------------------------
get '/blog/feed' do
	@posts = Post.reverse_order(:created_at).limit(20)
	content_type 'application/atom+xml', :charset => 'utf-8'
	builder :feed
end

#---------------------------------------------------------------------------------------------------------
get '/blog/rss' do
	redirect '/feed', 301
end

#---------------------------------------------------------------------------------------------------------
# admin
#---------------------------------------------------------------------------------------------------------
get '/blog/auth' do
	erb :auth, :layout => :layout
end

#---------------------------------------------------------------------------------------------------------
post '/blog/auth' do
	response.set_cookie(Blog.admin_cookie_key, :value => Blog.admin_cookie_value) if params[:password] == Blog.admin_password
	redirect '/blog'
end

#---------------------------------------------------------------------------------------------------------
get '/blog/posts/new' do
	auth
	erb :new, :locals => {:post => Post.new, :url => '/blog/posts'}, :layout => :layout
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
	erb :edit, :locals => {:post => post, :url => post.url}, :layout => :layout
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
