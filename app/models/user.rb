class User
  include Mongoid::Document
  include ActiveModel::SecurePassword
  field :name, type: String
  field :password_digest, type: String

  validates_presence_of :name, :password_digest

  has_many :posts, primary_key: :name, foreign_key: :author, dependent: :destroy
  has_secure_password

  def to_param
    self.name
  end
end
