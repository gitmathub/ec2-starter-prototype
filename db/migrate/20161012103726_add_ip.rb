class AddIp < ActiveRecord::Migration[5.0]
  def change
    change_table(:instances) do |t|
      t.string :ip
    end
  end
end
