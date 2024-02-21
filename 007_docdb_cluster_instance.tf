
resource "aws_docdb_cluster" "prod-docdb-cluster" {
  cluster_identifier = "prod-docdb-cluster"
  # availability_zones      = ["us-west-2a", "us-west-2c"]
  db_subnet_group_name    = aws_docdb_subnet_group.prod-db-subnet-group.name
  vpc_security_group_ids  = [aws_security_group.docdb-access.id]
  backup_retention_period = 5
  preferred_backup_window = "07:00-09:00"
  master_username         = "cloudsuite"
  master_password         = "cloudsuite"
  engine                  = "docdb"
  depends_on              = [aws_docdb_subnet_group.prod-db-subnet-group]
  skip_final_snapshot     = true
}

resource "aws_docdb_cluster_instance" "cluster_instances" {
  count              = 1
  identifier         = "prod-docdb-instance-${count.index}"
  cluster_identifier = aws_docdb_cluster.prod-docdb-cluster.id
  instance_class     = "db.t3.medium"
  depends_on         = [aws_docdb_cluster.prod-docdb-cluster]
}

#dev

resource "aws_docdb_cluster" "dev-docdb-cluster" {
  cluster_identifier = "dev-docdb-cluster"
  # availability_zones      = ["us-west-2a", "us-west-2c"]
  db_subnet_group_name    = aws_docdb_subnet_group.dev-db-subnet-group.name
  vpc_security_group_ids  = [aws_security_group.dev-docdb-access.id]
  backup_retention_period = 5
  preferred_backup_window = "07:00-09:00"
  master_username         = "cloudsuite"
  master_password         = "cloudsuite"
  engine                  = "docdb"
  depends_on              = [aws_docdb_subnet_group.dev-db-subnet-group]
  skip_final_snapshot     = true
}

resource "aws_docdb_cluster_instance" "dev-cluster_instances" {
  count              = 1
  identifier         = "dev-docdb-instance-${count.index}"
  cluster_identifier = aws_docdb_cluster.dev-docdb-cluster.id
  instance_class     = "db.t3.medium"
  depends_on         = [aws_docdb_cluster.dev-docdb-cluster]
}