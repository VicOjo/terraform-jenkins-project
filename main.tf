provider "aws" {
    region     = "us-east-1"
}

###Create a security group for RDS Aurora Instance in main.tf file

resource "aws_security_group" "allow_aurora" {
    name        = "Aurora_lab_sg"
    description = "Security group for RDS Aurora"   
  ingress {
      description      = "MYSQL/Aurora"
      from_port        = 3306
      to_port          = 3306
      protocol         = "tcp"
      cidr_blocks = ["0.0.0.0/0"]         
    }    
  egress {
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]         
    }           
  }  

###Create RDS Database Cluster and Instance in main.tf file

resource "aws_rds_cluster" "aurorards" {
    cluster_identifier      = "myauroracluster"
    engine                  = "aurora-mysql"
    database_name           = "MyDB"
    master_username         = "Admin"
    master_password         = "Admin123"
    vpc_security_group_ids = [aws_security_group.allow_aurora.id]
    storage_encrypted = false
    skip_final_snapshot   = true           
  }

resource "aws_rds_cluster_instance" "cluster_instances" {
    identifier         = "muaurorainstance"
    cluster_identifier = aws_rds_cluster.aurorards.id
    instance_class     = "db.t3.medium"
    engine             = aws_rds_cluster.aurorards.engine
    engine_version =      aws_rds_cluster.aurorards.engine_version
  }
