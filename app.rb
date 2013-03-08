require 'bundler/setup'
require 'sinatra/base'
require 'sinatra/partial'
require 'sass'
require 'haml'
require 'active_support/lazy_load_hooks'
require 'active_support/core_ext/string'
require './helpers'

class App < Sinatra::Base

  register Sinatra::Partial
  helpers Helpers

  enable :sessions, :static

  set :views, :scss => 'views/scss', :default => 'views'
  set :scss, :style => :compressed, :debug_info => false
  set :haml, :format => :html5, :escape_html => false

  configure :development do
    enable :dump_errors, :logging
  end

  configure :production do
    disable :dump_errors, :logging
    set :bind, '0.0.0.0'
    set :port, 80
  end

  Dir[File.dirname(__FILE__) + '/apis/*.rb'].each do |file| 
    file_class = 'app/' + File.basename(file, File.extname(file))
    require file
    use file_class.classify.constantize
  end

  get '/css/:file.css' do
    halt 404 unless File.exist?("views/scss/#{params[:file]}.scss")
    time = File.stat("views/scss/#{params[:file]}.scss").ctime
    last_modified(time)
    scss params[:file].intern
  end

  get '/*' do
    @ember = App.production? ? "/js/vendor/ember-1.0.0-rc.1.min.js" : "/js/vendor/ember-1.0.0-rc.1.js"
    @ember_data = App.production? ? "/js/vendor/ember-data.prod.js" : "/js/vendor/ember-data.js"

    # array with combination of 
    # hash { :name => template-name, :partial => partial }
    # or string (template-name and partial)
    @handlebars = [
      'application', 'index', 'posts', 'posts/index', 'posts/post', 'posts/new'
    ]
    haml :app
  end

end
