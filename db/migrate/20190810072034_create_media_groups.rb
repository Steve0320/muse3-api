class CreateMediaGroups < ActiveRecord::Migration[6.0]
  def change
    create_table :media_groups do |t|
      t.timestamps
    end
  end
end
