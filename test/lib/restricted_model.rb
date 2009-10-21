class RestrictedModel 
  attr_accessor :user, :state

  def initialize(user)
    self.user = user
  end

  def can_be_viewed_by?(user)
    user == self.user
  end

  def can_be_updated_by?(user)
    if self.state == :closed
      false
    else
      user == self.user
    end
  end

  def can_be_destroyed_by?(user)
    user.roles.any?{|r| r.name.eql?("Destroyer")}
  end
end

