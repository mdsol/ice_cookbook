# Ice version
node.default['ice']['version']                              = '0.0.2'
node.default['ice']['checksum']                             = 'c5f0c31d8493783814c017a2af575e8d8fa1855359008b868621823381d61d6a'
node.default['ice']['war_url']                              = 'https://s3.amazonaws.com/ice-app'
node.default['ice']['force_redeploy']                       = false

node.default['ice']['company_name']                         = nil

node.default['ice']['processor']['enabled']                 = true
node.default['ice']['processor']['local_dir']                = '/var/ice_processor'

# S3 keys for accessing billing files
node.default['ice']['billing_aws_access_key_id']            = nil
node.default['ice']['billing_aws_secret_key']               = nil

node.default['ice']['billing_s3_bucket_name']               = nil
node.default['ice']['billing_s3_bucket_prefix']             = nil

node.default['ice']['work_s3_bucket_name']                  = nil
node.default['ice']['work_s3_bucket_prefix']                = nil

node.default['ice']['reader']['enabled']                    = true
node.default['ice']['reader']['local_dir']                   = '/var/ice_reader'

node.default['ice']['start_millis']                          = 0

node.default['ice']['accounts']                             = {}

node.default['ice']['reservation_capacity_poller']          = false

# # reservation period, possible values are oneyear, threeyear
node.default['ice']['reservation_period']                   = 'threeyear' 
# # reservation utilization, possible values are LIGHT, HEAVY
node.default['ice']['reservation_utilization']               = 'HEAVY'

# This hostname is used for the nginx reverse proxy configuration
node.default['ice']['public_hostname']                      = nil
