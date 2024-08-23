# AWS Client Scripts

These are a collection of scripts to provision resources in an Amazon Web Services account.

## Setup

### Docker-based Setup

1. Install Docker Desktop for your OS: https://www.docker.com/products/docker-desktop/

2. Clone this repository to a directory on your computer.

3. In a command-line shell, build the Docker image: `docker compose build aws-cli`

4. Copy `example.env` to `.env`

4. Run and enter the resulting image: `docker compose run --rm aws-cli bash -l`

### Local Setup

1. Install aws-cli and its dependencies: https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html

## Configure your AWS account

1. Sign up for an AWS account (note a credit card will be required): https://aws.amazon.com/

2. The root credentials used to sign up should be saved in a secure password manager and used sparingly. Create a new user for yourself in the IAM console, give it Administrator privileges, and generate an Access Key ID and Secret Access Key.

3. Configure these in the AWS client under "Long-term credentials" along with your desired default region: https://docs.aws.amazon.com/cli/latest/userguide/getting-started-quickstart.html

4. (Optional) If you have multiple AWS accounts, created named profiles for each, and set in `.env` if using Docker or set AWS_PROFILE in your shell environment otherwise: https://docs.aws.amazon.com/cli/v1/userguide/cli-configure-files.html

## Scripts

### Dokku

The Dokku script launches an EC2 instance running a Debian AMI, installs Dokku with Postgres and LetsEncrypt plug-ins, and attaches a public Elastic IP address. 

Run `./dokku` and follow the prompts to enter an application name, domain, email address for SSL cert registration, and instance type (default is t2.micro which is 12 month Free-Tier eligible in supported regions).

After completing successfully, the script will store an SSH key in `~/.ssh` to be used to log in to the new instance.

`ssh -i ~/.ssh/dokku-[App name]-key-pair.pem admin@[IP address of instance]`

Configure the DNS records for your domain to point to the new IP addres of the instance.

Note: it may take up to 20 minutes to complete the post-launch installation and setup of Dokku, due to SSL parameter prime number generation.



