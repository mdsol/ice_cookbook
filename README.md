Description
===========

Application cookbook for installing the Netflix Ice Amazon Web Services usage
and cost reporting application stack.

Requirements
============

Chef 11.4.0+ and Ohai 6.10+ for platform_family use.

This cookbook requires attributes be set based on the instructions for 
configuring the [Netflix Ice application](https://github.com/Netflix/ice).

You will also need to enable Amazon's programmatic billing access to 
receive detailed billing reports.

The following cookbooks are dependencies:

* apt (on ubuntu)
* openssl
* java
* tomcat
* nginx
* artifact (Riot Games)

## Platform:

Tested on 

* Ubuntu 12.04+
* Centos 6.4+

Attributes
==========

* `node['ice']['version']` - Ice version to download and install.  These 
versions are packaged and hosted by Medidata Solutions until we can get the 
Netflix Ice team to package and host the Ice official releases.
* `node['ice']['checksum']` - Checksum for Ice WAR file.
* `node['ice']['war_url']` - HTTP URL for Ice WAR file.
* `node['ice']['force_redeploy']` - Will force a redeploy of the Ice WAR file.
* `node['ice']['company_name']` - Organization name that is displayed in the 
UI header.
* `node['ice']['processor']['enabled']` - Enables the Ice processor.
* `node['ice']['processor']['local_dir']` - Local work directory for the Ice
processor.
* `node['ice']['billing_aws_access_key_id']` - AWS access key id used for
accessing AWS detailed billing files from S3.
* `node['ice']['billing_aws_secret_key']` - AWS secret key used for
accessing AWS detailed billing files from S3.
* `node['ice']['billing_s3_bucket_name']` - Name of the S3 bucket containing
the AWS detailed billing files.
* `node['ice']['billing_s3_bucket_prefix']` - Directory in the S3 billing bucket 
containing AWS detailed billing files.
* `node['ice']['work_s3_bucket_name']` - Name of the S3 bucket that Ice uses 
for processed AWS detailed billing files.  This bucket is shared between the Ice
processor and reader.
* `node['ice']['work_s3_bucket_prefix']` - Directory in the S3 work bucket 
containing the processed AWS detailed billing files.
* `node['ice']['reader']['enabled']` - Enables the Ice reader and installs the
Nginx reverse proxy.
* `node['ice']['reader']['local_dir']` - Local work directory for the Ice reader.
* `node['ice']['start_millis']` - Specify the start time in milliseconds for the 
processor to start processing billing files.
* `node['ice']['public_hostname']` - Optional. Fully qualified domain name used for 
configuring the Nginx reverse proxy on Ice readers/UI nodes.
* `node['ice']['accounts']` - Optional.  Hash mapping of AWS account names to 
account numbers.  This is used within Ice to give accounts human readable names 
in the UI.

## Usage

TODO: Add usage examples.

## Author

* Author: [Ray Rodriguez](https://github.com/rayrod2030)
