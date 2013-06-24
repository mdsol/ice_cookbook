# Ice version
node.default['ice']['version']                              = '0.0.1'
node.default['ice']['checksum']                             = '4242700cb88d6b7ea4ed16d1725203ac7e32fdac89a9ac555a96a4b8bbb6946e'
node.default['ice']['war_url']                              = 'https://s3.amazonaws.com/ice-app'
node.default['ice']['force_redeploy']                       = false

node.default['ice']['company_name']                         = ''

node.default['ice']['processor']['enabled']                 = true
node.default['ice']['processor']['localDir']                = '/var/ice_processor'

# S3 keys for accessing billing files
node.default['ice']['billing_aws_access_key_id']            = ''
node.default['ice']['billing_aws_secret_access_key']        = ''

node.default['ice']['billing_s3_bucket_name']               = ''
node.default['ice']['billing_s3_bucket_prefix']             = ''

node.default['ice']['work_s3_bucket_name']                  = '' 
node.default['ice']['work_s3_bucket_prefix']                = ''

node.default['ice']['reader']['enabled']                    = true
node.default['ice']['reader']['localDir']                   = '/var/ice_reader'

node.default['ice']['start_millis']                          = 0

node.default['ice']['accounts']                             = {}

node.default['ice']['reservation_capacity_poller']          = false

# # reservation period, possible values are oneyear, threeyear
node.default['ice']['reservation_period']                   = 'threeyear' 
# # reservation utilization, possible values are LIGHT, HEAVY
node.default['ice']['reservationUtilization']               = 'HEAVY' 
