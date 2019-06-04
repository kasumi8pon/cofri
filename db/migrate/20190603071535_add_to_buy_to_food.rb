# frozen_string_literal: true

class AddToBuyToFood < ActiveRecord::Migration[5.2]
  def change
    add_column :foods, :to_buy, :boolean, default: false
  end
end
