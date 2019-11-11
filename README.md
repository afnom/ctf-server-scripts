# AFNOM CTFd setup scripts

At AFNOM, we frequently have to setup and run CTFs, so we thought we'd
properly put in some work making the infrastructure kinda nice.

## Deploying

This setup deploys a CTFd instance to Google Cloud.

1. Create a new Google Cloud Project
2. Generate a Service Account Key into `credentials/gcloud.json`

Then you can deploy the CTF:

    $ terraform init
    $ terraform apply
