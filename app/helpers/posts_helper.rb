module PostsHelper

  def pubdate item
    return nil if item.created_at.nil?
    DateTime.parse(item.created_at.to_s).strftime('%d %b %Y, %H.%M')
  end

  def preview(post)
    text, more = post.get_preview
    if more
      more = "Читать далее.." if more.empty? 
      text << link_to(more, post_path(post))
    end

    text
  end

end
