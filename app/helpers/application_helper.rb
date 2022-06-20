module ApplicationHelper
  def full_title(title = '')
    base = 'Rails Imageboard'
    if title.empty?
      base
    else
      CGI.escapeHTML("#{title} | #{base}")
    end
  end

  def debug_console(object = nil)
    return if object.nil? || object.empty?

    debug(object)
  end

  def min_role?(role)
    !!current_user&.min_role?(role)
  end
end
