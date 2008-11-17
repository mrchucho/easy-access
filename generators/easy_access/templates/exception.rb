<%- if namespace -%>
module <%= namespace %>
<%- end -%>
  module Exception
    class PermissionDenied < RuntimeError; end;
  end
<%- if namespace -%>
end
<%- end -%>
