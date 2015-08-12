# Terraform Module - DigitalOcean Records

Specifies an opinionated set of DigitalOcean DNS Record resources for a DigitalOcean 'Droplet'.

## Overview

The public and private network interfaces for a DigitalOcean VM will be created as "namespaced" `A` records. A `CNAME` record will be created to act as a default interface which points to the `A` record for public interface.

For example, a VM with a host name: `menagerie-prod-node1` this module would create 3 DNS records:

| Type    | Name                          | Value                                            | FQDN                                             | Notes                             |
| ------- | ----------------------------- | ------------------------------------------------ | ------------------------------------------------ | --------------------------------- |
| `A`     | menagerie-prod-node1.internal | 10.131.190.89                                    | menagerie-prod-node1.internal.web.nerc-bas.ac.uk | The VM's private IP address       |
| `A`     | menagerie-prod-node1.external | 178.62.124.75                                    | menagerie-prod-node1.external.web.nerc-bas.ac.uk | The VM's public IP address        |
| `CNAME` | menagerie-prod-node1          | menagerie-prod-node1.external.web.nerc-bas.ac.uk | menagerie-prod-node1.web.nerc-bas.ac.uk          | A pointer for the default address |

## Availability

This module is designed for internal use but if useful can be shared publicly.

## Usage

### Requirements

Somewhere in your project you must have specified an access token for the DigitalOcean provider like this:

```
# Digital Ocean provider configuration

provider "digitalocean" {
    token = "TOKEN"
}
```

Where `TOKEN` is usually defined using a variable, e.g. `"${var.digital_ocean_token}"`.

### Variables

* `domain`
    * The domain within DigitalOcean this module will create DNS records in.
    * See [DigitalOcean's API documentation](https://developers.digitalocean.com/#domains) for details.
    * This value **MUST** be a domain in your DigitalOcean account as a string.
    * Default: "web.nerc-bas.ac.uk"
* `sub_domains`
    * Any additional sub-domains (or other string) to be added before the domain variable.
    * This variable **MUST** include any special characters (such as `.` or `-`) which should proceed or succeed this value.
    * This value will always be outputted so it is at the end of the name or value properties as applicable.
    * For example if an additional sub-domain `testing` should be added this variable would be set to ".testing" (note the `.` before the value to make it a sub-domain).
    * This variable **MUST** be a valid DNS record name or value as a string.
    * Default: "" (empty)
* `public_interface_label`
    * The term used for describing the public interface for a machine within DNS.
    * This variable **SHOULD** be consistent ideally following a convention.
    * This variable **MUST** be a valid DNS record name or value as a string.
    * Default: "external"
* `private_interface_label`
    * The term used for describing the private interface for a machine within DNS.
    * This variable **SHOULD** be consistent ideally following a convention.
    * This variable **MUST** be a valid DNS record name or value as a string.
    * Default: "internal"
* `hostname`
    * Identifier for a machine within DNS, usually its hostname.
    * This variable **SHOULD** be consistent ideally following a convention.
    * This variable **MUST** be a valid DNS record name or value as a string.
    * This variable **MUST** be specified.
    * Default: None
* `machine_interface_ipv4_public`
    * The IP used for connecting to the machine from the outside world.
    * This variable **MUST** be a valid DNS `A` record value as a string.
    * This variable **MUST** be specified.
    * Default: None
* `machine_interface_ipv4_private`
    * The IP used for inter-machine communications within a data-centre.
    * This variable **MUST** be a valid DNS `A` record value as a string.
    * This variable **MUST** be specified.
    * Default: None

### Define a set of records

E.g.

```ruby
# Resources

# 'MACHINE_LABEL' resource

# DNS records (public, private and default [which is an APEX record and points to public])

module "MACHINE_LABEL" {
    source = "github.com/antarctica/terraform-module-digital-ocean-record"
    hostname = "MACHINE_LABEL"
    machine_interface_ipv4_public = "${module.MACHINE_LABEL.ip_v4_address_public}"
    machine_interface_ipv4_private = "${module.MACHINE_LABEL.ip_v4_address_private}"
}
```

Where: `MACHINE_LABEL` is the name of the droplet (i.e. its hostname) and `${module.MACHINE_LABEL}` is a [DigitalOcean droplet resource](https://www.terraform.io/docs/providers/do/r/droplet.html).

E.g.

```ruby
# Resources

# 'lioncub-dev-node1' resource

# DNS records (public, private and default [which is an APEX record and points to public])

module "lioncub-dev-node1" {
    source = "github.com/antarctica/terraform-module-digital-ocean-record?ref=v0.1.0"
    hostname = "lioncub-dev-node1"
    machine_interface_ipv4_public = "${module.lioncub-dev-node1.ip_v4_address_public}"
    machine_interface_ipv4_private = "${module.lioncub-dev-node1.ip_v4_address_private}"
}
```

### Outputs

None.

## Limitations

* [Terraform #57](https://github.com/hashicorp/terraform/issues/57) - It isn't currently possible to set Terraform from Environment variables, and therefore a `terraform.tfvars`
file is needed as a stand-in. This is annoying and is a limitation of the software.

## Contributions

This project welcomes contributions, see `CONTRIBUTING` for our general policy.

## Developing

### Committing changes

The [Git flow](https://www.atlassian.com/git/tutorials/comparing-workflows/gitflow-workflow) workflow is used to manage development of this package.

Discrete changes should be made within *feature* branches, created from and merged back into *develop* (where small one-line changes may be made directly).

When ready to release a set of features/changes create a *release* branch from *develop*, update documentation as required and merge into *master* with a tagged, [semantic version](http://semver.org/) (e.g. `v1.2.3`).

After releases the *master* branch should be merged with *develop* to restart the process. High impact bugs can be addressed in *hotfix* branches, created from and merged into *master* directly (and then into *develop*).

### Issue tracking

Issues, bugs, improvements, questions, suggestions and other tasks related to this package are managed through the BAS Web & Applications Team Jira project ([BASWEB](https://jira.ceh.ac.uk/browse/BASWEB)).

## License

Copyright 2015 NERC BAS. Licensed under the MIT license, see `LICENSE` for details.
