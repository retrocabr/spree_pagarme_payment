class CreateSpreeBanks < ActiveRecord::Migration
  def change
    create_table :spree_banks do |t|
        t.string  :name, :null => false
        t.integer :code, :null => false
        t.boolean :bookmarked, :default => false
    end

    add_column :spree_withdrawal_infos, :bank_id, :integer
  end
end
