# frozen_string_literal: true

# migration for adding confirmable to devise
class AddConfirmableToDevise < ActiveRecord::Migration[7.0]
  def change
    change_table :users do |t|
      ## Confirmable
      t.string   :confirmation_token
      t.datetime :confirmed_at
      t.datetime :confirmation_sent_at
      t.string   :unconfirmed_email
    end
  end
end
