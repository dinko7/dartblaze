---
title: Deployment Guide
description: Learn how to deploy your Dart Cloud Functions to Firebase
---
# Deploying Your Functions

This guide covers everything you need to know about deploying Dartblaze functions to Firebase.


## Deployment Steps

1. Run code generation
    ```bash
    dart run build_runner build -d
    ```

    This will generate the required bolierplate code and the deployment configuration.

    ::: warning
    You must run `build_runner` every time your add or remove a functions in order to generate the new deployment config.
    :::

2. Deploy the function
    ```bash
    dartblaze deploy <function-name> --region=<database_region>
    ```

    ::: warning
    You can only deploy one function at a time
    :::