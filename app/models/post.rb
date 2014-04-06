class Post
  include Mongoid::Document
  include Mongoid::Timestamps
  field :author, type: String
  field :title, type: String
  field :body, type: String
  field :tags, type: Array
  field :published, type: Mongoid::Boolean, default: false
  field :permalink, type: String

  validates_presence_of :title, :body, :permalink, :author
  validates_uniqueness_of :permalink

  embeds_many :comments, cascade_callbacks: true, validate: true
  belongs_to :user, primary_key: :name, foreign_key: :author

  def to_param
    self.permalink
  end
end