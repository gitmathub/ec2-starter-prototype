class CreateInstances < ActiveRecord::Migration[5.0]
  def change
    create_table :instances do |t|
      t.string :image_id
      t.string :instance_type
      t.string :region
      t.string :access_key_id
      t.string :secret_access_key
      t.string :linux_user
      t.string :linux_password

      t.timestamps
    end
  end
end
