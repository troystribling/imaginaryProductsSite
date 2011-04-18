##########################################################################################################
$:.unshift(File.dirname(__FILE__))
require 'rubygems'
require 'sinatra'
require 'sequel'
require 'maruku'
require 'syntax/convertors/html'

##########################################################################################################
module SiteConfigure
  
  ####----------------------------------------------------------------------------------------------------
  class << self
    
    #-----------------------------------------------------------------------------------------------------
    def site_db
      @site_db ||= Sequel.connect(ENV['DATABASE_URL'] || 'sqlite://site.db')
    end
    
  #### self  
  end
  
  #-------------------------------------------------------------------------------------------------------
  unless self.site_db.table_exists? :posts
		self.site_db.create_table :posts do
			primary_key :id
			text :title
			text :body
			text :slug
			text :tags
			timestamp :created_at
		end
	end
	
#### SiteConfigure  
end

##########################################################################################################
configure do
	require 'ostruct'
	Blog = OpenStruct.new(
		:title => 'a scanty blog',
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
$LOAD_PATH.unshift(File.dirname(__FILE__) + '/lib')
require 'post'

#---------------------------------------------------------------------------------------------------------
helpers do
	def admin?
		request.cookies[Blog.admin_cookie_key] == Blog.admin_cookie_value
	end
	def auth
		stop [ 401, 'Not authorized' ] unless admin?
	end
end

#---------------------------------------------------------------------------------------------------------
layout 'layout'

#---------------------------------------------------------------------------------------------------------
# company
#---------------------------------------------------------------------------------------------------------

#---------------------------------------------------------------------------------------------------------
# product
#---------------------------------------------------------------------------------------------------------

#---------------------------------------------------------------------------------------------------------
# blog
#---------------------------------------------------------------------------------------------------------
get '/' do
	posts = Post.reverse_order(:created_at).limit(10)
	erb :index, :locals => { :posts => posts }, :layout => false
end

#---------------------------------------------------------------------------------------------------------
get '/past/:year/:month/:day/:slug/' do
	post = Post.filter(:slug => params[:slug]).first
	stop [ 404, "Page not found" ] unless post
	@title = post.title
	erb :post, :locals => { :post => post }
end

#---------------------------------------------------------------------------------------------------------
get '/past/:year/:month/:day/:slug' do
	redirect "/past/#{params[:year]}/#{params[:month]}/#{params[:day]}/#{params[:slug]}/", 301
end

#---------------------------------------------------------------------------------------------------------
get '/past' do
	posts = Post.reverse_order(:created_at)
	@title = "Archive"
	erb :archive, :locals => { :posts => posts }
end

#---------------------------------------------------------------------------------------------------------
get '/past/tags/:tag' do
	tag = params[:tag]
	posts = Post.filter(:tags.like("%#{tag}%")).reverse_order(:created_at).limit(30)
	@title = "Posts tagged #{tag}"
	erb :tagged, :locals => { :posts => posts, :tag => tag }
end

#---------------------------------------------------------------------------------------------------------
get '/feed' do
	@posts = Post.reverse_order(:created_at).limit(20)
	content_type 'application/atom+xml', :charset => 'utf-8'
	builder :feed
end

#---------------------------------------------------------------------------------------------------------
get '/rss' do
	redirect '/feed', 301
end

#---------------------------------------------------------------------------------------------------------
# admin
#---------------------------------------------------------------------------------------------------------
get '/auth' do
	erb :auth
end

#---------------------------------------------------------------------------------------------------------
post '/auth' do
	response.set_cookie(Blog.admin_cookie_key, :value => Blog.admin_cookie_value) if params[:password] == Blog.admin_password
	redirect '/'
end

#---------------------------------------------------------------------------------------------------------
get '/posts/new' do
	auth
	erb :edit, :locals => { :post => Post.new, :url => '/posts' }
end

#---------------------------------------------------------------------------------------------------------
post '/posts' do
	auth
	post = Post.new :title => params[:title], :tags => params[:tags], :body => params[:body], 
	  :created_at => Time.now, :slug => Post.make_slug(params[:title])
	post.save
	redirect post.url
end

#---------------------------------------------------------------------------------------------------------
get '/past/:year/:month/:day/:slug/edit' do
	auth
	post = Post.filter(:slug => params[:slug]).first
	stop [ 404, "Page not found" ] unless post
	erb :edit, :locals => { :post => post, :url => post.url }
end

#---------------------------------------------------------------------------------------------------------
post '/past/:year/:month/:day/:slug/' do
	auth
	post = Post.filter(:slug => params[:slug]).first
	stop [ 404, "Page not found" ] unless post
	post.title = params[:title]
	post.tags = params[:tags]
	post.body = params[:body]
	post.save
	redirect post.url
end
