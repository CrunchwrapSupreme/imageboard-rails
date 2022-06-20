class BoardDecorator < Draper::Decorator
  delegate_all

  # Define presentation-specific methods here. Helpers are accessed through
  # `helpers` (aka `h`). You can override attributes, for example:
  #
  #   def created_at
  #     helpers.content_tag :span, class: 'time' do
  #       object.created_at.strftime("%a %m/%d/%y")
  #     end
  #   end

  def slash_name
    "/#{CGI.escapeHTML(model.short_name)}/"
  end

  def form_method
    if model.new_record?
      'post'
    else
      'put'
    end
  end
end
