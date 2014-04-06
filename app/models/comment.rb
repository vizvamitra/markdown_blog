class Comment
  include Mongoid::Document
  include Mongoid::Timestamps
  field :author, type: String
  field :email, type: String
  field :body, type: String

  validates_presence_of :author, :body

  username_regex = '[-\w!#$%&\'*+/=?^_`{|}~]+(\.[-\w!#$%&\'*+/=?^_`{|}~]+)*'
  domain_regex = '([\w]([-\w]{0,61}[\w])?\.)*[a-z]{2,4}'
  email_regex = Regexp.new("\\A(#{username_regex}@#{domain_regex})?\\z", 'i')
  validates_format_of :email, with: email_regex
 
  embedded_in :post
end
