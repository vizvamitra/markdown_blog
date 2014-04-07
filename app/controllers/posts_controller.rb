class PostsController < ApplicationController

  before_action :set_post, only: [:edit, :update, :destroy, :show]
  skip_before_filter :authorize, only: [:index, :show]

  PER_PAGE = 10

  # GET /posts
  def index
    num_pages = Post.num_pages(PER_PAGE)
    n_skip = 0
    if (page=params[:page].to_i) <= num_pages
      page = 1 if page.zero?
      @next_page = page + 1 if page < num_pages
      n_skip = (page-1) * PER_PAGE if page > 0
      @prev_page = page-1 if page > 1
    else
      redirect_to posts_path
    end
      
    filter = {tags: params[:tag]} if params[:tag]
    @posts = Post.where(filter).order_by([:created_at, :desc]).limit(PER_PAGE).skip(n_skip)
    @tags = get_tags.sort{|t1,t2| t1['_id'] <=> t2['_id']}
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
      tags: post_data[:tags].split(/\s*,\s*/).map!{|t|t.strip.mb_chars.downcase.to_s},
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
    post_data = post_params
    @post.attributes = {
      title: post_data[:title],
      body: post_data[:body],
      tags: post_data[:tags].split(/\s*,\s*/).map{|t|t.strip.mb_chars.downcase.to_s},
      permalink: make_permalink(post_data[:title])
    }

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

  def get_tags
    map = %Q{
      function(){
        this.tags.forEach(function(z){
          emit(z,1)
        })
      }
    }
    reduce = %Q{
      function (key,values){
        var total=0;
        for(var i=0;i<values.length;i++){
          total += values[i];
        };
        return total;
      }
    }
    Post.where(:tags.exists=>true).map_reduce(map,reduce).out(inline: true)
  end

end
