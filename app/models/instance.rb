require 'aws-sdk'

class Instance < ApplicationRecord

  validates :image_id, presence: true
  validates :instance_type, presence: true
  validates :region, presence: true
  validates :access_key_id, presence: true
  validates :secret_access_key, presence: true

  def start 
    logger.debug "values: #{image_id} #{instance_type} #{region} #{access_key_id} #{secret_access_key}"

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
      key_name: 'ec2-admin-uswest2',
      security_groups:  ['launch-wizard-2']
    })

    # Wait for the instance to be created, running, and passed status checks
    id = self.instance_id = instances[0].id
    ec2.client.wait_until(:instance_running, {instance_ids: [id]}) do |w|
      w.max_attempts = 5
      w.before_wait do |attempts, response|
        #puts response.data
        #puts response.error
        throw :failure if attempts >= w.max_attempts
      end
    end

    # buggy api. fetch instance again in order to get an updated object
    # doc http://docs.aws.amazon.com/sdkforruby/api/Aws/EC2/Instance.html
    newly_feched_instance = ec2.instance(id)
    self.ip = newly_feched_instance.classic_address.public_ip
    self.state = newly_feched_instance.state.name

    # create user on lauchned instance
    # this won't work because the process does not own the pem file
    #logger.debug "ssh ec2-user@#{self.ip}..."
    #  puts `ssh ec2-user@#{self.ip} -i /home/pi/dev/aws/ec2-admin-uswest2.pem -vv "sudo adduser #{linux_user} -p #{linux_password}"`

  end

end

