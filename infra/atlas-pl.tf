resource "mongodbatlas_privatelink_endpoint" "atlaspl" {
  project_id    = mongodbatlas_project.aws_atlas.id
  provider_name = "AWS"
  region        = var.aws_region
}

resource "aws_vpc_endpoint" "ptfe_service" {
  vpc_id             = ""
  service_name       = mongodbatlas_privatelink_endpoint.atlaspl.endpoint_service_name
  vpc_endpoint_type  = "Interface"
  subnet_ids         = ["subnet-0b59f338bbc611881", "subnet-0dc494a5f4f6f20e3"]
  security_group_ids = ["sg-04876b5a38dd4878d"]
}

resource "mongodbatlas_privatelink_endpoint_service" "atlaseplink" {
  project_id          = mongodbatlas_privatelink_endpoint.atlaspl.project_id
  endpoint_service_id = aws_vpc_endpoint.ptfe_service.id
  private_link_id     = mongodbatlas_privatelink_endpoint.atlaspl.id
  provider_name       = "AWS"
}