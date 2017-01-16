class ChangeCodeTypeFromSpreeBank < ActiveRecord::Migration
  def change
    change_column :spree_banks, :code, :string, :null => false
  end
end
