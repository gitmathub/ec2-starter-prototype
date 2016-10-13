class AddKeynameSecgroupRmLinuxuserPass < ActiveRecord::Migration[5.0]
  def change
    change_table(:instances) do |t|
      t.remove :linux_user
      t.remove :linux_password
      t.string :key_name
      t.string :security_group
    end
  end
end
