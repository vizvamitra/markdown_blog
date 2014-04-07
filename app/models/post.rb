class Post
  include Mongoid::Document
  include Mongoid::Timestamps
  field :author, type: String
  field :title, type: String
  field :body, type: String
  field :tags, type: Array, default: []
  field :published, type: Mongoid::Boolean, default: false
  field :permalink, type: String

  validates_presence_of :title, :body, :permalink, :author
  validates_uniqueness_of :permalink

  embeds_many :comments, cascade_callbacks: true, validate: true
  belongs_to :user, primary_key: :name, foreign_key: :author

  def to_param
    self.permalink
  end

  def self.num_pages(per_page)
    raise ArgumentError, '1 post per page minimum' if per_page < 1
    pages = self.count.to_f/per_page.to_i
    pages > pages.to_i ? pages.to_i + 1 : pages.to_i
  end
end