class PostsController < ApplicationController

  before_action :set_post, only: [:edit, :update, :destroy, :show]
  skip_before_filter :authorize, only: [:index, :show]

  PER_PAGE = 10

  # GET /posts
  def index
    # set page info, get filter and number of pages
    n_skip, filter = set_page_info({published: true})

    @posts = Post.where(filter).order_by([:created_at, :desc]).limit(PER_PAGE).skip(n_skip)

    @tags = Post.get_tags
  end

  # GET /posts/drafts
  def drafts
    n_skip, filter = set_page_info({author: session[:user_name], published: false})
    @posts = Post.where(filter).order_by([:created_at, :desc]).limit(PER_PAGE).skip(n_skip)
  end

  # GET /posts/:permalink
  def show
    @comment = Comment.new
    @comment.author = session[:user_name].capitalize if authorized?
  end

  # GET /posts/new
  def new
    @post = Post.new
  end

  # GET /posts/:permalink/edit
  def edit
    redirect_to posts_path unless is_author?(@post)
  end

  # POST /posts
  def create
    post_data = post_params
    @post = Post.new
    @post.attributes = {
      title: post_data[:title],
      body: post_data[:body],
      author: session[:user_name],
      tags: post_data[:tags].split(/\s*,\s*/).map!{|t|t.strip.mb_chars.downcase.to_s},
      permalink: make_permalink(post_data[:title])
    }
    @post.markdown = post_data[:markdown].to_i.zero? ? 0 : 1
    @post.published = post_data[:published].to_i.zero? ? false : true

    if @post.save
      redirect_to posts_path
    else
      render 'new'
    end
  end

  # PATCH /posts/:permalink
  def update
    redirect_to posts_path unless is_author?(@post)

    post_data = post_params
    @post.attributes = {
      title: post_data[:title],
      body: post_data[:body],
      tags: post_data[:tags].split(/\s*,\s*/).map{|t|t.strip.mb_chars.downcase.to_s},
      permalink: make_permalink(post_data[:title])
    }
    @post.markdown = post_data[:markdown].to_i.zero? ? 0 : 1
    @post.published = post_data[:published].to_i.zero? ? false : true

    if @post.save
      redirect_to posts_path
    else
      render 'edit'
    end
  end

  # DELETE /posts/:permalink
  def destroy
    redirect_to posts_path unless is_author?(@post)

    @post.destroy
    redirect_to posts_path
  end

  private

  def set_post
    permalink = params[:id] || params[:post][:permalink]
    @post = Post.find_by(permalink: permalink )
  end

  def post_params
    params.require(:post).permit(:title, :body, :tags, :markdown, :published)
  end

  # 'Превед медвеД!!!?' -> 'Preved_medveD!!!'
  def make_permalink(string = '')
    escaped_title = I18n.transliterate(string)
    escaped_title = escaped_title.gsub(/[^-\w\s!_]/,'').gsub(/\s/, '_')
    "#{Time.now.to_i}_#{escaped_title}"
  end

  def set_page_info(filter)
    tag = {}
    if params[:tag]
      filter.merge!({tags: params[:tag]})
      tag = {tag: params[:tag]}
    end

    num_pages = Post.num_pages(PER_PAGE, params[:tag])
    n_skip = 0
    page = params[:page].to_i
    redirect_to posts_path if (page > num_pages || page < 0)
    page = 1 if page.zero?
    @next_page = {page: page + 1}.merge(tag) if page < num_pages
    @prev_page = {page: page-1}.merge(tag) if page > 1
    n_skip = (page-1) * PER_PAGE
    [n_skip, filter]
  end

  def is_author?(post)
    session[:user_name] == post.author
  end

end
