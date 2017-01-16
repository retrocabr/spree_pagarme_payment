class CreateSpreeWithdrawalInfos < ActiveRecord::Migration
  def change
    create_table :spree_withdrawal_infos do |t|
      t.integer :bag_id
      t.string  :banco
      t.string  :agencia
      t.string  :conta
      t.string  :cpf
      t.string  :nome
      t.string  :obs
      t.decimal :amount, :precision => 8, :scale => 2
      t.timestamps
    end
  end
end

