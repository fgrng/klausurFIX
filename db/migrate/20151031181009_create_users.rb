class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :email, null: false, index: true
      t.string :username, null: false, index: true
      t.string :password_digest, null: false

      t.boolean :valid_email, default: false
      t.string :valid_email_token
      t.datetime :valid_email_timestamp

      t.string :reset_password_token
      t.datetime :reset_password_timestamp

      t.timestamps null: false
    end
  end
end
