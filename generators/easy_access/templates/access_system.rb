<%- if namespace -%>
module <%= namespace %>
<%- end -%>
  module AccessSystem
    def can_view?(resource)
      if resource.respond_to?(:can_be_viewed_by?) 
        resource.can_be_viewed_by?(self)
      else
        has_privilege_for?(resource, :view)
      end
    end

    def can_create?(resource)
      if resource.respond_to?(:can_be_created_by?) 
        resource.can_be_created_by?(self)
      else
        has_privilege_for?(resource, :create)
      end
    end

    def can_update?(resource)
      if resource.respond_to?(:can_be_updated_by?) 
        resource.can_be_updated_by?(self)
      else
        has_privilege_for?(resource, :update)
      end
    end

    def can_destroy?(resource)
      if resource.respond_to?(:can_be_destroyed_by?) 
        resource.can_be_destroyed_by?(self)
      else
        has_privilege_for?(resource, :destroy)
      end
    end

    protected 

    # TODO Customize default access controls.
    def has_privilege_for?(resource, action)
      case action
      when :view
        true
      when :create, :update, :destroy
        self.<%=association%>.any?{|r| r.name.eql?("Administrator")}
      else
        false
      end
    end
  end
<%- if namespace -%>
end
<%- end -%>
