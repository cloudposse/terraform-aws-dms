
<!-- markdownlint-disable -->
# terraform-aws-dms [![Latest Release](https://img.shields.io/github/release/cloudposse/terraform-aws-dms.svg)](https://github.com/cloudposse/terraform-aws-dms/releases/latest) [![Slack Community](https://slack.cloudposse.com/badge.svg)](https://slack.cloudposse.com) [![Discourse Forum](https://img.shields.io/discourse/https/ask.sweetops.com/posts.svg)](https://ask.sweetops.com/)
<!-- markdownlint-restore -->

[![README Header][readme_header_img]][readme_header_link]

[![Cloud Posse][logo]](https://cpco.io/homepage)

<!--




  ** DO NOT EDIT THIS FILE
  **
  ** This file was automatically generated by the `build-harness`.
  ** 1) Make all changes to `README.yaml`
  ** 2) Run `make init` (you only need to do this once)
  ** 3) Run`make readme` to rebuild this file.
  **
  ** (We maintain HUNDREDS of open source projects. This is how we maintain our sanity.)
  **





-->

Terraform modules for provisioning and managing AWS [DMS](https://aws.amazon.com/dms/) resources. 

The following DMS resources are supported:

  - [IAM Roles for DMS](modules/dms-iam)
  - [DMS Endpoints](modules/dms-endpoint)
  - [DMS Replication Instances](modules/dms-replication-instance)
  - [DMS Replication Tasks](modules/dms-replication-task)
  - [DMS Event Subscriptions](modules/dms-event-subscription)

Refer to [modules](modules) for more details.

---

This project is part of our comprehensive ["SweetOps"](https://cpco.io/sweetops) approach towards DevOps.
[<img align="right" title="Share via Email" src="https://docs.cloudposse.com/images/ionicons/ios-email-outline-2.0.1-16x16-999999.svg"/>][share_email]
[<img align="right" title="Share on Google+" src="https://docs.cloudposse.com/images/ionicons/social-googleplus-outline-2.0.1-16x16-999999.svg" />][share_googleplus]
[<img align="right" title="Share on Facebook" src="https://docs.cloudposse.com/images/ionicons/social-facebook-outline-2.0.1-16x16-999999.svg" />][share_facebook]
[<img align="right" title="Share on Reddit" src="https://docs.cloudposse.com/images/ionicons/social-reddit-outline-2.0.1-16x16-999999.svg" />][share_reddit]
[<img align="right" title="Share on LinkedIn" src="https://docs.cloudposse.com/images/ionicons/social-linkedin-outline-2.0.1-16x16-999999.svg" />][share_linkedin]
[<img align="right" title="Share on Twitter" src="https://docs.cloudposse.com/images/ionicons/social-twitter-outline-2.0.1-16x16-999999.svg" />][share_twitter]




It's 100% Open Source and licensed under the [APACHE2](LICENSE).
















## Usage




For a complete example, see [examples/complete](examples/complete).

For automated tests of the example using [bats](https://github.com/bats-core/bats-core) and [Terratest](https://github.com/gruntwork-io/terratest)
(which tests and deploys the example on AWS), see [test](test).




## Examples


```hcl
  module "dms_iam" {
    source = "cloudposse/dms/aws//modules/dms-iam"
    # Cloud Posse recommends pinning every module to a specific version
    # version     = "x.x.x"
  
    context = module.this.context
  }

  module "vpc" {
    source  = "cloudposse/vpc/aws"
    # Cloud Posse recommends pinning every module to a specific version
    # version     = "x.x.x"
  
    ipv4_primary_cidr_block = "172.19.0.0/16"
  
    context = module.this.context
  }

  module "subnets" {
    source  = "cloudposse/dynamic-subnets/aws"
    # Cloud Posse recommends pinning every module to a specific version
    # version     = "x.x.x"
  
    availability_zones   = ["us-east-2a", "us-east-2b"]
    vpc_id               = local.vpc_id
    igw_id               = [module.vpc.igw_id]
    ipv4_cidr_block      = [module.vpc.vpc_cidr_block]
    nat_gateway_enabled  = false
    nat_instance_enabled = false
  
    context = module.this.context
  }
  
  module "dms_replication_instance" {
    source = "cloudposse/dms/aws//modules/dms-replication-instance"
    # Cloud Posse recommends pinning every module to a specific version
    # version     = "x.x.x"
  
    engine_version               = "3.4.7"
    replication_instance_class   = "dms.t2.micro"
    allocated_storage            = 10
    apply_immediately            = true
    auto_minor_version_upgrade   = true
    allow_major_version_upgrade  = false
    multi_az                     = false
    publicly_accessible          = false
    preferred_maintenance_window = "sun:10:30-sun:14:30"
    vpc_security_group_ids       = [module.vpc.vpc_default_security_group_id]
    subnet_ids                   = module.subnets.private_subnet_ids
  
    context = module.this.context
  
    depends_on = [
      # The required DMS roles must be present before replication instances can be provisioned
      module.dms_iam
    ]
  }
  
  module "aurora_postgres_cluster" {
    source  = "cloudposse/rds-cluster/aws"
    # Cloud Posse recommends pinning every module to a specific version
    # version     = "x.x.x"
  
    engine                               = "aurora-postgresql"
    engine_mode                          = "provisioned"
    engine_version                       = "13.4"
    cluster_family                       = "aurora-postgresql13"
    cluster_size                         = 1
    admin_user                           = "admin"
    admin_password                       = "admin_password"
    db_name                              = "postgres"
    db_port                              = 5432
    instance_type                        = "db.t3.medium"
    vpc_id                               = module.vpc.vpc_id
    subnets                              = module.subnets.private_subnet_ids
    security_groups                      = [module.vpc.vpc_default_security_group_id]
    deletion_protection                  = false
    autoscaling_enabled                  = false
    storage_encrypted                    = false
    intra_security_group_traffic_enabled = false
    skip_final_snapshot                  = true
    enhanced_monitoring_role_enabled     = false
    iam_database_authentication_enabled  = false
  
    context = module.this.context
  }
  
  module "dms_endpoint_aurora_postgres" {
    source = "cloudposse/dms/aws//modules/dms-endpoint"
    # Cloud Posse recommends pinning every module to a specific version
    # version     = "x.x.x"
  
    endpoint_type                   = "source"
    engine_name                     = "aurora-postgresql"
    server_name                     = module.aurora_postgres_cluster.reader_endpoint
    database_name                   = "postgres"
    port                            = 5432
    username                        = "admin"
    password                        = "admin_password"
    extra_connection_attributes     = ""
    secrets_manager_access_role_arn = null
    secrets_manager_arn             = null
    ssl_mode                        = "none"
  
    context = module.this.context
  }
  
  module "s3_bucket" {
    source  = "cloudposse/s3-bucket/aws"
    # Cloud Posse recommends pinning every module to a specific version
    # version     = "x.x.x"
  
    acl                          = "private"
    versioning_enabled           = false
    force_destroy                = true
    allow_encrypted_uploads_only = true
    allow_ssl_requests_only      = true
    block_public_acls            = true
    block_public_policy          = true
    ignore_public_acls           = true
    restrict_public_buckets      = true
  
    context = module.this.context
  }
  
  module "dms_endpoint_s3_bucket" {
    source = "cloudposse/dms/aws//modules/dms-endpoint"
    # Cloud Posse recommends pinning every module to a specific version
    # version     = "x.x.x"
  
    endpoint_type = "target"
    engine_name   = "s3"
  
    s3_settings = {
      bucket_name                      = module.s3_bucket.bucket_id
      bucket_folder                    = null
      cdc_inserts_only                 = false
      csv_row_delimiter                = " "
      csv_delimiter                    = ","
      data_format                      = "parquet"
      compression_type                 = "GZIP"
      date_partition_delimiter         = "NONE"
      date_partition_enabled           = true
      date_partition_sequence          = "YYYYMMDD"
      include_op_for_full_load         = true
      parquet_timestamp_in_millisecond = true
      timestamp_column_name            = "timestamp"
      service_access_role_arn          = aws_iam_role.s3.arn
    }
  
    extra_connection_attributes = ""
  
    context = module.this.context
  }
  
  module "dms_replication_task" {
    source = "cloudposse/dms/aws//modules/dms-replication-task"
    # Cloud Posse recommends pinning every module to a specific version
    # version     = "x.x.x"
  
    replication_instance_arn = module.dms_replication_instance.replication_instance_arn
    start_replication_task   = true
    migration_type           = "full-load-and-cdc"
    source_endpoint_arn      = module.dms_endpoint_aurora_postgres.endpoint_arn
    target_endpoint_arn      = module.dms_endpoint_s3_bucket.endpoint_arn
  
    replication_task_settings = file("${path.module}/config/replication-task-settings.json")
    table_mappings            = file("${path.module}/config/replication-task-table-mappings.json")
  
    context = module.this.context
  }
  
  module "sns_topic" {
    source  = "cloudposse/sns-topic/aws"
    # Cloud Posse recommends pinning every module to a specific version
    # version     = "x.x.x"
  
    allowed_aws_services_for_sns_published = ["cloudwatch.amazonaws.com"]
    sqs_dlq_enabled                        = false
    fifo_topic                             = false
    fifo_queue_enabled                     = false
    encryption_enabled                     = false  

    context = module.this.context
  }
  
  module "dms_replication_instance_event_subscription" {
    source = "cloudposse/dms/aws//modules/dms-event-subscription"
    # Cloud Posse recommends pinning every module to a specific version
    # version     = "x.x.x"
  
    event_subscription_enabled = true
    event_categories           = ["creation", "failure"]
    source_type                = "replication-instance"
    source_ids                 = [module.dms_replication_instance.replication_instance_id]
    sns_topic_arn              = module.sns_topic.sns_topic_arn
  
    attributes = ["instance"]
    context = module.this.context
  }
  
  module "dms_replication_task_event_subscription" {
    source = "cloudposse/dms/aws//modules/dms-event-subscription"
    # Cloud Posse recommends pinning every module to a specific version
    # version     = "x.x.x"
  
    event_subscription_enabled = true
    event_categories           = ["creation", "failure"]
    source_type                = "replication-task"
    source_ids                 = [module.dms_replication_task.replication_task_id]
    sns_topic_arn              = module.sns_topic.sns_topic_arn
  
    attributes = ["task"]
    context = module.this.context
  }
```



<!-- markdownlint-disable -->
## Makefile Targets
```text
Available targets:

  help                                Help screen
  help/all                            Display help for all targets
  help/short                          This help short screen
  lint                                Lint terraform code

```
<!-- markdownlint-restore -->
<!-- markdownlint-disable -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.26.0 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_this"></a> [this](#module\_this) | cloudposse/label/null | 0.25.0 |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_additional_tag_map"></a> [additional\_tag\_map](#input\_additional\_tag\_map) | Additional key-value pairs to add to each map in `tags_as_list_of_maps`. Not added to `tags` or `id`.<br>This is for some rare cases where resources want additional configuration of tags<br>and therefore take a list of maps with tag key, value, and additional configuration. | `map(string)` | `{}` | no |
| <a name="input_attributes"></a> [attributes](#input\_attributes) | ID element. Additional attributes (e.g. `workers` or `cluster`) to add to `id`,<br>in the order they appear in the list. New attributes are appended to the<br>end of the list. The elements of the list are joined by the `delimiter`<br>and treated as a single ID element. | `list(string)` | `[]` | no |
| <a name="input_context"></a> [context](#input\_context) | Single object for setting entire context at once.<br>See description of individual variables for details.<br>Leave string and numeric variables as `null` to use default value.<br>Individual variable settings (non-null) override settings in context object,<br>except for attributes, tags, and additional\_tag\_map, which are merged. | `any` | <pre>{<br>  "additional_tag_map": {},<br>  "attributes": [],<br>  "delimiter": null,<br>  "descriptor_formats": {},<br>  "enabled": true,<br>  "environment": null,<br>  "id_length_limit": null,<br>  "label_key_case": null,<br>  "label_order": [],<br>  "label_value_case": null,<br>  "labels_as_tags": [<br>    "unset"<br>  ],<br>  "name": null,<br>  "namespace": null,<br>  "regex_replace_chars": null,<br>  "stage": null,<br>  "tags": {},<br>  "tenant": null<br>}</pre> | no |
| <a name="input_delimiter"></a> [delimiter](#input\_delimiter) | Delimiter to be used between ID elements.<br>Defaults to `-` (hyphen). Set to `""` to use no delimiter at all. | `string` | `null` | no |
| <a name="input_descriptor_formats"></a> [descriptor\_formats](#input\_descriptor\_formats) | Describe additional descriptors to be output in the `descriptors` output map.<br>Map of maps. Keys are names of descriptors. Values are maps of the form<br>`{<br>   format = string<br>   labels = list(string)<br>}`<br>(Type is `any` so the map values can later be enhanced to provide additional options.)<br>`format` is a Terraform format string to be passed to the `format()` function.<br>`labels` is a list of labels, in order, to pass to `format()` function.<br>Label values will be normalized before being passed to `format()` so they will be<br>identical to how they appear in `id`.<br>Default is `{}` (`descriptors` output will be empty). | `any` | `{}` | no |
| <a name="input_enabled"></a> [enabled](#input\_enabled) | Set to false to prevent the module from creating any resources | `bool` | `null` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | ID element. Usually used for region e.g. 'uw2', 'us-west-2', OR role 'prod', 'staging', 'dev', 'UAT' | `string` | `null` | no |
| <a name="input_id_length_limit"></a> [id\_length\_limit](#input\_id\_length\_limit) | Limit `id` to this many characters (minimum 6).<br>Set to `0` for unlimited length.<br>Set to `null` for keep the existing setting, which defaults to `0`.<br>Does not affect `id_full`. | `number` | `null` | no |
| <a name="input_label_key_case"></a> [label\_key\_case](#input\_label\_key\_case) | Controls the letter case of the `tags` keys (label names) for tags generated by this module.<br>Does not affect keys of tags passed in via the `tags` input.<br>Possible values: `lower`, `title`, `upper`.<br>Default value: `title`. | `string` | `null` | no |
| <a name="input_label_order"></a> [label\_order](#input\_label\_order) | The order in which the labels (ID elements) appear in the `id`.<br>Defaults to ["namespace", "environment", "stage", "name", "attributes"].<br>You can omit any of the 6 labels ("tenant" is the 6th), but at least one must be present. | `list(string)` | `null` | no |
| <a name="input_label_value_case"></a> [label\_value\_case](#input\_label\_value\_case) | Controls the letter case of ID elements (labels) as included in `id`,<br>set as tag values, and output by this module individually.<br>Does not affect values of tags passed in via the `tags` input.<br>Possible values: `lower`, `title`, `upper` and `none` (no transformation).<br>Set this to `title` and set `delimiter` to `""` to yield Pascal Case IDs.<br>Default value: `lower`. | `string` | `null` | no |
| <a name="input_labels_as_tags"></a> [labels\_as\_tags](#input\_labels\_as\_tags) | Set of labels (ID elements) to include as tags in the `tags` output.<br>Default is to include all labels.<br>Tags with empty values will not be included in the `tags` output.<br>Set to `[]` to suppress all generated tags.<br>**Notes:**<br>  The value of the `name` tag, if included, will be the `id`, not the `name`.<br>  Unlike other `null-label` inputs, the initial setting of `labels_as_tags` cannot be<br>  changed in later chained modules. Attempts to change it will be silently ignored. | `set(string)` | <pre>[<br>  "default"<br>]</pre> | no |
| <a name="input_name"></a> [name](#input\_name) | ID element. Usually the component or solution name, e.g. 'app' or 'jenkins'.<br>This is the only ID element not also included as a `tag`.<br>The "name" tag is set to the full `id` string. There is no tag with the value of the `name` input. | `string` | `null` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | ID element. Usually an abbreviation of your organization name, e.g. 'eg' or 'cp', to help ensure generated IDs are globally unique | `string` | `null` | no |
| <a name="input_regex_replace_chars"></a> [regex\_replace\_chars](#input\_regex\_replace\_chars) | Terraform regular expression (regex) string.<br>Characters matching the regex will be removed from the ID elements.<br>If not set, `"/[^a-zA-Z0-9-]/"` is used to remove all characters other than hyphens, letters and digits. | `string` | `null` | no |
| <a name="input_stage"></a> [stage](#input\_stage) | ID element. Usually used to indicate role, e.g. 'prod', 'staging', 'source', 'build', 'test', 'deploy', 'release' | `string` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Additional tags (e.g. `{'BusinessUnit': 'XYZ'}`).<br>Neither the tag keys nor the tag values will be modified by this module. | `map(string)` | `{}` | no |
| <a name="input_tenant"></a> [tenant](#input\_tenant) | ID element \_(Rarely used, not included by default)\_. A customer identifier, indicating who this instance of a resource is for | `string` | `null` | no |

## Outputs

No outputs.
<!-- markdownlint-restore -->



## Share the Love

Like this project? Please give it a ★ on [our GitHub](https://github.com/cloudposse/terraform-aws-dms)! (it helps us **a lot**)

Are you using this project or any of our other projects? Consider [leaving a testimonial][testimonial]. =)



## Related Projects

Check out these related projects.

- [terraform-aws-components](https://github.com/cloudposse/terraform-aws-components) - Catalog of terraform AWS components


## References

For additional context, refer to some of these links.

- [AWS Database Migration Service](https://aws.amazon.com/dms) - AWS Database Migration Service
- [AWS Database Migration Service Documentation](https://docs.aws.amazon.com/dms/index.html) - AWS Database Migration Service Documentation


## Help

**Got a question?** We got answers.

File a GitHub [issue](https://github.com/cloudposse/terraform-aws-dms/issues), send us an [email][email] or join our [Slack Community][slack].

[![README Commercial Support][readme_commercial_support_img]][readme_commercial_support_link]

## DevOps Accelerator for Startups


We are a [**DevOps Accelerator**][commercial_support]. We'll help you build your cloud infrastructure from the ground up so you can own it. Then we'll show you how to operate it and stick around for as long as you need us.

[![Learn More](https://img.shields.io/badge/learn%20more-success.svg?style=for-the-badge)][commercial_support]

Work directly with our team of DevOps experts via email, slack, and video conferencing.

We deliver 10x the value for a fraction of the cost of a full-time engineer. Our track record is not even funny. If you want things done right and you need it done FAST, then we're your best bet.

- **Reference Architecture.** You'll get everything you need from the ground up built using 100% infrastructure as code.
- **Release Engineering.** You'll have end-to-end CI/CD with unlimited staging environments.
- **Site Reliability Engineering.** You'll have total visibility into your apps and microservices.
- **Security Baseline.** You'll have built-in governance with accountability and audit logs for all changes.
- **GitOps.** You'll be able to operate your infrastructure via Pull Requests.
- **Training.** You'll receive hands-on training so your team can operate what we build.
- **Questions.** You'll have a direct line of communication between our teams via a Shared Slack channel.
- **Troubleshooting.** You'll get help to triage when things aren't working.
- **Code Reviews.** You'll receive constructive feedback on Pull Requests.
- **Bug Fixes.** We'll rapidly work with you to fix any bugs in our projects.

## Slack Community

Join our [Open Source Community][slack] on Slack. It's **FREE** for everyone! Our "SweetOps" community is where you get to talk with others who share a similar vision for how to rollout and manage infrastructure. This is the best place to talk shop, ask questions, solicit feedback, and work together as a community to build totally *sweet* infrastructure.

## Discourse Forums

Participate in our [Discourse Forums][discourse]. Here you'll find answers to commonly asked questions. Most questions will be related to the enormous number of projects we support on our GitHub. Come here to collaborate on answers, find solutions, and get ideas about the products and services we value. It only takes a minute to get started! Just sign in with SSO using your GitHub account.

## Newsletter

Sign up for [our newsletter][newsletter] that covers everything on our technology radar.  Receive updates on what we're up to on GitHub as well as awesome new projects we discover.

## Office Hours

[Join us every Wednesday via Zoom][office_hours] for our weekly "Lunch & Learn" sessions. It's **FREE** for everyone!

[![zoom](https://img.cloudposse.com/fit-in/200x200/https://cloudposse.com/wp-content/uploads/2019/08/Powered-by-Zoom.png")][office_hours]

## Contributing

### Bug Reports & Feature Requests

Please use the [issue tracker](https://github.com/cloudposse/terraform-aws-dms/issues) to report any bugs or file feature requests.

### Developing

If you are interested in being a contributor and want to get involved in developing this project or [help out](https://cpco.io/help-out) with our other projects, we would love to hear from you! Shoot us an [email][email].

In general, PRs are welcome. We follow the typical "fork-and-pull" Git workflow.

 1. **Fork** the repo on GitHub
 2. **Clone** the project to your own machine
 3. **Commit** changes to your own branch
 4. **Push** your work back up to your fork
 5. Submit a **Pull Request** so that we can review your changes

**NOTE:** Be sure to merge the latest changes from "upstream" before making a pull request!



## Copyrights

Copyright © 2022-2022 [Cloud Posse, LLC](https://cloudposse.com)





## License

[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

See [LICENSE](LICENSE) for full details.

```text
Licensed to the Apache Software Foundation (ASF) under one
or more contributor license agreements.  See the NOTICE file
distributed with this work for additional information
regarding copyright ownership.  The ASF licenses this file
to you under the Apache License, Version 2.0 (the
"License"); you may not use this file except in compliance
with the License.  You may obtain a copy of the License at

  https://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing,
software distributed under the License is distributed on an
"AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
KIND, either express or implied.  See the License for the
specific language governing permissions and limitations
under the License.
```









## Trademarks

All other trademarks referenced herein are the property of their respective owners.

## About

This project is maintained and funded by [Cloud Posse, LLC][website]. Like it? Please let us know by [leaving a testimonial][testimonial]!

[![Cloud Posse][logo]][website]

We're a [DevOps Professional Services][hire] company based in Los Angeles, CA. We ❤️  [Open Source Software][we_love_open_source].

We offer [paid support][commercial_support] on all of our projects.

Check out [our other projects][github], [follow us on twitter][twitter], [apply for a job][jobs], or [hire us][hire] to help with your cloud strategy and implementation.



### Contributors

<!-- markdownlint-disable -->
|  [![Erik Osterman][osterman_avatar]][osterman_homepage]<br/>[Erik Osterman][osterman_homepage] | [![Andriy Knysh][aknysh_avatar]][aknysh_homepage]<br/>[Andriy Knysh][aknysh_homepage] |
|---|---|
<!-- markdownlint-restore -->

  [osterman_homepage]: https://github.com/osterman
  [osterman_avatar]: https://img.cloudposse.com/150x150/https://github.com/osterman.png
  [aknysh_homepage]: https://github.com/aknysh
  [aknysh_avatar]: https://img.cloudposse.com/150x150/https://github.com/aknysh.png

[![README Footer][readme_footer_img]][readme_footer_link]
[![Beacon][beacon]][website]
<!-- markdownlint-disable -->
  [logo]: https://cloudposse.com/logo-300x69.svg
  [docs]: https://cpco.io/docs?utm_source=github&utm_medium=readme&utm_campaign=cloudposse/terraform-aws-dms&utm_content=docs
  [website]: https://cpco.io/homepage?utm_source=github&utm_medium=readme&utm_campaign=cloudposse/terraform-aws-dms&utm_content=website
  [github]: https://cpco.io/github?utm_source=github&utm_medium=readme&utm_campaign=cloudposse/terraform-aws-dms&utm_content=github
  [jobs]: https://cpco.io/jobs?utm_source=github&utm_medium=readme&utm_campaign=cloudposse/terraform-aws-dms&utm_content=jobs
  [hire]: https://cpco.io/hire?utm_source=github&utm_medium=readme&utm_campaign=cloudposse/terraform-aws-dms&utm_content=hire
  [slack]: https://cpco.io/slack?utm_source=github&utm_medium=readme&utm_campaign=cloudposse/terraform-aws-dms&utm_content=slack
  [linkedin]: https://cpco.io/linkedin?utm_source=github&utm_medium=readme&utm_campaign=cloudposse/terraform-aws-dms&utm_content=linkedin
  [twitter]: https://cpco.io/twitter?utm_source=github&utm_medium=readme&utm_campaign=cloudposse/terraform-aws-dms&utm_content=twitter
  [testimonial]: https://cpco.io/leave-testimonial?utm_source=github&utm_medium=readme&utm_campaign=cloudposse/terraform-aws-dms&utm_content=testimonial
  [office_hours]: https://cloudposse.com/office-hours?utm_source=github&utm_medium=readme&utm_campaign=cloudposse/terraform-aws-dms&utm_content=office_hours
  [newsletter]: https://cpco.io/newsletter?utm_source=github&utm_medium=readme&utm_campaign=cloudposse/terraform-aws-dms&utm_content=newsletter
  [discourse]: https://ask.sweetops.com/?utm_source=github&utm_medium=readme&utm_campaign=cloudposse/terraform-aws-dms&utm_content=discourse
  [email]: https://cpco.io/email?utm_source=github&utm_medium=readme&utm_campaign=cloudposse/terraform-aws-dms&utm_content=email
  [commercial_support]: https://cpco.io/commercial-support?utm_source=github&utm_medium=readme&utm_campaign=cloudposse/terraform-aws-dms&utm_content=commercial_support
  [we_love_open_source]: https://cpco.io/we-love-open-source?utm_source=github&utm_medium=readme&utm_campaign=cloudposse/terraform-aws-dms&utm_content=we_love_open_source
  [terraform_modules]: https://cpco.io/terraform-modules?utm_source=github&utm_medium=readme&utm_campaign=cloudposse/terraform-aws-dms&utm_content=terraform_modules
  [readme_header_img]: https://cloudposse.com/readme/header/img
  [readme_header_link]: https://cloudposse.com/readme/header/link?utm_source=github&utm_medium=readme&utm_campaign=cloudposse/terraform-aws-dms&utm_content=readme_header_link
  [readme_footer_img]: https://cloudposse.com/readme/footer/img
  [readme_footer_link]: https://cloudposse.com/readme/footer/link?utm_source=github&utm_medium=readme&utm_campaign=cloudposse/terraform-aws-dms&utm_content=readme_footer_link
  [readme_commercial_support_img]: https://cloudposse.com/readme/commercial-support/img
  [readme_commercial_support_link]: https://cloudposse.com/readme/commercial-support/link?utm_source=github&utm_medium=readme&utm_campaign=cloudposse/terraform-aws-dms&utm_content=readme_commercial_support_link
  [share_twitter]: https://twitter.com/intent/tweet/?text=terraform-aws-dms&url=https://github.com/cloudposse/terraform-aws-dms
  [share_linkedin]: https://www.linkedin.com/shareArticle?mini=true&title=terraform-aws-dms&url=https://github.com/cloudposse/terraform-aws-dms
  [share_reddit]: https://reddit.com/submit/?url=https://github.com/cloudposse/terraform-aws-dms
  [share_facebook]: https://facebook.com/sharer/sharer.php?u=https://github.com/cloudposse/terraform-aws-dms
  [share_googleplus]: https://plus.google.com/share?url=https://github.com/cloudposse/terraform-aws-dms
  [share_email]: mailto:?subject=terraform-aws-dms&body=https://github.com/cloudposse/terraform-aws-dms
  [beacon]: https://ga-beacon.cloudposse.com/UA-76589703-4/cloudposse/terraform-aws-dms?pixel&cs=github&cm=readme&an=terraform-aws-dms
<!-- markdownlint-restore -->
