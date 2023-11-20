#
# Contextual Fields
#

variable "context" {
  description = <<-EOF
Receive contextual information. When Walrus deploys, Walrus will inject specific contextual information into this field.

Examples:
```
context:
  project:
    name: string
    id: string
  environment:
    name: string
    id: string
  resource:
    name: string
    id: string
```
EOF
  type        = map(any)
  default     = {}
}

#
# Infrastructure Fields
#

variable "infrastructure" {
  description = <<-EOF
Specify the infrastructure information for deploying.

Examples:
```
infrastructure:
  namespace: string, optional
  image_registry: string, optional
  domain_suffix: string, optional
```
EOF
  type = object({
    namespace      = optional(string)
    image_registry = optional(string, "registry-1.docker.io")
    domain_suffix  = optional(string, "cluster.local")
  })
  default = {}
}

#
# Deployment Fields
#

variable "architecture" {
  description = <<-EOF
Specify the deployment architecture, select from standalone or replication.
EOF
  type        = string
  default     = "standalone"
  validation {
    condition     = var.architecture == null || contains(["standalone", "replication"], var.architecture)
    error_message = "Invalid architecture"
  }
}

variable "replication_readonly_replicas" {
  description = <<-EOF
Specify the number of read-only replicas under the replication deployment.
EOF
  type        = number
  default     = 1
  validation {
    condition     = contains([1, 3, 5], var.replication_readonly_replicas)
    error_message = "Invalid number of read-only replicas"
  }
}

variable "engine_version" {
  description = <<-EOF
Specify the deployment engine version, select from https://hub.docker.com/r/bitnami/redis/tags.
EOF
  type        = string
  default     = "7.0"
}

variable "password" {
  description = <<-EOF
Specify the account password.
EOF
  type        = string
  default     = null
  sensitive   = true
  validation {
    condition     = var.password == null || can(regex("^[A-Za-z0-9\\!#\\$%\\^&\\*\\(\\)_\\+\\-=]{8,32}", var.password))
    error_message = "Invalid password"
  }
}

variable "resources" {
  description = <<-EOF
Specify the computing resources.

Examples:
```
resources:
  cpu: number, optional
  memory: number, optional       # in megabyte
```
EOF
  type = object({
    cpu    = optional(number, 0.25)
    memory = optional(number, 256)
  })
  default = {
    cpu    = 0.25
    memory = 256
  }
}

variable "storage" {
  description = <<-EOF
Specify the storage resources.

Examples:
```
storage:                         # convert to empty_dir volume or dynamic volume claim template
  class: string, optional
  size: number, optional         # in megabyte
```
EOF
  type = object({
    class = optional(string)
    size  = optional(number, 20 * 1024)
  })
  default = null
}
