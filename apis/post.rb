require 'sinatra/base'
require 'haml'
require 'json'
require 'active_support/lazy_load_hooks'
require 'active_support/core_ext/string'

class App::Post < Sinatra::Base

  set(:xhr) { |xhr| condition { request.xhr? == xhr } }

  before :xhr => true do
    @posts ||= [
      { id: 1, title: 'Post 1', slug: 'post-1', content: '<p>Content of Post 1</p>', publish_date: '2013-01-01', is_published: true, excerpt: 'Excerpt 1' },
      { id: 2, title: 'Post 2', slug: 'post-2', content: '<p>Content of Post 2</p>', publish_date: '2023-01-02', is_published: true, excerpt: 'Excerpt 2' },
      { id: 3, title: 'Post 3', slug: 'post-3', content: '<p>Content of Post 3</p>', publish_date: '3033-01-03', is_published: false, excerpt: 'Excerpt 3' },
      { id: 4, title: 'Post 4', slug: 'post-4', content: '<p>Content of Post 4</p>', publish_date: '4044-01-04', is_published: true, excerpt: 'Excerpt 4' }
    ]
    @filtered_posts = @posts
  end

  get '/posts/:id', :xhr => true, :provides => :json do
    @filtered_posts.reject!{ |post| post[:id] != params[:id].to_i }
    @filtered_posts = @filtered_posts.empty? ? {} : @filtered_posts.pop()
    {
      'post' => @filtered_posts
    }.to_json
  end

  get '/posts', :xhr => true, :provides => :json do
    @filtered_posts = @posts
    unless params[:is_published].nil?
      @filtered_posts.reject!{ |post| post[:is_published] != !!params[:is_published] }
    end
    {
      'posts' => @filtered_posts
    }.to_json
  end

  post '/posts', :xhr => true, :provides => :json do
    params[:is_published] = !!params[:is_published]
    params[:publish_date] = Date.today.strftime('%Y-%m-d') if params[:is_published]
    params[:id] = @posts.count + 1
    params[:slug] = params[:title].downcase.dasherize
    @posts << params
  end

  put '/posts/:id', :xhr => true, :provides => :json do
    @posts.collect! do |post|
      if post[:id] == params[:id]
        params[:is_published] = !!params[:is_published]
        params[:publish_date] = Date.today.strftime('%Y-%m-d') if params[:is_published]
        params[:slug] = params[:title].downcase.dasherize
        post = params
      end
      post
    end
  end

  delete '/posts/:id', :xhr => true, :provides => :json do
    @posts.reject!{ |post| post[:id] == params[:id] }
  end

end
