## v0.2.14

### Improvement

- Updated documentation. [@rayrod2030]

## v0.2.13:

### Bug Fix

-  Fixed bug just having custom port number broke links on the site. [@akshah123]

## v0.2.12:

### Feature

- Added attribute and logic for processing and displaying custom resource tags.  [@rayrod2030]

## v0.2.11:

### Improvement

- Added attribute for configuring the nginx port.  [@akshah123]

- Upgraded the artifact cookbook to 1.9.0 to avoid issues with librarian.

## v0.2.10:

### Improvement

- Nginx site template configuration can now be completely customized by setting the 
nginx_config and nginx_config_cookbook attributes to point to a custom cookbook and
configuration template. [@rampire]

- Added the Ice IAM role attribute which is added to the system properties if an IAM
role is used for authentication.  If aws keys and secrets are used instead teh IAM
role defaults to 'ice' and is ignored by Ice.

- Updated README.

## v0.2.9:

### Improvement

- Upgraded the ice war version we default to from the default attributes file to 0.0.3. This 
build should include all updates to ice master on https://www.github.com/netflix/ice as of 
July 11, 2013 and commit: netflix/ice@9c11c8b 

## v0.2.8:

### Improvement

- Add Apache V2 license to cookbook

[@akshah123]: https://github.com/akshah123
[@rampire]: https://github.com/rampire
