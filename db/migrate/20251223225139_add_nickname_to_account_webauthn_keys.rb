class AddNicknameToAccountWebauthnKeys < ActiveRecord::Migration[8.1]
  def change
    add_column :account_webauthn_keys, :nickname, :string
  end
end
