Ice Cookbook
============

This is an application cookbook for installing the Netflix Ice AWS usage and
cost reporting application.

Requirements
------------
- Chef 11 or higher
- Ruby 1.9.3 or higher
- This cookbook requires attributes be set based on the instructions for
configuring the [Netflix Ice application](https://github.com/Netflix/ice).
- You will also need to enable Amazon's programmatic billing access to
receive detailed billing reports.

Platform
--------
Tested on

* Ubuntu 14.04
* Ubuntu 12.04
* Centos 6.4

Other Debian and RHEL family distributions are assumed to work but YMMV.

Attributes
----------
In order to keep the README managable and in sync with the attributes, this
cookbook documents attributes inline. The usage instructions and default
values for attributes can be found in the individual attribute files.

Dependencies
------------

The following cookbooks are dependencies:

* [apt][]
* [yum][]
* [java][]
* [logrotate][]
* [chef-sugar][]
* [openssl][]
* [nginx][]
* [tomcat][]
* [artifact][]

## Usage

This recipe allows you to deploy Netflix Ice as a standalone node running both the
processor and reader or as seperate nodes running a processor and a reader which is the
deployment layout that the Netflix Ice team recommends.

Here is a sample role for creating an Ice processor node:
```YAML
chef_type:           role
default_attributes:
description:
env_run_lists:
json_class:          Chef::Role
name:                ice-processor
override_attributes:
  ice:
    billing_aws_access_key_id:     YOURAWSKEYID
    billing_aws_secret_key:        YOURAWSSECRETKEY
    billing_s3_bucket_name:        ice-billing
    version:                       0.0.4
    war_url:                       https://s3.amazonaws.com/dl.imedidata.net/ice
    checksum:                      eb9e7503585553bdebf9d93016bcbe7dc033c21e2b1b2f0df0978ca2968df047
    skip_manifest_check:           false
    company_name:                  Company Name
    force_deploy:                  false
    processor:
      enabled: true
    reader:
      enabled: false
    start_millis:                  1357016400000
    work_s3_bucket_name:           ice-work
  tomcat:
    catalina_options: -Xmx1024M -Xms1024M
run_list:
  recipe[ice]
```

Here is a sample role for creating an Ice reader node:
```YAML
chef_type:           role
default_attributes:
description:
env_run_lists:
json_class:          Chef::Role
name:                ice-reader
override_attributes:
  ice:
    billing_aws_access_key_id:     YOURAWSKEYID
    billing_aws_secret_key:        YOURAWSSECRETKEY
    billing_s3_bucket_name:        ice-billing
    version:                       0.0.4
    war_url:                       https://s3.amazonaws.com/dl.imedidata.net/ice
    checksum:                      eb9e7503585553bdebf9d93016bcbe7dc033c21e2b1b2f0df0978ca2968df047
    skip_manifest_check:           false
    company_name:                  Company Name
    force_deploy:                  false
    processor:
      enabled: false
    reader:
      enabled: true
    start_millis:                  1357016400000
    work_s3_bucket_name:           ice-work
  tomcat:
    catalina_options: -Xmx1024M -Xms1024M
run_list:
  recipe[ice]
```

Development
-----------
Please see the [Contributing](CONTRIBUTING.md) and [Issue Reporting](ISSUES.md) Guidelines.

License & Authors
-----------------
- Author: [Ray Rodriguez](https://github.com/rayrod2030) (rayrod2030@gmail.com)
- Contributor: [akshah123](https://github.com/akshah123)
- Contributor: [Benton Roberts](https://github.com/benton)
- Contributor: [Harry Wilkinson](https://github.com/harryw)
- Contributor: [rampire](https://github.com/rampire)
- Contributor: [Alex Greg](https://github.com/agreg)

```text
Copyright 2015 Medidata Solutions Worldwide

Licensed under the Apache License, Version 2.0 (the “License”);
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an “AS IS” BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```

[apt]: https://github.com/opscode-cookbooks/apt
[yum]: https://github.com/chef-cookbooks/yum
[java]: https://github.com/agileorbit-cookbooks/java
[logrotate]: https://github.com/stevendanna/logrotate
[chef-sugar]: https://github.com/sethvargo/chef-sugar
[openssl]: https://github.com/opscode-cookbooks/openssl
[nginx]: https://github.com/miketheman/nginx
[tomcat]: https://github.com/opscode-cookbooks/tomcat
[artifact]: https://github.com/RiotGamesCookbooks/artifact-cookbook
