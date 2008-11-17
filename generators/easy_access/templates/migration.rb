class CreateRoles < ActiveRecord::Migration
  def self.up
    create_table "<%= table_name %>" do |t|
      t.string :name
      t.string :description

      t.timestamps
    end
    create_table "<%= table_name %>_users", :id => false do |t|
      t.column "<%= table_name.singularize %>_id", :integer, :null => false
      t.column "user_id", :integer, :null => false
    end
    add_index "<%= table_name %>_users", ["<%= table_name.singularize %>_id",:user_id]
  end

  def self.down
    drop_table "<%= table_name %>_users"
    drop_table "<%= table_name %>"
  end
end
