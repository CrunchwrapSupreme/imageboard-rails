class ApplicationDecorator < Draper::Decorator
  def creation_date
    model.created_at.to_formatted_s(:long)
  end
end
