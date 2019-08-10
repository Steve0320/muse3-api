class CreateMediaFiles < ActiveRecord::Migration[6.0]
  def change
    create_table :media_files do |t|
      t.belongs_to :media_group, index: true
      t.timestamps
    end
  end
end
