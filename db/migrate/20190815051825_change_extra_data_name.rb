class ChangeExtraDataName < ActiveRecord::Migration[6.0]
  def change
    rename_column :media_files, :extra_data, :search_data
    rename_column :media_groups, :extra_data, :search_data
  end
end
