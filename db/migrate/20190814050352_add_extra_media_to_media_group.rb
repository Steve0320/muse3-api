class AddExtraMediaToMediaGroup < ActiveRecord::Migration[6.0]

  def change

    # Use a serialized Hash to store fields unique to particular media types
    add_column :media_groups, :extra_data, :string

  end

end
