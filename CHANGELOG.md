# Terraform Module - DigitalOcean Records - Changelog

## 1.0.0 - August 2015

### Breaking changes

* Switching to new string interpolation method by removing deprecated 'concat()' which is now used for lists, not strings
    * This requires at least Terraform 6.0, older versions will not work with this module

### Improved

* It is now assumed an environment variable will be used to set variable values, rather than using a `.tfvars` file
* Now using DigitalOcean's preferred naming style (i.e. camel case)

## 0.1.0 - February 2015

* Initial version
