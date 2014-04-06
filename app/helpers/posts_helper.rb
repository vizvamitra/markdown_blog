module PostsHelper

  def pubdate item
    DateTime.parse(item.created_at.to_s).strftime('%d %b %Y, %H.%M')
  end

end
