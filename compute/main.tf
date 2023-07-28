#--- compute/main.tf ---

data "aws_ami" "server_ami" {
    most_recent = true
    owners = ["099720109477"]
    
    filter {
        name = "name"
        values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
    }
}


resource "random_id" "tt_node_id" {
    byte_length = 2
    count = var.instance_count
    keepers = {
        key_name = var.key_name
    }
}

resource "aws_key_pair" "tt_auth" {
    key_name = var.key_name
    public_key = file(var.public_key_path)
}

resource  "aws_instance" "tt_node" {
    count = var.instance_count
    instance_type = var.instance_type
    ami = data.aws_ami.server_ami.id
    tags = {
        Name = "tt_node-${random_id.tt_node_id[count.index].dec}"
    }

key_name = aws_key_pair.tt_auth.id
vpc_security_group_ids = var.public_sg
subnet_id = var.public_subnets[count.index]
user_data = templatefile(var.user_data_path,
    {
        nodename = "tt-node-${random_id.tt_node_id[count.index].dec}"
        dbuser = var.dbuser
        dbpass = var.dbpassword
        db_endpoint = var.db_endpoint
        dbname = var.dbname
    }
)
root_block_device {
    volume_size = var.vol_size
    }
}

resource "aws_lb_target_group_attachment" "tt_lb_attach" {
    count = var.instance_count
    target_group_arn = var.lb_target_group_arn
    target_id = aws_instance.tt_node[count.index].id
    port = 8000
}