class AddFieldsToMediaGroup < ActiveRecord::Migration[6.0]

  def up

    # Add necessary columns
    add_column :media_groups, :name, :string
    add_column :media_groups, :description, :string
    add_column :media_groups, :poster_url, :string
    add_column :media_groups, :rating, :integer
    add_column :media_groups, :from_searcher, :string
    add_column :media_groups, :searcher_key, :string

    # Somewhat filthy hack to get around SQLite's iffy design with nulls, see
    # https://stackoverflow.com/questions/3170634/how-to-solve-cannot-add-a-not-null-column-with-default-value-null-in-sqlite3
    change_column :media_groups, :name, :string, null: false
    change_column :media_groups, :from_searcher, :string, null: false
    change_column :media_groups, :searcher_key, :string, null: false

  end

  def down
    remove_column :media_groups, :name
    remove_column :media_groups, :description
    remove_column :media_groups, :poster_url
    remove_column :media_groups, :rating
    remove_column :media_groups, :from_searcher
    remove_column :media_groups, :searcher_key
  end

end
