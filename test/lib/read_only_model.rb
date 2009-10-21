class ReadOnlyModel 
  def can_be_viewed_by?(user); true; end
  def can_be_destroyed_by?(user); false; end
  def can_be_created_by?(user); false; end
  def can_be_updated_by?(user); false; end
end

