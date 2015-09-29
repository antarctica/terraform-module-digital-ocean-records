# Terraform Module - DigitalOcean Records - Changelog

## 2.0.0 - September 2015

### Changed

* Updating module with respect to WSR-1, which sets new defaults for DNS domain and interface labels
* BAS URL listed in license file updated to new BAS canonical URL

### Removed

* [BREAKING!] As all services should now sit behind a load balancer, the default interface DNS record will no longer be 
created

## 1.0.2 - August 2015

### Fixed

* Incorrect source links in example

## 1.0.1 - August 2015

### Fixed

* Incorrect example given for setting DigitalOcean provider. Used static value instead of variable
    * Note: This is purely a documentation problem, nothing has changed within this module

## 1.0.0 - August 2015

### Breaking changes

* Switching to new string interpolation method by removing deprecated 'concat()' which is now used for lists, not strings
    * This requires at least Terraform 6.0, older versions will not work with this module

### Improved

* It is now assumed an environment variable will be used to set variable values, rather than using a `.tfvars` file
* Now using DigitalOcean's preferred naming style (i.e. camel case)

## 0.1.0 - February 2015

* Initial version
