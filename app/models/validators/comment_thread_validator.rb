class CommentThreadValidator < ActiveModel::Validator
  def validate(record)
    record.errors.add(:sticky, 'must not be nil') if record.sticky.nil?
  end
end
