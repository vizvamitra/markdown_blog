class Post
  include Mongoid::Document
  include Mongoid::Timestamps
  field :author, type: String
  field :title, type: String
  field :body, type: String
  field :tags, type: Array, default: []
  field :published, type: Mongoid::Boolean, default: false
  field :markdown, type: Integer, default: 0
  field :permalink, type: String

  validates_presence_of :title, :body, :permalink, :author
  validates_uniqueness_of :permalink

  embeds_many :comments, cascade_callbacks: true, validate: true
  belongs_to :user, primary_key: :name, foreign_key: :author

  def to_param
    self.permalink
  end

  def get_body(**attrs)
    text = prepare(self.body)
    text.sub(/\s*\[more\].*\[\/more\]\s*/, '') if  attrs[:strip_more]
  end

  def get_preview
    regex = /(.*)\[more\](.*)\[\/more\]/m
    match = regex.match(self.body)
    preview, more = match ? [match[1], match[2]] : [self.body, nil]
    p preview

    [ prepare(preview), more ]
  end

  def self.num_pages(per_page, tag=nil)
    raise ArgumentError, '1 post per page minimum' if per_page < 1
    filter = {tags: tag} if tag
    pages = self.where(filter).count.to_f/per_page.to_i
    pages > pages.to_i ? pages.to_i + 1 : pages.to_i
  end

  def self.get_tags
    map = %Q{
      function(){
        this.tags.forEach(function(z){          
          emit(z,1);
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
    tags = self.where(:tags.exists=>true, published: true).map_reduce(map,reduce).out(inline: true)
    tags.sort{|t1,t2| t1['_id'] <=> t2['_id']}
  end

  private

  def prepare str
    self.markdown.to_i.zero? ? str.gsub(/\n/,'<br/>') : RDiscount.new(str).to_html
  end
end