class Instance < ApplicationRecord
  validates :image_id, presence: true
  validates :instance_type, presence: true
  validates :region, presence: true
  validates :access_key_id, presence: true
  validates :secret_access_key, presence: true
end

