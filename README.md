# softcery-ping-pong

To run this scripts you will need Terraform and AWS CLI installed.
First, put this .tf files into folder and initiate it as terraform folder. Next, configure your aws cli with "aws configure" command. Also, create your local "variables.tfvars" file with next content:

aws_region        = YOUR_REGION
aws_access_key    = YOUR_AWS_ACCESS_KEY
aws_secret_key    = YOUR_AWS_SECRET_KEY

availability_zones = [LIST_OF_AVAILABILITY_ZONES]
public_subnets     = [LIST OF PUBLIC SUBNETS CIDR BLOCKS]

app_name        = "your app name"
app_environment = "any environment name(prod, dev, etc)"

Then you can run this terraform script.
After it execution you will see your vpn public ip and your load balancer dns.

To setup OpenVPN you need to find "key.pem" file in root folder of current disk. Then, using this key and vpn public ip do the ssh connection to your vpn server.
Switch to a root user, and in open "./root/client.ovpn" file, this is your openvpn configuration. Copy all its content to .ovpn file on your local computer. Now you can use it to connect to vpn server.
To check your server running, just turn on your OpvenVPN, and enter your_load_balancer_dns/ping in your browser.

Don't forget to run terraform destroy to save your AWS resources.
