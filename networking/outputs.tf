#--- networking/outputs.tf ---

output "vpc_id" {
  value = aws_vpc.tt_main_vpc.id
}


#--- database ---
output "db_subnet_group_name" {
  value = aws_db_subnet_group.tt_rds_subnetgroup.*.name
}

output "db_security_group" {
  value = [aws_security_group.tt_sg["rds"].id]
}


#--- loadbalancer ---

output "public_subnets" {
  value = aws_subnet.tt_public_subnet.*.id
}

output "public_sg" {
  value = [aws_security_group.tt_sg["public"].id]
}

