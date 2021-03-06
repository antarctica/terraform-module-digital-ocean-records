# Terraform Module - DigitalOcean Records

Specifies an opinionated set of DigitalOcean DNS Record resources for a DigitalOcean 'Droplet'.

## Overview

The public and private network interfaces for a DigitalOcean VM will be created as "namespaced" `A` records.

For example, a VM with a host name: `menagerie-prod-node1` this module would create 2 DNS records:

| Type      | Name                       | Value           | FQDN                                             | Notes                       |
| --------- | -------------------------- | --------------- | ------------------------------------------------ | --------------------------- |
| **A**     | `menagerie-prod-node1.int` | `10.131.190.89` | `menagerie-prod-node1.int.do.net.nerc-bas.ac.uk` | The VM's private IP address |
| **A**     | `menagerie-prod-node1.ext` | `178.62.124.75` | `menagerie-prod-node1.ext.do.net.nerc-bas.ac.uk` | The VM's public IP address  |

## Availability

This module is designed for internal use but if useful can be shared publicly.

## Usage

### Requirements

#### Minimum version

This module uses the string interpolation method introduced in Terraform 6.0.
Older versions will **not work** with this module.

#### DigitalOcean access token

Somewhere in your project you must have specified an access token for the DigitalOcean provider like this:

```ruby
# Define variables

variable "digital_ocean_token" {}  # Define using environment variable - e.g. TF_VAR_digital_ocean_token=XXX


# DigitalOcean provider configuration

provider "digitalocean" {
    token = "${var.digital_ocean_token}"
}
```

Where `TOKEN` is usually defined using a variable, e.g. `"${var.digital_ocean_token}"`, with its value set using an 
environment variable, e.g. `TF_VAR_digital_ocean_token=XXX`.

### Variables

* `domain`
    * The domain within DigitalOcean this module will create DNS records in
    * This variable is defined by WSR-1 and therefore **SHOULD NOT** be changed without good reason
    * See [DigitalOcean's API documentation](https://developers.digitalocean.com/#domains) for details
    * This value **MUST** be a domain in your DigitalOcean account as a string
    * Default: "do.net.nerc-bas.ac.uk"
* `sub_domains`
    * Any additional sub-domains (or other string) to be added before the domain variable
    * This variable **MUST** include any special characters (e.g. `.` or `-`) which should proceed/succeed this value
    * This value will always be outputted so it is at the end of the name or value properties as applicable
    * E.g if a sub-domain `testing` should be added, set this to ".testing" (note the preceding `.`)
    * This variable **MUST** be a valid DNS record name or value as a string
    * Default: "" (empty)
* `public_interface_label`
    * The term used for describing the public interface for a machine within DNS
    * This variable is defined by WSR-1 and therefore **SHOULD NOT** be changed without good reason
    * This variable **MUST** be a valid DNS record name or value as a string
    * Default: "ext"
* `private_interface_label`
    * The term used for describing the private interface for a machine within DNS
    * This variable is defined by WSR-1 and therefore **SHOULD NOT** be changed without good reason
    * This variable **MUST** be a valid DNS record name or value as a string
    * Default: "int"
* `hostname`
    * Identifier for a machine within DNS, usually its hostname
    * This variable **SHOULD** be consistent ideally following a convention
    * This variable **MUST** be a valid DNS record name or value as a string
    * This variable **MUST** be specified
    * Default: None
* `machine_interface_ipv4_public`
    * The IP used for connecting to the machine from the outside world
    * This variable **MUST** be a valid DNS `A` record value as a string
    * This variable **MUST** be specified
    * Default: None
* `machine_interface_ipv4_private`
    * The IP used for inter-machine communications within a data-centre
    * This variable **MUST** be a valid DNS `A` record value as a string
    * This variable **MUST** be specified
    * Default: None

### Define a set of records

E.g.

```ruby
# Resources

# 'MACHINE_LABEL' resource

# DNS records (public, private and default [which is an APEX record and points to public])

module "MACHINE_LABEL" {
    source = "github.com/antarctica/terraform-module-digital-ocean-records?ref=v1.0.2"
    hostname = "MACHINE_LABEL"
    machine_interface_ipv4_public = "${module.MACHINE_LABEL.ip_v4_address_public}"
    machine_interface_ipv4_private = "${module.MACHINE_LABEL.ip_v4_address_private}"
}
```

Where: `MACHINE_LABEL` is the name of the droplet (i.e. its hostname) and `${module.MACHINE_LABEL}` is a 
[DigitalOcean droplet resource](https://www.terraform.io/docs/providers/do/r/droplet.html).

E.g.

```ruby
# Resources

# 'lioncub-dev-node1' resource

# DNS records (public, private and default [which is an APEX record and points to public])

module "lioncub-dev-node1" {
    source = "github.com/antarctica/terraform-module-digital-ocean-records?ref=v1.0.2"
    hostname = "lioncub-dev-node1"
    machine_interface_ipv4_public = "${module.lioncub-dev-node1.ip_v4_address_public}"
    machine_interface_ipv4_private = "${module.lioncub-dev-node1.ip_v4_address_private}"
}
```

### Outputs

None.

## Contributions

This project welcomes contributions, see `CONTRIBUTING` for our general policy.

## Developing

### Committing changes

The [Git flow](https://www.atlassian.com/git/tutorials/comparing-workflows/gitflow-workflow) workflow is used to manage 
development of this package.

Discrete changes should be made within *feature* branches, created from and merged back into *develop* 
(where small one-line changes may be made directly).

When ready to release a set of features/changes create a *release* branch from *develop*, update documentation as 
required and merge into *master* with a tagged, [semantic version](http://semver.org/) (e.g. `v1.2.3`).

After releases the *master* branch should be merged with *develop* to restart the process. High impact bugs can be 
addressed in *hotfix* branches, created from and merged into *master* directly (and then into *develop*).

### Issue tracking

Issues, bugs, improvements, questions, suggestions and other tasks related to this package are managed through the BAS 
Web & Applications Team Jira project ([BASWEB](https://jira.ceh.ac.uk/browse/BASWEB)).

## License

Copyright 2015 NERC BAS. Licensed under the MIT license, see `LICENSE` for details.
