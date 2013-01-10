class RemoveWhenFromItem < ActiveRecord::Migration
  def up
    remove_column :items, :when
  end

  def down
    add_column :items, :when, :datetime
  end
end
