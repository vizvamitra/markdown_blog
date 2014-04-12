module PostsHelper

  def pubdate item
    return nil if item.created_at.nil?
    DateTime.parse(item.created_at.to_s).strftime('%d %b %Y, %H.%M')
  end

end
