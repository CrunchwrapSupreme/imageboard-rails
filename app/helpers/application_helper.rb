module ApplicationHelper
  def full_title(title='')
    base = 'Rails Imageboard'
    if title.empty?
      base
    else
      "#{title} | #{base}"
    end
  end
end
