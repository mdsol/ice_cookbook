# Ice version to download and install.  These versions are packaged and hosted
# by Medidata Solutions until we can get the Netflix Ice team to package and
# host official ice releases.  If you wish to install the latest stable version
# from [Netflix](https://github.com/netflix/ice#download-snapshot-builds)
# directly, provide `stable`. Note: this option will always install the latest
# version even if its not backwards compatible.
node.default['ice']['version']                              = '0.0.4'

# Checksum for Ice WAR file.
node.default['ice']['checksum']                             = 'eb9e7503585553bdebf9d93016bcbe7dc033c21e2b1b2f0df0978ca2968df047'

# HTTP URL for Ice WAR file.
node.default['ice']['war_url']                              = 'https://s3.amazonaws.com/dl.imedidata.net/ice'

# Will force a redeploy of the Ice WAR file.
node.default['ice']['force_redeploy']                       = false

# Organization name that is displayed in the UI header.
node.default['ice']['company_name']                         = nil

# Enables the ice processor.
node.default['ice']['processor']['enabled']                 = true

# Local work directory for the Ice processor.
node.default['ice']['processor']['local_dir']               = '/var/ice_processor'

# Optional. Work around https://github.com/Netflix/ice/issues/100 by pre-creating
# the directories it expects to find. Default: false
node.default['ice']['processor']['issue_100_workaround']    = false

# AWS access key id used for accessing AWS detailed billing files from S3.
node.default['ice']['billing_aws_access_key_id']            = nil

# AWS secret key used for accessing AWS detailed billing files from S3.
node.default['ice']['billing_aws_secret_key']               = nil

# Name of the S3 bucket containing the AWS detailed billing files.
node.default['ice']['billing_s3_bucket_name']               = nil

# Directory in the S3 billing bucket containing AWS detailed billing files.
node.default['ice']['billing_s3_bucket_prefix']             = nil

# Specify your payer account id here if across-accounts IAM role access is used.
# See Netflix Ice README section 1.6 for more details.
node.default['ice']['billing_payerAccountId']               = nil

# Specify your access IAM role name here if across-accounts IAM role access is used.
# See Netflix Ice README section 1.6 for more details.
node.default['ice']['billing_accessRoleName']               = nil

# Specify external id here if it is used.  See Netflix Ice README section 1.6
# for more details.
node.default['ice']['billing_accessExternalId']             = nil

# Name of the S3 bucket that Ice uses for processed AWS detailed billing files.
# This bucket is shared between the Ice processor and reader.
node.default['ice']['work_s3_bucket_name']                  = nil

# Directory in the S3 work bucket containing the processed AWS detailed billing files.
node.default['ice']['work_s3_bucket_prefix']                = nil

# Enables the Ice reader and installs the Nginx reverse proxy.
node.default['ice']['reader']['enabled']                    = true
# Local work directory for the Ice reader.
node.default['ice']['reader']['local_dir']                  = '/var/ice_reader'

# Specify the start time in milliseconds for the processor to start processing billing files.
# Value is number of milliseconds since unix epoch time.  Default: 90 days ago
node.default['ice']['start_millis']                         = (Date.today - 90).strftime('%Q')

# Optional.  Hash mapping of AWS account names to account numbers.  This is used
# within Ice to give accounts human readable names in the UI.
node.default['ice']['accounts']                             = {}

# To use BasicReservationService, you should also run reservation capacity
# poller, which will call EC2 API (describeReservedInstances) to poll
# reservation capacities for each reservation owner account defined in
# ice.properties.  See Netflix Ice README Advanced Options section 2.
node.default['ice']['reservation_capacity_poller']          = false

# Reservation period, possible values are oneyear, threeyear
node.default['ice']['reservation_period']                   = 'threeyear'

# Reservation utilization, possible values are LIGHT, MEDIUM, HEAVY, FIXED
node.default['ice']['reservation_utilization']              = 'HEAVY'

# Array of custom resource tags to have ice process.  As described in the ice
# README you must explicitly enable these custom tags in your billing statements.
node.default['ice']['custom_resource_tags']                 = []

# Currency sign to use in place of $
node.default['ice']['currencySign']                         = nil

# Conversion rate of USD to the above currency. For example, if 1 pound = 1.5
# dollar, then the rate is 0.6666667.
node.default['ice']['currencyRate']                         = nil

# URL to highstock.js if you need to serve this over HTTPS (which the default
# Highstock CDN does not currently support)
node.default['ice']['highstockUrl']                         = nil

# Monthly cache size.
node.default['ice']['monthlycachesize']                     = nil

# Cost per monitor metric per hour.
node.default['ice']['cost_per_monitormetric_per_hour']      = nil

# URL of Ice installation, used to create links in alert emails.
node.default['ice']['urlPrefix']                            = nil

# Email address from which Ice email alerts are sent (must be registered in SES).
node.default['ice']['fromEmail']                            = nil

# EC2 On-Demand hourly cost threshold at which an alert email should be sent.
node.default['ice']['ondemandCostAlertThreshold']           = nil

# Comma-separated list of recipients for the On-Demand cost alert emails.
node.default['ice']['ondemandCostAlertEmails']              = nil

# If set to `original`, Ice will use the original costs from the billing file
# for Resource Groups.
node.default['ice']['resourceGroupCost']                    = nil

# Set to `true` to enable weekly cost emails.
node.default['ice']['weeklyCostEmails']                     = nil

# Email address from which weekly cost emails are sent (must be registered in SES).
node.default['ice']['weeklyCostEmails_fromEmail']           = nil

# Email address to which weekly cost emails will be BCCed.
node.default['ice']['weeklyCostEmails_bccEmail']            = nil

# How many weeks to include in the weekly cost emails.
node.default['ice']['weeklyCostEmails_numWeeks']            = nil

# Optional. Fully qualified domain name used for configuring the Nginx reverse
# proxy on Ice readers/UI nodes.
node.default['ice']['public_hostname']                      = nil

# Nginx port configuration.
node.default['ice']['nginx_port']                           = 80

# Nginx site configuration chef template name.
node.default['ice']['nginx_config']                         = 'nginx_ice_site.erb'

# Nginx custom configuration cookbook.  Use this if you'd like to bypass the
# default ice cookbook nginx configuration and implement your own templates
# and recipes to configure Nginx for ice.
node.default['ice']['nginx_config_cookbook']                = 'ice'

# Whether nginx should route all requests to Tomcat, regardless of Host: header.  Default: false.
node.default['ice']['nginx_default_server']                 = false

# How often to rotate catalina.out.
node.default['ice']['logrotate_frequency']                  = 'weekly'

# How many rotated copies of catalina.out to keep.
node.default['ice']['logrotate_rotate']                     = 52
