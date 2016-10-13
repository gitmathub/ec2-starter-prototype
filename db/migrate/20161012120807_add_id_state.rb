class AddIdState < ActiveRecord::Migration[5.0]
  def change
    change_table(:instances) do |t|
      t.string :instance_id
      t.string :state
    end
  end
end
