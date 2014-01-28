class CreateTwoFactorAuthTokens < ActiveRecord::Migration
  def change
    create_table :two_factor_auth_tokens do |t|
      t.belongs_to :user, null: false
      t.string :token, null: false
      t.datetime :expires_at, null: false

      t.timestamps
    end

    add_index :two_factor_auth_tokens, [:user_id, :token], unique: true
  end
end
