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

### Setup

The setup script installs a custom CloudFormation macro to support encrypted system parameters (for security). This is required for some scripts to be able to securely store generated credentials.

### Dokku

The Dokku script launches an EC2 instance running a Debian AMI and installs Dokku with Postgres and LetsEncrypt plug-ins.

Run `./dokku` and follow the prompts to enter an application name, domain, email address for SSL cert registration, and instance type.

After completing successfully, the script will store an SSH key in `~/.ssh` to be used to log in to the new instance.

`ssh -i ~/.ssh/dokku-[App name]-key-pair.pem admin@[Domain or/IP address of instance]`

Configure the DNS records for your domain to point to the new IP address of the instance to use a domain name address.

Note: it may take up to 20 minutes to complete the post-launch installation and setup of Dokku, if it performs SSL parameter prime number generation. You can monitor the post-launch setup by logging in as above, then watching the log with: `tail -f /var/log/cloud-init-output.log`

The default instance type recommended by the script is t3a.small, which will cost about $14/mo. Note that Heroku buildbacks may not yet be supported by ARM64 processors.

### Email

The email script creates a new IAM user with permissions scoped to Simple Email Service sending.

Run `./email` and follow the prompts to enter an application name. The script will output the access key id and secret access key for the new user.

### Bucket

The bucket script creates a new S3 bucket and an IAM user with read/write priveleges on it. It will also set up an initial CORS configuration to allow a specified domain name access from the browser.

Run `./bucket` and follow the prompts to enter an application name and a host domain name. The script will output the newly generated bucket name, and the access key id and secret access key for the new user.

### Transcribe

The transcribe script creates a new IAM user with access to AWS Transcribe along with read/write privileges to a specified S3 bucket where audio and transcriptions will be stored.

Run `./transcribe` and follow the prompts to enter an application name and a bucket name. The script will output the access key id and secret access key for the new user.
