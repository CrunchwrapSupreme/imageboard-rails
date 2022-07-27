class Comments::ThreadAuth
  include Interactor
  delegate :user, :thread, to: :context
  delegate :cannot?, :can?, to: :ability

  def call
    if thread.sticky? && cannot?(:sticky, thread)
      context.fail!(message: 'Not authorized to create sticky')
    end

    if thread.locked? && cannot?(:lock, thread)
      context.fail!(message: 'Not authorized to create locked thread')
    end
  end

  private

  def ability
    @ability ||= ::ThreadAbility.new(user)
  end
end
