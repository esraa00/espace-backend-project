class PostPolicy < ApplicationPolicy
  class Scope < Scope

  end
  def update?
    @user.id.to_s == record.user_id.to_s
  end
end