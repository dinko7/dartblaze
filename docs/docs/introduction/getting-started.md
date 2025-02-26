---
title: Getting Started
description: Learn how to get started with Dartblaze
---

# Getting Started with Dartblaze

Welcome to Dartblaze! This guide will help you set up your development environment and create your first Dart Cloud Function.

## Prerequisites

- Dart SDK (3.6.0 or higher)
- Firebase project with enabled billing (Blaze plan)
  - [Enable billing guide](https://docs.firerun.io/getting-started/upgrading-from-the-firebase-spark-plan-to-the-blaze-plan-tled)
- firebase CLI tools installed
  - [install guide](https://firebase.google.com/docs/cli#install_the_firebase_cli)
- gcloud CLI tools installed
  - [install guide](https://cloud.google.com/sdk/docs/install)

## Google Cloud Platform setup

Before you start using Dartblaze, please [enable](https://cloud.google.com/apis/docs/getting-started#enabling_apis) the following APIs in the GCP console:
- Cloud Run API
- EventArc API

Dartblaze uses Cloud Run, EventArc and other GCP components to deploy your functions.

## Setup the CLI

1. [Install the CLI](../cli.md#installation)
2. Run the `dartblaze doctor` command to make sure you have all the dependendencies installed locally
3. Login using the `dartblaze login` command


::: tip
The `login` command will also prompt you to login into `firebase` and `gcloud` if you are not already logged in.
:::
   

## Creating Your First Project

1. Create a new project by using `dartblaze new <project_name>`

2. List out your projects using `dartblaze projects:list`.
  
    Copy the project id of the project you would like to use.

3. Initialize the project

    ```bash
    dartblaze init -e <account_email> -p <project_id> 
    ```

    For email, use the same email that you use for Firebase.
    
    For project id, use one of the projects associated with your Firebase account.