# frozen_string_literal: true

class CreateInvitations < ActiveRecord::Migration[5.2]
  def change
    create_table :invitations do |t|
      t.string :invitation_digest
      t.boolean :sign_up, default: false
      t.references :user_group, foreign_key: true

      t.timestamps
    end
  end
end
