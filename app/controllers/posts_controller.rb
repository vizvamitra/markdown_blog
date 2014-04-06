class PostsController < ApplicationController

  before_action :set_post, only: [:edit, :update, :destroy, :show]
  skip_before_filter :authorize, only: [:index, :show]

  # GET /posts
  def index
    filter = {tags: params[:tag]} if params[:tag]
    @posts = Post.where(filter).order_by([:created_at, :desc]).limit(10)
  end

  # GET /posts/:permalink
  def show
  end

  # GET /posts/new
  def new
    @post = Post.new
  end

  # GET /posts/:permalink/edit
  def edit
  end

  # POST /posts
  def create
    post_data = post_params
    @post = Post.new
    @post.attributes = {
      title: post_data[:title],
      body: post_data[:body],
      author: session[:user_name],
      tags: post_data[:tags].split(/\s*,\s*/),
      permalink: make_permalink(post_data[:title])
    }

    if @post.save
      redirect_to posts_path
    else
      render 'new'
    end
  end

  # PATCH /posts/:permalink
  def update
    title = post_params
    @post.attributes = post_params

    if @post.save
      redirect_to posts_path
    else
      render 'edit'
    end
  end

  # DELETE /posts/:permalink
  def destroy
    @post.destroy
    redirect_to posts_path
  end

  private

  def set_post
    @post = Post.find_by(permalink: params[:id] || params[:post][:permalink] )
  end

  def post_params
    params.require(:post).permit(:title, :body, :tags)
  end

  # 'Превед медвеД!!!?' -> 'Preved_medveD!!!'
  def make_permalink(string = '')
    escaped_title = I18n.transliterate(string)
    escaped_title = escaped_title.gsub(/[^-\w\s!_]/,'').gsub(/\s/, '_')
    "#{Time.now.to_i}_#{escaped_title}"
  end
end
