require 'bundler/setup'
require 'sinatra/base'
require 'sinatra/partial'
require 'sass'
require 'haml'
require './helpers'

class App < Sinatra::Base

  register Sinatra::Partial
  helpers Helpers

  enable :sessions

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

  get '/css/:file.css' do
    halt 404 unless File.exist?("views/scss/#{params[:file]}.scss")
    time = File.stat("views/scss/#{params[:file]}.scss").ctime
    last_modified(time)
    scss params[:file].intern
  end

  get '/*' do
    @ember = App.production? ? "/js/vendor/ember-1.0.0-rc.1.min.js" : "/js/vendor/ember-1.0.0-rc.1.js"

    # array with combination of 
    # hash { :name => template-name, :partial => partial }
    # or string (template-name and partial)
    @handlebars = [
      'application', 'index', 'posts', 'posts/index',
    ]
    haml :app
  end

end
