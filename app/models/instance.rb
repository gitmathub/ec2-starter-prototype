require 'aws-sdk'

class Instance < ApplicationRecord

  validates :image_id, presence: true
  validates :instance_type, presence: true
  validates :region, presence: true
  validates :access_key_id, presence: true
  validates :secret_access_key, presence: true
  validates :key_name, presence: true

  def start 

    Aws.config.update({
      credentials: Aws::Credentials.new(access_key_id, secret_access_key)
    })

    client = Aws::EC2::Client.new(region: region)
    ec2 = Aws::EC2::Resource.new(client: client)

    # doc: http://docs.aws.amazon.com/sdkforruby/api/Aws/EC2/Resource.html
    instances = ec2.create_instances({
      image_id: image_id,
      instance_type: instance_type,
      min_count: 1,
      max_count: 1,
      key_name: key_name,
      security_groups:  [security_group]
    })

    # Wait for the instance to be created, running, and passed status checks
    self.instance_id = instances[0].id
    ec2.client.wait_until(:instance_running, {instance_ids: [instance_id]}) do |w|
      w.max_attempts = 5
      w.before_wait do |attempts, response|
        #puts response.data
        #puts response.error
        throw :failure if attempts >= w.max_attempts
      end
    end

    # buggy api. fetch instance again in order to get an updated object
    # id, ip and state won't be saved. missing feature: list and remove instances
    # doc http://docs.aws.amazon.com/sdkforruby/api/Aws/EC2/Instance.html
    newly_feched_instance = ec2.instance(instance_id)
    self.ip = newly_feched_instance.classic_address.public_ip
    self.state = newly_feched_instance.state.name


  end

end

