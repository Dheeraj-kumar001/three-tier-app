# key pair (login)

resource aws_key_pair my_key {
    key_name = "terra-key-ec2"
    public_key = file("terra-key-ec2.pub")
}

#vpc &security group
resource  aws_default_vpc default  {
  
}
resource "aws_security_group " "my_security_group" {

    name = "automate-sg"
    description = "this will add a tf generated security group"
    vpc_id = aws_default_vpc.default.id #interpolation is way inwhich inherite to the value from tyerra form

    #inbound rule
    ingress {
        from_port = 22
        to_port = 22
        protocal = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        description = "ssh open"
    }
    ingress {
        from_port = 80
        to_port = 80
        protocal = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        description = "http open"
    }
    ingress {
        from_port = 8000
        to_port = 8000
        protocal = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        description = "flask app"
    }

    # outbound rules
    egress {
        from_port = 0
        to_port = 0
        protocal = "-1"
        cidr_blocks = ["0.0.0.0/0"]
        description = "all access open outbound"
    }
     tags = {
    Name = "automate-sg"
  }
  
}
# ec2 instance 
resource "aws_instance" "my_instance" {
    key_name = aws_key_pair.my_key.key_name
    security_groups = [aws_security_group.my_security_group.name]
    instance_type = "t2.micro"
    ami = "ami-04f167a56786e4b09"  # ubuntu
    root_block_device {
           volume_size = 15
           volume_type = "gp3"       

    }  

    tags = {
      Name = "three-tier-backend-server"
    }
}