class AddFieldsToMediaFiles < ActiveRecord::Migration[6.0]

  def change

    add_column :media_files, :extra_data, :string
    add_column :media_files, :file_path, :string
    add_column :media_files, :name, :string

    change_column :media_files, :name, :string, null: false

  end

end
