module ApplicationHelper
  def full_title(title = '')
    base = 'Rails Imageboard'
    if title.empty?
      base
    else
      "#{title} | #{base}"
    end
  end

  def debug_console(object = nil)
    return if object.nil? || object.empty?

    debug(object)
  end
end
