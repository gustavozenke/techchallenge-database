terraform {
  required_providers {
    mongodbatlas = {
      source = "mongodb/mongodbatlas"
    }
    aws = {
      source = "hashicorp/aws"
    }
  }
}

provider "mongodbatlas" {
  public_key  = var.public_key
  private_key = var.private_key
}

resource "mongodbatlas_project" "aws_atlas" {
  name   = var.atlas_project_name
  org_id = "66fbcffc7b182447158d815c"
}

resource "mongodbatlas_database_user" "db-user" {
  username           = var.atlas_dbuser
  password           = var.atlas_dbpassword
  project_id = mongodbatlas_project.aws_atlas.id
  auth_database_name = "admin"
  roles {
    role_name     = "readWrite"
    database_name = "${var.atlas_project_name}-db"
  }
}

resource "mongodbatlas_project_ip_access_list" "cidr_block" {
  project_id = mongodbatlas_project.aws_atlas.id
  cidr_block = "10.0.0.0/16"
  comment    = "cidr block for AWS VPC"
}

resource "mongodbatlas_advanced_cluster" "atlas-cluster" {
  project_id = mongodbatlas_project.aws_atlas.id
  name = "${var.atlas_project_name}-cluster"
  cluster_type = "REPLICASET"
  backup_enabled = true
  mongo_db_major_version =  6.0
  replication_specs {
    region_configs {
      electable_specs {
        instance_size = "M0"
        node_count    = 3
      }
      analytics_specs {
        instance_size = "M0"
        node_count    = 1
      }
      priority      = 7
      provider_name = "AWS"
      region_name   = var.atlas_region
    }
  }
}

data "mongodbatlas_advanced_cluster" "atlas-cluser" {
  project_id = mongodbatlas_project.aws_atlas.id
  name       = mongodbatlas_advanced_cluster.atlas-cluster.name
  depends_on = [mongodbatlas_privatelink_endpoint_service.atlaseplink]
}

output "atlas_cluster_connection_string" { value = mongodbatlas_advanced_cluster.atlas-cluster.connection_strings.0.standard_srv }
output "ip_access_list"    { value = mongodbatlas_project_ip_access_list.cidr_block.cidr_block }
output "project_name"      { value = mongodbatlas_project.aws_atlas.name }
output "username"          { value = mongodbatlas_database_user.db-user.username }
output "user_password"     {
  sensitive = true
  value = mongodbatlas_database_user.db-user.password
}
